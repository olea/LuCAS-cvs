/* chardev.c 
 * 
 * Crea un dispositivo de entrada/salida de carácter
 */


/* Copyright (C) 1998-99 por Ori Pomerantz */



/* Los ficheros de cabeceras necesarios */

/* Estándar en módulos del núcleo */
#include <linux/kernel.h>   /* Estamos haciendo trabajo del núcleo */
#include <linux/module.h>   /* Específicamente, un módulo */

/* Distribuido con CONFIG_MODVERSIONS */
#if CONFIG_MODVERSIONS==1
#define MODVERSIONS
#include <linux/modversions.h>
#endif        

/* Para dispositivos de carácter */

/* Las definiciones de dispositivo de carácter están aquí */
#include <linux/fs.h>       

/* Un envoltorio el cual no hace nada en la 
 * actualidad, pero que quizás ayude para compatibilizar
 * con futuras versiones de Linux */
#include <linux/wrapper.h>  

			     
/* Nuestros propios números ioctl */
#include "chardev.h"


/* En 2.2.3 /usr/include/linux/version.h se incluye una
 * macro para esto, pero 2.0.35 no lo hace - por lo tanto
 * lo añado aquí si es necesario. */
#ifndef KERNEL_VERSION
#define KERNEL_VERSION(a,b,c) ((a)*65536+(b)*256+(c))
#endif



#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
#include <asm/uaccess.h>  /* para get_user y put_user */
#endif



#define SUCCESS 0


/* Declaraciones de Dispositivo ******************************** */


/* el nombre de nuestro dispositivo, tal como aparecerá en 
 * /proc/devices */
#define DEVICE_NAME "char_dev"


/* La máxima longitud del mensaje para nuestro dispositivo */
#define BUF_LEN 80


/* ¿Está el dispositivo correctamente abierto ahora? Usado
 * para evitar acceso concurrente al mismo dispositivo */
static int Device_Open = 0;

/* El mensaje que el dispositivo nos dará cuando preguntemos */
static char Message[BUF_LEN];

/* ¿Cuanto puede coger el proceso para leer el mensaje?
 * Útil si el mensaje es más grande que el tamaño del
 * buffer que tenemos para rellenar en device_read. */
static char *Message_Ptr;


/* Esta función es llamada cuando un proceso intenta
 * abrir el fichero de dispositivo */
static int device_open(struct inode *inode, 
                       struct file *file)
{
#ifdef DEBUG
  printk ("device_open(%p)\n", file);
#endif

  /* No queremos hablar con dos procesos a la vez */ 
  if (Device_Open)
    return -EBUSY;

  /* Si esto era un proceso, tenemos que tener más cuidado aquí,
   * porque un proceso quizás haya chequeado Device_Open correctamente
   * antes de que el otro intentara incrementarlo. De cualquier forma,
   * estamos en el núcleo, por lo tanto estamos protegidos contra
   * los cambios de contexto.
   *
   * Esta NO es la actitud correcta a tomar, porque quizás estemos
   * ejecutándonos en un sistema SMP, pero trataremos con SMP
   * en un capítulo posterior.
   */

  Device_Open++;

  /* Inicializa el mensaje */
  Message_Ptr = Message;

  MOD_INC_USE_COUNT;

  return SUCCESS;
}


/* Esta función se llama cuando un proceso cierra el
 * fichero del dispositivo. No tiene un valor de retorno
 * porque no puede fallar. Sin pérdida de consideración de
 * lo que pudiera pasar, deberías de poder cerrar siempre un
 * dispositivo (en 2.0, un fichero de dispositivo 2.2 puede
 * ser imposible de cerrar). */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
static int device_release(struct inode *inode, 
                          struct file *file)
#else
static void device_release(struct inode *inode, 
                           struct file *file)
#endif
{
#ifdef DEBUG
  printk ("device_release(%p,%p)\n", inode, file);
#endif
 
  /* Ahora estamos listos para la siguiente llamada */
  Device_Open --;

  MOD_DEC_USE_COUNT;

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
  return 0;
#endif
}



/* Esta función se llama cuando un proceso que ya
 * ha abierto el fichero del dispositivo intenta leer
 * de él. */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
static ssize_t device_read(
    struct file *file,
    char *buffer, /* El buffer para rellenar con los datos */   
    size_t length,     /* La longitud del buffer */
    loff_t *offset) /* desplazamiento en el fichero */
#else
static int device_read(
    struct inode *inode,
    struct file *file,
    char *buffer,   /* El buffer para rellenar con los datos */ 
    int length)     /* La longitud del buffer 
                     * (¡no debemos de escribir más allá de él!) */
#endif
{
  /* Número de bytes actualmente escritos en el buffer */
  int bytes_read = 0;

#ifdef DEBUG
  printk("device_read(%p,%p,%d)\n",
    file, buffer, length);
#endif

  /* Si estamos al final del mensaje, retornamos 0
   * (lo cual significa el final del fichero) */
  if (*Message_Ptr == 0)
    return 0;

  /* Realmente ponemos los datos en el buffer */
  while (length && *Message_Ptr)  {

    /* Como el buffer está en el segmento de datos del usuario
     * y no en el segmento de datos del núcleo, la asignación
     * no funcionará. En vez de ello, tenemos que usar put_user
     * el cual copia datos desde el segmento de datos del núcleo
     * al segmento de datos del usuario. */
    put_user(*(Message_Ptr++), buffer++);
    length --;
    bytes_read ++;
  }

#ifdef DEBUG
   printk ("Leídos %d bytes, quedan %d\n",
     bytes_read, length);
#endif

   /* Las funciones de lectura se supone que devuelven el número 
    * de bytes realmente insertados en el buffer */
  return bytes_read;
}


