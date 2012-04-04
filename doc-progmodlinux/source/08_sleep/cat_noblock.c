/* cat_noblock.c - abre un fichero y muestra su contenido, 
 * pero acaba, mejor que esperar a una entrada */


/* Copyright (C) 1998 por Ori Pomerantz */



#include <stdio.h>    /* E/S estándar */
#include <fcntl.h>    /* para open */
#include <unistd.h>   /* para read */ 
#include <stdlib.h>   /* para exit */
#include <errno.h>    /* para errno */

#define MAX_BYTES 1024*4


main(int argc, char *argv[])
{
  int    fd;  /* El descriptor del fichero para el fichero a leer */
  size_t bytes; /* El número de bytes a leer */
  char   buffer[MAX_BYTES]; /* El buffer para los bytes */  


  /* Uso */
  if (argc != 2) {
    printf("Uso: %s <filename>\n", argv[0]);
    puts("Lee el contenido de un fichero, pero no espera a una entrada");
    exit(-1);
  }

  /* Abre el fichero para lectura en un modo no bloqueante */
  fd = open(argv[1], O_RDONLY | O_NONBLOCK);

  /* Si open falló */
  if (fd == -1) {
    if (errno = EAGAIN)
      puts("Open debería bloquear");
    else
      puts("Open fallido");
    exit(-1);
  }

  /* Lee el fichero y muestra su contenido */
  do {
    int i;

    /* Lee caracteres del fichero */
    bytes = read(fd, buffer, MAX_BYTES);

    /* Si hay un error, lo dice y muere */
    if (bytes == -1) {
      if (errno = EAGAIN)
	puts("Normalmente yo bloquearía, pero me has dicho que no lo haga");
      else
	puts("Otro error de lectura");
      exit(-1);
    }

    /* Imprime los caracteres */
    if (bytes > 0) {
      for(i=0; i<bytes; i++)
	putchar(buffer[i]);
    }

    /* Mientras no hay errores y el fichero no acaba */
  } while (bytes > 0);
}
