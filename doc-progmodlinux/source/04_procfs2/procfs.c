/* procfs.c -  crea un "fichero" en /proc, que permite 
 * entrada y salida. */

/* Copyright (C) 1998-1999 by Ori Pomerantz */


/* Los ficheros de cabeceras necesarios */

/* Estándar en los módulos del núcleo */
#include <linux/kernel.h>   /* Estamos haciendo trabajo del núcleo */
#include <linux/module.h>   /* Específicamente, un módulo */

/* Distribuido con CONFIG_MODVERSIONS */
#if CONFIG_MODVERSIONS==1
#define MODVERSIONS
#include <linux/modversions.h>
#endif        

/* Necesario porque usamos el sistema de ficheros proc */
#include <linux/proc_fs.h>


/* En 2.2.3 /usr/include/linux/version.h se incluye
 * una macro para eso, pero 2.0.35 no lo hace - por lo
 * tanto lo añado aquí si es necesario */
#ifndef KERNEL_VERSION
#define KERNEL_VERSION(a,b,c) ((a)*65536+(b)*256+(c))
#endif



#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
#include <asm/uaccess.h>  /* para get_user y put_user */
#endif

/* Las funciones del fichero del módulo ********************** */


/* Aquí mantenemos el último mensaje recibido, para
 * comprobar que podemos procesar nuestra entrada */ 
#define MESSAGE_LENGTH 80
static char Message[MESSAGE_LENGTH];


/* Desde que usamos la estructura de operaciones de fichero. 
 * podemos usar las provisiones de salida especiales de proc - 
 * tenemos que usar una función de lectura estándar, y es
 * esta función */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
static ssize_t module_output(
    struct file *file,   /* El fichero leído */
    char *buf, /* El buffer donde se van a poner los datos 
                * (en el segmento de usuario) */
    size_t len,  /* La longitud del buffer */
    loff_t *offset) /* Desplazamiento en el fichero - ignóralo */
#else
static int module_output(
    struct inode *inode, /* El inodo leído */
    struct file *file,   /* El fichero leído */
    char *buf, /* El buffer donde se van a poner los datos
                * (en el segmento de usuario) */
    int len)  /* La longitud del buffer */
#endif
{
  static int finished = 0;
  int i;
  char message[MESSAGE_LENGTH+30];

  /* Retornamos 0 para indicar el final del fichero, que 
   * no tenemos más información. En otro caso, los procesos
   * continuarán leyendo de nosotros en un bucle sin fin. */ 
  if (finished) {
    finished = 0;
    return 0;
  }

  /* Usamos put_user para copiar la cadena de caracteres del
   * segmento de memoria del núcleo al segmento de memoria de
   * proceso que nos llamó. get_user, BTW, es usado para
   * lo contrario. */
  sprintf(message, "Last input:%s", Message);
  for(i=0; i<len && message[i]; i++) 
    put_user(message[i], buf+i);


  /* Nota, asumimos aquí que el tamaño del mensaje está por
   * debajo de la longitud, o se recibirá cortado. En una
   * situación de la vida real, si el tamaño del mensaje es menor
   * que la longitud entonces retornamos la longitud y en la 
   * segunda llamada empezamos a rellenar el buffer con el byte
   * longitud+1 del mensaje. */
  finished = 1; 

  return i;  /* Retornamos el número de bytes "leidos" */
}


/* Esta función recibe la entrada del usuario cuando el
 * usuario escribe en el fichero /proc. */ 
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
static ssize_t module_input(
    struct file *file,   /* El mismo fichero */
    const char *buf,     /* El buffer con la entrada */
    size_t length,       /* La longitud del buffer */
    loff_t *offset)      /* desplazamiento del fichero - ignóralo */
#else
static int module_input(
    struct inode *inode, /* El inodo del fichero */
    struct file *file,   /* El mismo fichero */
    const char *buf,     /* El buffer con la entrada */
    int length)          /* La longitud del buffer */
#endif
{
  int i;

  /* Pone la entrada en Message, donde module_output 
   * posteriormente será capaz de usarlo */
  for(i=0; i<MESSAGE_LENGTH-1 && i<length; i++)
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
    get_user(Message[i], buf+i);
  /* En la versión 2.2 la semántica de get_user cambió,
   * no volverá a devolver un carácter, excepto una
   * variable para rellenar como primer argumento y 
   * un puntero al segmento de usuario para rellenarlo 
   * como segundo.
   *
   * El motivo para este cambio es que en la versión 2.2
   * get_user puede leer un short o un int. La forma
   * en la que conoce el tipo de la variable que 
   * debería de leer es usando sizeof, y para lo que 
   * necesita la variable.
   */ 
#else 
    Message[i] = get_user(buf+i);
#endif
  Message[i] = '\0';  /* queremos un estándar, cadena 
                       * de caracteres terminada en cero */
  
  /* Necesitamos devolver el número de caracteres de entrada
   * usados */ 
  return i;
}



/* Esta función decide si permite una operación (retorna cero)
 * o no la permite (retornando distinto de cero, lo cual indica porqué
 * no está permitido).
 *
 * La operación puede ser uno de los siguientes valores:
 * 0 - Ejecuta (ejecuta el "fichero" - sin sentido en nuestro caso)
 * 2 - Escribe (entrada en el módulo del núcleo)
 * 4 - Lee (salida desde el módulo del núcleo)
 *
 * Esta es la función real que chequea los permisos del
 * fichero. Los permisos retornados por ls -l son sólo
 * para referencia, y pueden ser sobreescritos aquí. 
 */
