/* procfs.c -  crea un "fichero" en /proc 
 * Copyright (C) 1998-1999 by Ori Pomerantz
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


/* Necesario porque usamos el sistema de ficheros proc */
#include <linux/proc_fs.h>



/* En 2.2.3 /usr/include/linux/version.h se incluye
 * una macro para eso, pero 2.0.35 no lo hace - por lo
 * tanto lo añado aquí si es necesario */
#ifndef KERNEL_VERSION
#define KERNEL_VERSION(a,b,c) ((a)*65536+(b)*256+(c))
#endif



/* Ponemos datos en el fichero del sistema de fichero proc.

   Argumentos
   ==========
   1. El buffer donde los datos van a ser insertados, si
      decides usarlo.
   2. Un puntero a un puntero de caracteres. Esto es útil si
      no quieres usar el buffer asignado por el núcleo.
   3. La posición actual en el fichero.
   4. El tamaño del buffer en el primer argumento.
   5. Cero (¿para uso futuro?).

   Uso y Valores de Retorno
   ========================
   Si utilizas tu propio buffer, como yo, pon su situación
   en el segundo argumento y retorna el número de bytes
   usados en el buffer.

   Un valor de retorno de cero significa que actualmente no 
   tienes más información (final del fichero). Un valor negativo
   es una condición de error.

   Para Más Información
   ====================
   La forma en la que descubrí qué hacer con esta función 
   no fue leyendo documentación, sino que fue leyendo el código
   que lo utiliza. Justamente miré para ver para qué usa el campo
   get_info de la struct proc_dir_entry (Usé una combinación 
   de find y grep, por si estás interesado), y vi que se usa en
   <directorio del código del núcleo>/fs/proc/array.c.

   Si algo no es conocido sobre el núcleo, esta es la forma
   habitual de hacerlo. En Linux tenemos la gran ventaja
   de tener el código fuente del núcleo gratis - úsalo.
 */
int procfile_read(char *buffer, 
		  char **buffer_location, 
		  off_t offset, 
		  int buffer_length, 
		  int zero)
{
  int len;  /* El número de bytes usados realmente */

  /* Esto es static, por lo tanto permanecerá en 
   * memoria cuando abandonemos esta función */
  static char my_buffer[80];  

  static int count = 1;

  /* Damos toda nuestra información de una vez, por lo tanto
   * si el usuario nos pregunta si tenemos más información
   * la respuesta debería de ser no.
   *
   * Esto es importante porque la función estándar de lectura
   * de la librería debería continuar emitiendo la
   * llamada al sistema read hasta que el núcleo responda
   * que no hay más información, o hasta que el buffer esté
   * lleno.
   */
  if (offset > 0)
    return 0;

  /* Rellenamos el buffer y cogemos su longitud */
  len = sprintf(my_buffer, 
    "Para la vez %d%s, vete!\n", count,
    (count % 100 > 10 && count % 100 < 14) ? "th" : 
      (count % 10 == 1) ? "st" :
        (count % 10 == 2) ? "nd" :
          (count % 10 == 3) ? "rd" : "th" );
  count++;

  /* Dice a la función que llamamos dónde está el buffer */
  *buffer_location = my_buffer;

  /* Devolvemos la longitud */
  return len;
}


struct proc_dir_entry Our_Proc_File = 
  {
    0, /* Número de Inodo - ignóralo, será rellenado por 
        * proc_register[_dynamic] */
    4, /* Longitud del nombre del fichero */
    "test", /* El nombre del fichero */
    S_IFREG | S_IRUGO, /* Modo del fichero - este es un fichero 
                        * regular que puede ser leído por su 
                        * dueño, por su grupo, y por todo el mundo */ 
    1,	/* Número de enlaces (directorios donde el 
         * fichero está referenciado) */
    0, 0,  /* El uid y gid para el fichero - se lo damos 
            * a root */
    80, /* El tamaño del fichero devuelto por ls. */
    NULL, /* funciones que pueden ser realizadas en el inodo 
           * (enlazado, borrado, etc.) - no soportamos 
           * ninguna. */
    procfile_read, /* La función read para este fichero, 
                    * la función llamada cuando alguien 
                    * intenta leer algo de el. */
    NULL /* Podemos tener aquí un función que rellene el
          * inodo del fichero, para habilitarnos el jugar
          * con los permisos, dueño, etc. */ 
  }; 





/* Inicializa el módulo - registra el fichero proc */
int init_module()
{
  /* Tiene éxito si proc_register[_dynamic] tiene éxito,
   * falla en otro caso. */
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,2,0)
  /* En la versión 2.2, proc_register asigna un número
   * de inodo automáticamente si hay cero en la estructura,
   * por lo tanto no necesitamos nada más para 
   * proc_register_dynamic
   */


  return proc_register(&proc_root, &Our_Proc_File);
#else
  return proc_register_dynamic(&proc_root, &Our_Proc_File);
#endif
 
  /* proc_root es el directorio raiz para el sistema de ficheros
   * proc (/proc). Aqué es dónde queremos que nuestro fichero esté
   * localizado. 
   */
}


/* Limpieza - liberamos nuestro fichero de /proc */
void cleanup_module()
{
  proc_unregister(&proc_root, Our_Proc_File.low_ino);
}  



