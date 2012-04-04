#!/bin/sh
# Lucas Di Pentima - 29/11/2002
#
# Procesa el documento.xml para generar la version HTML HelpFile, que sirve
# para generar archivos de ayuda de Windows (mediante el uso del HTML Help 
# Workshop).

DOC=documento
DIR=html-help

if [ -d $DIR ]; then
	echo "Limpiando directorio $DIR/..."
	rm -f $DIR/*
	cd $DIR
	echo "Generando archivos..."
	xsltproc \
	    --param target.database.document "'database.xml'" \
	    --xinclude \
	    ../utilidades/xsl/docbook-xsl/htmlhelp/htmlhelp.xsl ../$DOC.xml
	cd -
else
	echo "Por favor crea el directorio '$DIR' para colocar los archivos"
fi
