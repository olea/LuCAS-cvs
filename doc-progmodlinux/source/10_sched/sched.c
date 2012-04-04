/* sched.c - planifica una función para ser llamada en
 * cada interrupción del reloj */


/* Copyright (C) 1998 por Ori Pomerantz */


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

/* Planificamos tareas aquí */
#include <linux/tqueue.h>

/* También necesitamos la habilidad para ponernos a dormir
 * y despertanos más tarde */
#include <linux/sched.h>

/* En 2.2.3 /usr/include/linux/version.h se incluye una
 * macro para esto, pero 2.0.35 no lo hace - por lo tanto
 * lo añado aquí si es necesario. */
#ifndef KERNEL_VERSION
#define KERNEL_VERSION(a,b,c) ((a)*65536+(b)*256+(c))
#endif



/* El número de veces que la interrupción del reloj
 * ha sido llamada */
static int TimerIntrpt = 0;


/* Esto lo usa cleanup, para evitar que el módulo
 * sea descargado mientras intrpt_routine está
 * aún en la cola de tareas */ 
static struct wait_queue *WaitQ = NULL;

static void intrpt_routine(void *);


/* La estructura de cola de tareas para esta tarea, de tqueue.h */
static struct tq_struct Task = {
  NULL,   /* Próximo elemento en la lista - queue_task hará 
           * esto por nosotros */
  0,      /* Una bandera significando que todavía no hemos 
	   * insertado en la cola de tareas */
  intrpt_routine, /* La función a ejecutar */
  NULL    /* El parámetro void* para esta función */
};



/* Esta función será llamada en cada interrupción de reloj.
 * Nótese que el puntero *void - funciones de la tarea
 * puede ser usado para más de un propósito, obteniendo
 * cada vez un parámetro diferente. */

static void intrpt_routine(void *irrelevant)
{
  /* Incrementa el contador */
  TimerIntrpt++;

  /* Si cleanup nos quiere matar */
  if (WaitQ != NULL) 
    wake_up(&WaitQ);   /* Ahora cleanup_module puede retornar */
  else
    /* Nos vuelve a poner en la cola de tareas */
    queue_task(&Task, &tq_timer);  
}




/* Pone datos en el fichero del sistema de ficheros proc. */
int procfile_read(char *buffer, 
                  char **buffer_location, off_t offset, 
                  int buffer_length, int zero)
{
  int len;  /* Número de bytes usados actualmente */

  /* Esto es estático por lo tanto permanecerá en memoria 
   * cuando deje esta función */
  static char my_buffer[80];  

  static int count = 1;

  /* Damos toda nuestra información de una vez, por lo
   * tanto si alguien nos pregunta si tenemos más
   * información la respuesta debería de ser no.
   */
  if (offset > 0)
    return 0;

  /* Rellena el buffer y obtiene su longitud */
  len = sprintf(my_buffer, 
                "Timer fue llamado %d veces\n", 
                TimerIntrpt);
  count++;

  /* Dice a la función que nos ha llamado dónde
   * está el buffer */
  *buffer_location = my_buffer;

  /* Retorna la longitud */
  return len;
}


struct proc_dir_entry Our_Proc_File = 
  {
    0, /* Número de inodo - ignóralo, será rellenado por 
        * proc_register_dynamic */
    5, /* Longitud del nombre del fichero */
    "sched", /* El nombre del fichero */
    S_IFREG | S_IRUGO, 
    /* Modo del fichero - este es un fichero normal que puede
     * ser leido por su dueño, su grupo, y por todo el mundo */
    1,  /* Número de enlaces (directorios donde  
         * el fichero es referenciado) */
    0, 0,  /* El uid y gid para el fichero - se lo damos 
            * a root */
    80, /* El tamaño del fichero indicado por ls. */
    NULL, /* funciones que pueden ser realizadas en el 
           * inodo (enlace, borrado, etc.) - no 
           * soportamos ninguna. */
    procfile_read, 
    /* La función read para este fichero, la función llamada
     * cuando alguien intenta leer algo de él. */
    NULL 
    /* Podemos tener aquí una función para rellenar
     * el inodo del fichero, para permitirnos jugar con
     * los permisos, dueño, etc. */
  }; 


/* Inicializa el módulo - registra el fichero proc */
int init_module()
{
  /* Pone la tarea en la cola de tareas tq_timer, por lo
   * tanto será ejecutado en la siguiente interrupción del reloj */
  queue_task(&Task, &tq_timer);

  /* Tiene éxito si proc_register_dynamic tiene éxito.
   * falla en otro caso */
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,2,0)
  return proc_register(&proc_root, &Our_Proc_File);
#else
  return proc_register_dynamic(&proc_root, &Our_Proc_File);
#endif
}


/* Limpieza */
void cleanup_module()
{
  /* libera nuestro fichero /proc */
  proc_unregister(&proc_root, Our_Proc_File.low_ino);
  
  /* Duerme hasta que intrpt_routine es llamada por última
   * vez. Esto es necesario, porque en otro caso, desasignaremos
   * la memoria manteniendo intrpt_routine y Task mientras
   * tq_timer aún las referencia. Destacar que no permitimos
   * señales que nos interrumpan.
   *
   * Como WaitQ no es ahora NULL, esto dice automáticamente
   * a la rutina de interrupción su momento de muerte. */
 sleep_on(&WaitQ);
}  






















