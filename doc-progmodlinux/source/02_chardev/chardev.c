/* chardev.c 
 * Copyright (C) 1998-1999 by Ori Pomerantz
 * 
 * Crea un dispositivo de carácter (sólo lectura)
 */

/* Los ficheros de cabeceras necesarios */

/* Estándar en los módulos del núcleo */
#include <linux/kernel.h>   /* Estamos haciendo trabajo del núcleo */
#include <linux/module.h>   /* Específicamente, un módulo */

/* Distribuido con CONFIG_MODVERSIONS */
#if CONFIG_MODVERSIONS==1
#define MODVERSIONS
#include <linux/modversions.h>
#endif        

/* Para dispositivos de carácter */
#include <linux/fs.h>       /* Las definiciones de dispositivos 
                             * de carácter están aquí */
#include <linux/wrapper.h>  /* Un envoltorio que 
                             * no hace nada actualmente,
                             * pero que quizás ayude para
                             * compatibilizar con futuras
                             * versiones de Linux */


/* En 2.2.3 /usr/include/linux/version.h incluye
 * una macro para esto, pero 2.0.35 no lo hace - por lo 
 * tanto lo añado aquí si es necesario */
#ifndef KERNEL_VERSION
#define KERNEL_VERSION(a,b,c) ((a)*65536+(b)*256+(c))
#endif


/* Compilación condicional. LINUX_VERSION_CODE es
 * el código (como KERNEL_VERSION) de esta versión */
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,2,0)
#include <asm/uaccess.h>  /* for put_user */
#endif

			     

#define SUCCESS 0


/* Declaraciones de Dispositivo **************************** */

/* El nombre de nuestro dispositivo, tal como aparecerá 
 * en /proc/devices */
#define DEVICE_NAME "char_dev"


/* La máxima longitud del mensaje desde el dispositivo */
#define BUF_LEN 80

/* ¿Está el dispositivo abierto correctamente ahora? Usado para 
 * prevenir el acceso concurrente en el mismo dispositivo */
static int Device_Open = 0;

/* El mensaje que el dispositivo dará cuando preguntemos */
static char Message[BUF_LEN];

/* ¿Cuánto más tiene que coger el proceso durante la lectura?
 * Útil si el mensaje es más grande que el tamaño
 * del buffer que cogemos para rellenar en device_read. */ 
static char *Message_Ptr;


/* Esta función es llamada cuando un proceso
 * intenta abrir el fichero del dispositivo */
static int device_open(struct inode *inode, 
		       struct file *file)
{
  static int counter = 0;

#ifdef DEBUG
  printk ("Dispositivo abierto(%p,%p)\n", inode, file);
#endif

  /* Esto es como coger el número menor del dispositivo
   * en el caso de que tengas más de un dispositivo físico
   * usando el controlador */
  printk("Dispositivo: %d.%d\n", 
	 inode->i_rdev >> 8, inode->i_rdev & 0xFF);

  /* No queremos que dos procesos hablen al mismo tiempo */
  if (Device_Open)
    return -EBUSY;

  /* Si había un proceso, tendremos que tener más
   * cuidado aquí.
   *
   * En el caso de procesos, el peligro es que un 
   * proceso quizás esté chequeando Device_Open y
   * entonces sea reemplazado por el planificador por otro
   * proceso que ejecuta esta función. Cuando
   * el primer proceso regrese a la CPU, asumirá que el
   * dispositivo no está abierto todavía.
   *
   * De todas formas, Linux garantiza que un proceso no
   * será reemplazado mientras se está ejecutando en el
   * contexto del núcleo.
   *
   * En el caso de SMP, una CPU quizás incremente
   * Device_Open mientras otra CPU está aquí, correcto
   * después de chequear. De todas formas, en la versión
   * 2.0 del núcleo esto no es un problema por que hay un
   * cierre que garantiza que sólamente una CPU estará en
   * el módulo del núcleo en un mismo instante. Esto es malo
   * en términos de rendimiento, por lo tanto la versión 2.2
   * lo cambió. Desgraciadamente, no tengo acceso a un 
   * equipo SMP para comprobar si funciona con SMP.
   */

  Device_Open++;

  /* Inicializa el mensaje. */
  sprintf(Message, 
    "Si te lo dije una vez, te lo digo %d veces - %s",
    counter++,
    "Hola, mundo\n");
  /* El único motivo por el que se nos permite hacer este
   * sprintf es porque la máxima longitud del mensaje
   * (asumiendo enteros de 32 bits - hasta 10 dígitos 
   * con el signo menos) es menor que BUF_LEN, el cual es 80.
   * ¡¡TEN CUIDADO NO HAGAS DESBORDAMIENTO DE PILA EN LOS BUFFERS,
   * ESPECIALMENTE EN EL NÚCLEO!!! */

  Message_Ptr = Message;

  /* Nos aseguramos de que el módulo no es borrado mientras
   * el fichero está abierto incrementando el contador de uso
   * (el número de referencias abiertas al módulo, si no es
   * cero rmmod fallará) */
  MOD_INC_USE_COUNT;

  return SUCCESS;
}


