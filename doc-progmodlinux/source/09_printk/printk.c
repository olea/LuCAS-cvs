/* printk.c - envía salida textual al tty en el que estás
 * ahora, sin importarle cuando es pasado
 * a través de X11, telnet, etc. */


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

/* Necesarios aquí */
#include <linux/sched.h>    /* Para el actual */
#include <linux/tty.h>      /* Para las declaraciones de tty */


/* Imprime la cadena de caracteres al tty apropiado, el
 * que usa la tarea actual */
void print_string(char *str)
{
  struct tty_struct *my_tty;

  /* La tty para la tarea actual */
  my_tty = current->tty;

  /* Si my_tty es NULL, significa que la actual tarea
   * no tiene tty en la que puedas imprimir (esto es posible, por
   * ejemplo, si es un demonio). En este caso, no hay nada
   * que se pueda hacer. */
  if (my_tty != NULL) { 

    /* my_tty->driver es una estructura que mantiene las funciones
     * de tty, una de las cuales (write) es usada para
     * escribir cadenas de caracteres a la tty. Puede ser usada
     * para coger una cadena de caracteres del segmento de memoria
     * del usuario o del segmento de memoria del núcleo.
     *
     * El primer parámetro de la función es la tty en la que
     * hay que escribir, porque la misma función puede
     * ser normalmente usada para todas las ttys de un cierto
     * tipo. El segundo parámetro controla cuando la función 
     * recibe una cadena de caracteres de la memoria del núcleo
     * (falsa, 0) o desde la memoria del usuario (verdad, distinto
     * de cero). El tercer parámetro es un puntero a la cadena
     * de caracteres, y el cuarto parámetro es la longitud de la
     * cadena de caracteres.
     */
    (*(my_tty->driver).write)(
        my_tty, /* La misma tty */
        0, /* No cogemos la cadena de caracteres de la memoria de usuario */
	str, /* Cadena de caracteres */
	strlen(str));  /* Longitud */

    /* Las ttys fueron originalmente dispositivos hardware, las
     * cuales (usualmente) se adherían estrictamente al estándar
     * ASCII. De acuerdo con ASCII, para mover una nueva linea
     * necesitas dos caracteres, un retorno de carro y un salto
     * de linea. En Unix, en cambio, el salto de linea ASCII
     * es usado para ambos propósitos - por lo tanto no podemos
     * usar \n, porque no tendrá un retorno de carro y la siguiente
     * linea empezará en la columna siguiente
     *                                        después del paso de linea.
     *
     * BTW, este es el motivo por el que el formato de un fichero de 
     * texto es diferente entre Unix y Windows. En CP/M y sus derivados,
     * tales como MS-DOS y Windows, el estándar ASCII fue estrictamente
     * adherido, y entonces una nueva linea requiere un salto de linea
     * y un retorno de carro.
     */
    (*(my_tty->driver).write)(
      my_tty,  
      0,
      "\015\012",
      2);
  }
}


/* Inicialización y Limpieza del módulo ****************** */


/* Inicializa el módulo - registra el fichero proc */
int init_module()
{
  print_string("Módulo insertado");

  return 0;
}


/* Limpieza - libera nuestro fichero de /proc */
void cleanup_module()
{
  print_string("Módulo borrado");
}  

