#!/usr/local/bin/perl
##
# Código fuente LuCAS V3
# Copyright (C) 1999 Hispalinux / Juan J. Amor / Ismael Olea
# Programa bajo la proteccion de GPL 2.0
##
# $Id: genera-desc.pl,v 1.1.1.1 2000/07/10 17:49:07 jjamor Exp $
##
#
# Utilidad para generar ficheros .descripcion de directorios para paginas
# generadas automaticamente ( presentaciones.wml y otras ).
#
##

open (PRUEBA, ".descripcion") && die ("ERROR: me niego a pisar .descripcion");
close(PRUEBA);

open (SALIDA, ">.descripcion") || die ("Error abriendo salida");

print SALIDA <<ETFIN;
#
# Fichero de descripcion de evento de conferencias
#
# Este fichero debe llamarse
#  \$LUCASHOME/Presentaciones/\$EVENTO/.descripcion
#
# Estructura:
#
# NOM-EVNT Nombre del evento
# INI-CONF Nombre-de-directorio-de-conferencia
# ...
# ... parrafo (HTML) que describe la conferencia ...
# ...
# FIN-PARRAFO
# <A HREF="mailto:url\@del.autor">Nombre del Autor</A>
#
# Cualquier linea que empiece con '#' es un comentario
#
NOM-EVNT Ponga aqui el nombre del evento
ETFIN

opendir (DIR, ".");
while ($_ = readdir(DIR) )
{
  if ( $_ ne '..' && $_ ne '.' && $_ ne '.descripcion' )
  {
    print SALIDA <<ETFIN;
INI-CONF $_
Rellene aqui la descripcion
FIN-PARRAFO
<A HREF="mailto:sustituir">Sustituir Autor</A>
# FIN-CONF
#
ETFIN
  }
}

closedir(DIR);
close(SALIDA);

print "Edite el fichero .descripcion generado.\n";

