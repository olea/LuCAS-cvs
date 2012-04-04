#!/usr/local/bin/perl
##
# Código fuente LuCAS V3
# Copyright (C) 1999 Hispalinux / Juan J. Amor / Ismael Olea
# Programa bajo la proteccion de GPL 2.0
##
# $Id: genera-tutconf.pl,v 1.1.1.1 2000/07/10 17:49:07 jjamor Exp $
##
#
# Utilidad para generar fichero de descripcion de seccion de
# Tutoriales (tutoriales.conf)
#
##

open (PRUEBA, "tutoriales.conf") && die ("ERROR: me niego a pisar tutoriales.conf");
close(PRUEBA);

# Directorio donde estan los tutoriales
my $DIR_TUT="../../Tutoriales";

open (SALIDA, ">tutoriales.conf") || die ("Error abriendo salida");

print SALIDA <<ETFIN;
#
# Fichero de descripcion de seccion de tutoriales
## \$Id\$
#
# Este fichero debe llamarse tutoriales.conf y estar situado
# en el mismo directorio que tutoriales.wml
#
# Estructura:
#
# INI-MAN Nombre-de-directorio-de-tutorial
# ...
# ... parrafo (HTML) que describe el tutorial ...
# ...
# FIN-PARRAFO
# <A HREF="mailto:url\@del.autor">Nombre del Autor</A>
#
# Cualquier linea que empiece con '#' es un comentario
#
ETFIN

opendir (DIR, "$DIR_TUT") or die("No puedo abrir $DIR_TUT");
while ($_ = readdir(DIR) )
{
  if ( $_ ne '..' && $_ ne '.' )
  {
    print SALIDA <<ETFIN;
INI-MAN $_
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

print "Edite el fichero tutoriales.conf generado.\n";

