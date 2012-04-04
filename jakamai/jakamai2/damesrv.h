/*
 * (c) 2001 Juan J. Amor <jjamor@hispalinux.es>
 * (c) 2002 Teófilo Ruiz <teo.ruiz@hispalinux.es>
 * (c) 2002 Javier Linares <jlinares@adala.org>
 *
 * Fecha: jue nov 28 15:51:16 CET 2002
 * Autores: Juan José Amor, Teófilo Ruiz y Javier Linares
 * Descripción: Programa que balancea la carga del servidor de esTLDP
 * (antes LuCAS). 
 *
 * Nombre clave: Jakamai.
 * Programa disponible bajo licencia GNU GPL versión 2.0 o posterior.
 *
 **
 * $Id: damesrv.h,v 1.1 2002/12/16 09:30:31 teo Exp $
 **
 */

/* ****************** FUNCIONES **************************
 *
 * Las funciones aparecen en este archivo en el mismo orden que aparecen en
 * el archivo .c.
 */


/* Función que sirve la petición. */
void main_loop();

/* Única función a la que hay que llamar para que re-lea la configuración
 * del programa. Puede ser utilizada la primera vez o de forma asíncrona
 * por señales.
 */
void cargaConfiguracion();

void errorLog(int idError);
void imprimeURL(FILE *lugar);