/* Esta función es llamada cuando un proceso cierra el
 * fichero del dispositivo. No tiene un valor de retorno en
 * la versión 2.0.x porque no puede fallar (SIEMPRE debes de ser
 * capaz de cerrar un dispositivo). En la versión 2.2.x
 * está permitido que falle - pero no le dejaremos. */

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
static int device_release(struct inode *inode, 
			  struct file *file)
#else 
static void device_release(struct inode *inode, 
			   struct file *file)
#endif
{
#ifdef DEBUG
  printk ("dispositivo_liberado(%p,%p)\n", inode, file);
#endif
 
  /* Ahora estamos listos para la siguiente petición*/
  Device_Open --;

  /* Decrementamos el contador de uso, en otro caso una vez que
   * hayas abierto el fichero no volverás a coger el módulo.
   */
  MOD_DEC_USE_COUNT;

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
  return 0;
#endif
}


/* Esta función es llamada cuando un proceso que ya
 * ha abierto el fichero del dispositivo intenta leer de él. */

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
static ssize_t device_read(struct file *file,
    char *buffer,    /* El buffer a rellenar con los datos */
    size_t length,   /* La longitud del buffer */
    loff_t *offset)  /* Nuestro desplazamiento en el fichero */
#else
static int device_read(struct inode *inode,
                       struct file *file,
    char *buffer,   /* El buffer para rellenar con 
		     * los datos */ 
    int length)     /* La longitud del buffer 
                     * (¡no debemos escribir más allá de él!) */
#endif
{
  /* Número de bytes actualmente escritos en el buffer */
  int bytes_read = 0;

  /* si estamos al final del mensaje, devolvemos 0 
   * (lo cual significa el final del fichero) */
  if (*Message_Ptr == 0)
    return 0;

  /* Ponemos los datos en el buffer */
  while (length && *Message_Ptr)  {

    /* Porque el buffer está en el segmento de datos del usuario
     * y no en el segmento de datos del núcleo, la asignación
     * no funcionará. En vez de eso, tenemos que usar put_user,
     * el cual copia datos desde el segmento de datos del núcleo
     * al segmento de datos del usuario. */
    put_user(*(Message_Ptr++), buffer++);


    length --;
    bytes_read ++;
  }

#ifdef DEBUG
   printk ("%d bytes leidos, quedan %d\n",
     bytes_read, length);
#endif

   /* Las funciones de lectura se supone que devuelven el
    * número de bytes realmente insertados en el buffer */
  return bytes_read;
}




/* Se llama a esta función cuando alguien intenta escribir
 * en nuestro fichero de dispositivo - no soportado en este
 * ejemplo. */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
static ssize_t device_write(struct file *file,
    const char *buffer,    /* El buffer */
    size_t length,   /* La longitud del buffer */
    loff_t *offset)  /* Nuestro desplazamiento en el fichero */
#else
static int device_write(struct inode *inode,
                        struct file *file,
                        const char *buffer,
                        int length)
#endif
{
  return -EINVAL;
}




/* Declaraciones del Módulo ***************************** */

/* El número mayor para el dispositivo. Esto es
 * global (bueno, estático, que en este contexto es global
 * dentro de este fichero) porque tiene que ser accesible
 * para el registro y para la liberación. */
static int Major;

/* Esta estructura mantendrá las funciones que son llamadas
 * cuando un proceso hace algo al dispositivo que nosotros creamos.
 * Ya que un puntero a esta estructura se mantiene en
 * la tabla de dispositivos, no puede ser local a
 * init_module. NULL es para funciones no implementadas. */

struct file_operations Fops = {
  NULL,   /* búsqueda */
  device_read, 
  device_write,
  NULL,   /* readdir */
  NULL,   /* seleccionar */
  NULL,   /* ioctl */
  NULL,   /* mmap */
  device_open,
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
  NULL,   /* borrar */
#endif
  device_release  /* a.k.a. cerrar */
};


/* Inicializa el módulo - Registra el dispositivo de carácter */
int init_module()
{
  /* Registra el dispositivo de carácter (por lo menos lo intenta) */
  Major = module_register_chrdev(0, 
                                 DEVICE_NAME,
                                 &Fops);

  /* Valores negativos significan un error */
  if (Major < 0) {
    printk ("dispositivo %s falló con %d\n",
	    "Lo siento, registrando el carácter",
	    Major);
    return Major;
  }

  printk ("%s El número mayor del dispositivo es %d.\n",
          "El registro es un éxito.",
          Major);
  printk ("si quieres hablar con el controlador del dispositivo,\n");
  printk ("tendrás que crear un fichero de dispositivo. \n");
  printk ("Te sugerimos que uses:\n");
  printk ("mknod <nombre> c %d <menor>\n", Major);
  printk ("Puedes probar diferentes números menores %s",
          "y ver que pasa.\n");

  return 0;
}


/* Limpieza - liberamos el fichero correspondiente desde /proc */
void cleanup_module()
{
  int ret;

  /* liberamos el dispositivo */
  ret = module_unregister_chrdev(Major, DEVICE_NAME);
 
  /* Si hay un error, lo indicamos */ 
  if (ret < 0)
    printk("Error en unregister_chrdev: %d\n", ret);
}  

