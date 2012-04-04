/*
 * (c) 2001 juan j. amor <jjamor@hispalinux.es>
 * (c) 2002 teófilo ruiz <teo.ruiz@hispalinux.es>
 * (c) 2002 javier linares <jlinares@adala.org>
 *
 * fecha: jue nov 28 15:51:16 cet 2002
 * autores: juan josé amor, teófilo ruiz y javier linares
 * descripción: programa que balancea la carga del servidor de estldp
 * (antes lucas). 
 *
 * nombre clave: jakamai.
 * programa disponible bajo licencia gnu gpl versión 2.0 o posterior.
 *
 **
 * $id: damesrv.c,v 2.0 2002/01/12 22:34:03 teo exp $
 **
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "cadenas.h"
#include "constantes.h"

/* Valida una URL. Devuelve 1 si la URL es válida y 0 en caso contrario */
int errorURL(char *linea) {

	int error	=0;
	char *p		= NULL;
	
	char *comprobacion1 = NULL;	/* para comprobar integridad de la URL			*/
	char *comprobacion2 = NULL;	/* para comprobar integridad de la URL			*/
	char *comprobacion3 = NULL;	/* para comprobar integridad de la URL			*/

	p = linea;
	
	comprobacion1 = strstr(p, "http://");
	comprobacion2 = strstr(p, ".");
	comprobacion3 = strstr(p, "=");

	if(comprobacion1   !=NULL &&
	   comprobacion2   !=NULL &&
	   comprobacion3   ==NULL &&
	   strlen(comprobacion1) > 0 &&
	   strlen(comprobacion2) > 0) {
		
		error=0;	
	}
	else {
		error=1;
	}
	return(error);
}

/* Elimina los espacios por delante y por detrás de una cadena */
void eliminaEspacios(char *cadena) {
	  
	int j=0;

	/* espacios del principio de la cadena */
	while(isspace((int)*(cadena+0))) {

		for(j=0; *(cadena+j)!='\0' && j <= TAMLINEA; j++) {
			*(cadena+j) = *(cadena+j+1);
		}
	}
}

void cortaPorCaracter(char *cadena, char c) {

	int j=0;

	while(*(cadena+j)!='\0' && j <= TAMLINEA) {

		if(*(cadena+j) == c) {
			*(cadena+j)='\0';
		}
		j++;
	}
}

