#!/bin/sh
# Lucas Di Pentima - 01/10/2002
#
# Procesa el documento.xml para generar su version en HTML (un solo archivo)
# Utiliza las hojas de estilo XSL del LDP contenidas en el directorio
# utilidades/xsl/

if [ $# -eq 0 ]
then 
DOC=documento
else
DOC=$1
fi

xsltproc \
    --param target.database.document "'database.xml'" \
    --xinclude \
    -o $DOC.html \
    utilidades/xsl/ldp-html.xsl $DOC.xml
