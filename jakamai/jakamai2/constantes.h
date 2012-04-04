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

#define MAXSERVERLENGHT 80
#define MAXURLLENGHT 1024
#define MAXSERVERS 40
#define TAMLINEA 255
#define NUMVARS 2
#define FILECONF "damesrv.conf"
#define FILELOG "damesrv.log"

#define ERR_PRUEBA 1
#define ERR_APERTURA 2
#define ERR_RESERVA 3
#define ERR_GENERICO 100

