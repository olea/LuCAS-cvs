#!/bin/sh
# Lucas Di Pentima - 01/10/2002
#
# Procesa el documento.xml para generar la version HTML de multiples
# archivos. Utiliza las hojas de estilo XSL del TLDP contenidas en el
# directorio utilidades/xsl/
if [ $# -eq 0 ]
then
DOC=documento
else
DOC=$1
fi


if [ -d html ]; then
	echo "Limpiando directorio html/..."
	rm -f html/*
	cd html
	ln -s ../imagenes imagenes
	echo "Generando archivos html..."
	xsltproc \
	    --param target.database.document "'database.xml'" \
	    --xinclude \
	    ../utilidades/xsl/ldp-html-chunk.xsl ../$DOC.xml
	cd -
else
	echo "Por favor crea el directorio 'html' para colocar los archivos"
fi

