#!/bin/bash

# Script de alta de colecciones de páginas man
# El objetivo de este script es crear el entorno estructurado de trabajo con las páginas man
# Por ahora es una prueba de conceptoveremosaver.
# $Id: crea-coleccion.sh,v 1.2 2004/06/15 15:01:41 olea Exp $

# Directorio temporal donde se va a crear la colección:
DIRDESTINO=`mktemp -d /tmp/XXXXXX`

# Directorio que contiene
DIRFUENTE=/home/olea/cvs/lucas/rl-manpages-collection-manager/old-sources/man-pages-1.55
pushd $DIRFUENTE  > /dev/null

# El siguiente dato hay que pedirlo al usuario:
CVSROOT=/tmp/paginas-man-cvsroot/
mkdir -p $CVSROOT
# Inicializa el servidor cvs... esto sólo hace falta para las preubas

# El siguiente dato hay que pedirlo al usuario:
CVSWORK=/tmp/paginas-man-cvswork


usage="\
Úsage: `basename $0` [-h] [--help] [man-pages-?.??.tgz --cvsroot=CVSROOT --cvsworkdir=CVSWORKDIR ]"

if  test $# -ne 0;
then
    echo ${usage}
    exit 1
fi


#while test $# -gt 0 ; do
#   case "${1}" in
#      -h | --help)
#         echo "${usage}" 1>&2; exit 0 ;;
#      --cvsroot=*)
#         CVSROOT="$2";
#         shift 2
#         echo "CVSROOT $CVSROOT";;
#      --cvsworkdir=*)
#         CVSWORKDIR="$2"
#         shift 2
#         echo "CVSWORKDIR $CVSWORKDIR";;
#      -* )
#        echo "${usage}" 1>&2; exit 1 ;
#        ;;
#   esac
#done

mkdir -p $CVSWORK
cvs -d $CVSROOT init

pushd $DIRFUENTE > /dev/null
for a in `find . -type f -name "*.?" `; do 
	ENTRADA=`echo $a | sed -e "s/\// /g" -e "s/\./ /g" ` 
	#echo ENTRADA $ENTRADA
	DIRNAME=`echo $ENTRADA |  gawk '{ print "doc-" $1 "-" $2  }' `
	#echo DIRNAME $DIRNAME
	MANPAGE=`echo $ENTRADA |  gawk '{ print  $2 "." $3  }' `
	#echo MANPAGE $MANPAGE

	echo $DIRNAME $MANPAGE;
	# CreaciÃ³n de la estructura de dir por cada pÃ¡gina
	mkdir -p $DIRDESTINO/$DIRNAME/orig
	mkdir -p $DIRDESTINO/$DIRNAME/orig-xml
	mkdir -p $DIRDESTINO/$DIRNAME/po
	cp $a $DIRDESTINO/$DIRNAME/orig/$MANPAGE
	ls -l $a $DIRDESTINO/$DIRNAME/orig/$MANPAGE
	# este touch es temporal hasta que se acabe el resto
	touch $DIRDESTINO/$DIRNAME/${DIRNAME}.xml  $DIRDESTINO/$DIRNAME/${DIRNAME}.aop  $DIRDESTINO/$DIRNAME/Makefile 
	doclifter <  $DIRDESTINO/$DIRNAME/orig/$MANPAGE >  $DIRDESTINO/$DIRNAME/orig-xml/${DIRNAME}.xml
	if [ -s  $DIRDESTINO/$DIRNAME/orig-xml/${DIRNAME}.xml ] 
		then xsltproc /home/olea/cvs/gnome/gnome-doc-utils/xslt/docbook/omf/db2omf.xsl $DIRDESTINO/$DIRNAME/orig-xml/${DIRNAME}.xml > $DIRDESTINO/$DIRNAME/orig-xml/${DIRNAME}.omf
		xml2pot $DIRDESTINO/$DIRNAME/orig-xml/${DIRNAME}.xml > $DIRDESTINO/$DIRNAME/po/${DIRNAME}.pot
	fi;
	pushd $DIRDESTINO/$DIRNAME
	cvs -d $CVSROOT import -m  "Creando módulo $DIRNAME" $DIRNAME v0 r0 
	popd
	rm -rf $DIRDESTINO/$DIRNAME
	pushd $CVSWORK
	cvs -d $CVSROOT co $DIRNAME
	popd
#	break   # esto es para hacer las pruebas con una única iteración, luego se quita, claro
done
rmdir $DIRDESTINO

# Falta: 

# Repasar el xsl de db2omf para que funcione con las páginas man
# tomar una decisión para hacer algo del registro de colecciones... a las malas, montar algo compatible con lo de Carlos
# hacer que la recursividad recoja todos los ficheros con extensiones *.??
