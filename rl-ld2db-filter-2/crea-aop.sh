#!/bin/bash
if [  $# -ne 1 ]
then
	echo "Uso: $0 fichero.xml"
fi
VERSION="1.0"
ENCODING="ISO-8859-1"
FUENTE="DocbookXML"
F=$(basename $1 .xml)
D=$(dirname $1)
if [ $D == "" ]
then
	D="."
fi
echo -e  "<?xml version=\"$VERSION\" encoding=\"$ENCODING\"?>"  >"$D/$F.aop"
echo -e  "<aop>" >>$D/$F.aop
echo -e  "\t<formato_fuente tipo=\"$FUENTE\"/>" >>"$D/$F.aop"
echo -e  "\t<nombre_base>$F-como</nombre_base>" >>"$D/$F.aop"
echo -e  "\t<nombre_archivo>$F.xml</nombre_archivo>" >>"$D/$F.aop"

if grep "<mediaobject>|<figure>|<screenshot>" $1 >/dev/null 2>&1
then
	SINO=si
	DIR=no
else
	SINO=no
	DIR=no
fi
echo -e  "\t<imagenes contiene=\"$SINO\" nombre_directorio=\"$DIR\"/>" >>"$D/$F.aop"

#if grep ejemplos $1
#then
#	SINO=si
#else
	SINO=no
	DIR=no
#fi

echo -e  "\t<ejemplos contiene=\"$SINO\" nombre_directorio=\"$DIR\"/>" >>"$D/$F.aop"
echo -e  "</aop>" >>"$D/$F.aop"

if grep 'imagenes contiene=\"si\" nombre_directorio=\"no\"' "$D/$F.aop" >/dev/null  2>&1
then
	echo "debes revisar $D/$F.aop y poner el directorio de imagenes"
fi
echo "Si el documento incluye ejemplos tambi?n lo deber?as revisar"

##echo "Fichero aop creado"