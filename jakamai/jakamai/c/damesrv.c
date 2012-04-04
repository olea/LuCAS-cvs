/*
 * Código fuente Jakamai
 * (C) 2001 Juan J. Amor
 * Programa bajo la proteccion de GPL 2.0
 *
 **
 * $Id: damesrv.c,v 1.1 2001/08/01 21:40:19 jjamor Exp $
 **
 */

/* System includes */
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>

/* Own includes */
#include "config.h"

void main_loop()
{

  int counter,aux;
  char buffer[MAXURLLENGHT];
  char returnedurl[MAXURLLENGHT+MAXSERVERLENGHT+1];

  char localfile[MAXURLLENGHT];

  struct stat aux2;

  counter = 0;

  setbuf(stdout,NULL);

  while (fgets(buffer,MAXURLLENGHT,stdin)) {

    /* Erase the last character if end-of-line */
    aux = strlen(buffer);
    if (buffer[aux-1] == '\n')
      buffer[aux-1] = '\0';

    sprintf(localfile,"%s/%s",localpath,buffer);

    /* Returns a round-robin URL, if local file exists.
       If not, returns a local URL to produce an ERROR */
    if ( stat(localfile,&aux2) < 0 )
      sprintf(returnedurl,"%s/%s\n",mainserver,buffer);
    else {
      counter = ((counter+1) % MAXSERVERS);
      sprintf(returnedurl,"%s/%s\n",servers[counter],buffer);
    }

    fputs(returnedurl,stdout);

  }

  return;

}


int main()
{
  main_loop();

  exit(0);
}
