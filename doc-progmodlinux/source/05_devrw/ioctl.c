/* ioctl.c - el proceso para usar las ioctls para controlar
 * el módulo del núcleo
 *
 * Hasta ahora podíamos usar cat para entrada y salida.
 * Pero ahora necesitamos realizar ioctls, los cuales
 * requieren escribir en nuestro proceso.
 */

/* Copyright (C) 1998 by Ori Pomerantz */
 

/* específico del dispositivo, tales como números ioctl
 * y el fichero del dispositivo mayor. */
#include "chardev.h"    


#include <fcntl.h>      /* abrir */ 
#include <unistd.h>     /* salir */
#include <sys/ioctl.h>  /* ioctl */



/* Funciones para las llamadas ioctl */

ioctl_set_msg(int file_desc, char *message)
{
  int ret_val;

  ret_val = ioctl(file_desc, IOCTL_SET_MSG, message);

  if (ret_val < 0) {
    printf ("ioctl_set_msg fallido:%d\n", ret_val);
    exit(-1);
  }
}



ioctl_get_msg(int file_desc)
{
  int ret_val;
  char message[100]; 

  /* Peligro - esto es peligroso porque no decimos al 
   * núcleo cuanto le está permitido escribir, por lo 
   * tanto, quizás desborde el buffer. En la creación 
   * de un programa real, deberemos usar dos ioctls - uno
   * para decir al núcleo la longitud del buffer y otro para
   * darle el buffer a rellenar
   */

  ret_val = ioctl(file_desc, IOCTL_GET_MSG, message);

  if (ret_val < 0) {
    printf ("ioctl_get_msg fallido:%d\n", ret_val);
    exit(-1);
  }

  printf("get_msg mensaje:%s\n", message);
}



ioctl_get_nth_byte(int file_desc)
{
  int i;
  char c;

  printf("get_nth_byte mensaje:");

  i = 0;
  while (c != 0) {
    c = ioctl(file_desc, IOCTL_GET_NTH_BYTE, i++);

    if (c < 0) {
      printf(
      "ioctl_get_nth_byte fallo en el byte %d'esimo:\n", i);
      exit(-1);
    }

    putchar(c);
  } 
  putchar('\n');
}




/* Principal - Llama a las funciones ioctl */
main()
{
  int file_desc, ret_val;
  char *msg = "Mensaje pasado por ioctl\n";

  file_desc = open(DEVICE_FILE_NAME, 0);
  if (file_desc < 0) {
    printf ("No se puede abrir el fichero del dispositivo: %s\n", 
            DEVICE_FILE_NAME);
    exit(-1);
  }

  ioctl_get_nth_byte(file_desc);
  ioctl_get_msg(file_desc);
  ioctl_set_msg(file_desc, msg);

  close(file_desc); 
}