static int module_permission(struct inode *inode, int op)
{
  /* Permitimos a todo el mundo leer desde nuestro módulo, pero 
   * sólo root (uid 0) puede escribir en el */ 
  if (op == 4 || (op == 2 && current->euid == 0))
    return 0; 

  /* Si es algún otro, el acceso es denegado */
  return -EACCES;
}




/* El fichero está abierto - realmente no nos preocupamos de
 * esto, pero significa que necesitamos incrementar el
 * contador de referencias del módulo. */ 
int module_open(struct inode *inode, struct file *file)
{
  MOD_INC_USE_COUNT;
 
  return 0;
}


/* El fichero está cerrado - otra vez, interesante sólo por
 * el contador de referencias. */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
int module_close(struct inode *inode, struct file *file)
#else
void module_close(struct inode *inode, struct file *file)
#endif
{
  MOD_DEC_USE_COUNT;

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
  return 0;  /* realizado con éxito */
#endif
}


/* Estructuras para registrar el fichero /proc, con
 * punteros a todas las funciones relevantes. ********** */


/* Las operaciones del fichero para nuestro fichero proc. Es aquí
 * donde colocamos los punteros a todas las funciones llamadas
 * cuando alguien intenta hacer algo en nuestro fichero. NULL
 * significa que no queremos tratar con algo. */
static struct file_operations File_Ops_4_Our_Proc_File =
  {
    NULL,  /* lseek */
    module_output,  /* "lee" desde el fichero */
    module_input,   /* "escribe" en el fichero */
    NULL,  /* readdir */
    NULL,  /* select */
    NULL,  /* ioctl */
    NULL,  /* mmap */
    module_open,    /* Alguien abrió el fichero */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
    NULL,   /* borrado, añadido aquí en la versión 2.2 */
#endif
    module_close,    /* Alguien cerró el fichero */
    /* etc. etc. etc. ( son todas dadas en
     * /usr/include/linux/fs.h). Ya que no ponemos nada
     * más aquí, el sistema mantendrá los datos por defecto
     * que en Unix son ceros (NULLs cuando cogemos
     * punteros). */
  };



/* Las operaciones del inodo para nuestro fichero proc. Las necesitamos,
 * por lo tanto tendremos algún lugar para especificar las 
 * estructuras de operaciones del fichero que queremos usar. También es
 * posible especificar funciones a ser llamadas para cualquier cosa
 * que pudiera ser hecha en un inodo (como no queremos molestar, 
 * las ponemos a NULL). */
static struct inode_operations Inode_Ops_4_Our_Proc_File =
  {
    &File_Ops_4_Our_Proc_File,
    NULL, /* crear */
    NULL, /* lookup */
    NULL, /* enlazar */
    NULL, /* desenlazar */
    NULL, /* enlace simbólico */
    NULL, /* mkdir */
    NULL, /* rmdir */
    NULL, /* mknod */
    NULL, /* renombrar */
    NULL, /* leer enlace */
    NULL, /* seguir el enlace */
    NULL, /* leer página */
    NULL, /* escribir página */
    NULL, /* bmap */
    NULL, /* cortar */
    module_permission /* chequeo para permisos */
  };


/* Entrada de directorio */
static struct proc_dir_entry Our_Proc_File = 
  {
    0, /* Número de inodo - ignóralo, será automáticamente rellenado
        * por proc_register[_dynamic] */ 
    7, /* Longitud del nombre del fichero */
    "rw_test", /* El nombre del fichero */
    S_IFREG | S_IRUGO | S_IWUSR, 
    /* Modo del fichero - este es un fichero normal el cual
     * puede ser leído por su dueño, su grupo, y por todo el 
     * mundo. También, su dueño puede escribir en él.
     *
     * Realmente, este campo es sólo para referencia, es
     * module_permission el que hace el chequeo actual.
     * Puede usar este campo, pero en nuestra implementación 
     * no lo hace, por simplificación. */
    1,  /* Número de enlaces (directorios donde el fichero 
         * está referenciado) */
    0, 0,  /* El uid y gid para el fichero - 
            * se lo damos a root */
    80, /* El tamaño del fichero reportado por ls. */
    &Inode_Ops_4_Our_Proc_File, 
    /* Un puntero a la estructura del inodo para
     * el fichero, si lo necesitamos. En nuestro caso
     * lo hacemos, porque necesitamos una función de escritura. */
    NULL  
    /* La función de lectura para el fichero. Irrelevante
     * porque lo ponemos en la estructura de inodo anterior */
  }; 



/* Inicialización del módulo y limpieza ******************* */

/* Inicializa el módulo - registra el fichero proc */
int init_module()
{
  /* Tiene éxito si proc_register[_dynamic] tiene éxito, 
   * falla en otro caso */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
  /* En la versión 2.2, proc_register asigna dinámicamente un número de
   * inodo automáticamente si hay un cero en la estructura, por lo 
   * tanto no se necesita más para proc_register_dynamic
   */
  return proc_register(&proc_root, &Our_Proc_File);
#else
  return proc_register_dynamic(&proc_root, &Our_Proc_File);
#endif
}


/* Limpieza - liberamos nuestro fichero de /proc */
void cleanup_module()
{
  proc_unregister(&proc_root, Our_Proc_File.low_ino);
}  