/* Esta función se llama cuando alguien intenta
 * escribir en nuestro fichero de dispositivo. */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
static ssize_t device_write(struct file *file,
                            const char *buffer,
                            size_t length,
                            loff_t *offset)
#else
static int device_write(struct inode *inode,
                        struct file *file,
                        const char *buffer,
                        int length)
#endif
{
  int i;

#ifdef DEBUG
  printk ("device_write(%p,%s,%d)",
    file, buffer, length);
#endif

  for(i=0; i<length && i<BUF_LEN; i++)
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
    get_user(Message[i], buffer+i);
#else
    Message[i] = get_user(buffer+i);
#endif  

  Message_Ptr = Message;

  /* De nuevo, retornamos el número de caracteres de entrada usados */
  return i;
}


/* Esta función es llamada cuando un proceso intenta realizar
 * una ioctl en nuestro fichero de dispositivo. Cogemos dos
 * parámetros extra (en adición al inodo y a las estructuras
 * del fichero, los cuales cogen todas las funciones de dispositivo): el
 * número de ioctl llamado y el parámetro dado a la función ioctl. 
 * 
 * Si el ioctl es de escritura o de lectura/escritura (significa
 * que la salida es devuelta al proceso que llama), la llamada ioctl
 * retorna la salida de esta función.
 */
int device_ioctl(
    struct inode *inode,
    struct file *file,
    unsigned int ioctl_num,/* El número de ioctl */
    unsigned long ioctl_param) /* El parámetro a él */
{
  int i;
  char *temp;
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
  char ch;
#endif

  /* Se intercambia de acuerdo al ioctl llamado */
  switch (ioctl_num) {
    case IOCTL_SET_MSG:
      /* Recibe un puntero al mensaje (en el espacio de usuario)
       * y establece lo que será el mensaje del dispositivo. */

      /* Coge el parámetro dado a ioctl por el proceso */
      temp = (char *) ioctl_param;
   
      /* Encuentra la longitud del mensaje */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
      get_user(ch, temp);
      for (i=0; ch && i<BUF_LEN; i++, temp++)
        get_user(ch, temp);
#else
      for (i=0; get_user(temp) && i<BUF_LEN; i++, temp++)
	;
#endif

      /* No reinventa la rueda - llama a device_write */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
      device_write(file, (char *) ioctl_param, i, 0);
#else
      device_write(inode, file, (char *) ioctl_param, i);
#endif
      break;

    case IOCTL_GET_MSG:
      /* Da el mensaje actual al proceso llamador - el parámetro
       * que damos en un puntero, lo rellena. */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
      i = device_read(file, (char *) ioctl_param, 99, 0); 
#else
      i = device_read(inode, file, (char *) ioctl_param, 
                      99); 
#endif
      /* Peligro - asumimos aquí que la longitud del buffer es
       * 100. Si es menor de lo que tenemos quizás desborde el
       * buffer, causando que el proceso vuelque la memoria.
       *
       * El motivo por el que permitimos hasta 99 caracteres es
       * que el NULL que termina la cadena de caracteres también
       * necesita sitio. */

      /* Pone un cero al final del buffer, por lo
       * tanto estará correctamente terminado */
      put_user('\0', (char *) ioctl_param+i);
      break;

    case IOCTL_GET_NTH_BYTE:
      /* Este ioctl es para entrada (ioctl_param) y
       * para salida (el valor de retorno de esta función) */
      return Message[ioctl_param];
      break;
  }

  return SUCCESS;
}


/* Declaraciones del Módulo *************************** */


/* Esta estructura mantendrá las funciones a ser llamadas
 * cuando un proceso realiza algo al dispositivo que hemos
 * creado. Desde que un puntero a esta estructura es mantenido
 * en la tabla de dispositivos, no puede ser local a init_module.
 * NULL es para funciones no implementadas. */
struct file_operations Fops = {
  NULL,   /* búsqueda */
  device_read, 
  device_write,
  NULL,   /* readdir */
  NULL,   /* selección */
  device_ioctl,   /* ioctl */
  NULL,   /* mmap */
  device_open,
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
  NULL,  /* borrar */
#endif
  device_release  /* cerrar */
};


/* Inicializa el módulo - Registra el dispositivo de carácter */
int init_module()
{
  int ret_val;

  /* Registra el dispositivo de carácter (por lo menos lo intenta) */
  ret_val = module_register_chrdev(MAJOR_NUM, 
                                 DEVICE_NAME,
                                 &Fops);

  /* Valores negativos significan un error */
  if (ret_val < 0) {
    printk ("%s falló con %d\n",
            "Lo siento, registrando el dispositivo de carácter ",
            ret_val);
    return ret_val;
  }

  printk ("%s El número mayor del dispositivo es %d.\n",
          "El registro es un éxito", 
          MAJOR_NUM);
  printk ("si quieres hablar con el controlador del dispositivo,\n");
  printk ("tienes que crear el fichero del dispositivo. \n");
  printk ("Te sugerimos que uses:\n");
  printk ("mknod %s c %d 0\n", DEVICE_FILE_NAME, 
          MAJOR_NUM);
  printk ("El nombre del fichero del dispositivo es muy importante, porque\n");
  printk ("el programa ioctl asume que es el\n");
  printk ("fichero que usarás.\n");

  return 0;
}


/* Limpieza - libera el fichero apropiado de /proc */
void cleanup_module()
{
  int ret;

  /* libera el dispositivo */
  ret = module_unregister_chrdev(MAJOR_NUM, DEVICE_NAME);
 
  /* Si hay un error,informa de ello*/ 
  if (ret < 0)
    printk("Error en module_unregister_chrdev: %d\n", ret);
}  




