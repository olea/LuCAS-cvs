#!/bin/sh
# Lucas Di Pentima - 01/10/2002
#
# Procesa el archivo pasado por parametro para generar el FO correspondiente
# y luego el PDF, en formato A4.
 
if [ $# -eq 0 ]
then
DOC=documento
else
DOC=$1
fi

xsltproc --xinclude -o $DOC.fo \
	--stringparam paper.type A4 \
	utilidades/xsl/docbook-xsl/fo/docbook.xsl $DOC.xml
	
#xsltproc --xinclude -o $DOC.fo \
#	--stringparam paper.type A4 \
#	/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/fo/docbook.xsl \
#	$DOC.xml

# Lo ejecutamos dos veces para que genere el indice
pdfxmltex $DOC.fo
pdfxmltex $DOC.fo

# Borramos los archivos temporales
rm -f $DOC.aux $DOC.log $DOC.out
