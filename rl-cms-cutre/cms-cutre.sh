#!/bin/bash

#
# CMS-Cutre, lo más lamentable en CMS improvisado en BASH
# A dirty proof-concept tool.

# algoritmo:
#
# 1.- comprobar si existe INDEX.xml
# 2.- en caso positivo:
# 3.-  leerle el h1 y preparar el fichero index.html usándolo como título
# 4.-  copiar a saco INDEX.xml en index.html
# 5.-  sacar los títulos de todos los index.html de los subdirectorios y ponerlos en forma de enlaces en <li>
# fin

titulo=`xmlgrep -S -cg 0 h1 -f INDEX.xml` 

cat <<PRINCIPIOPAGINA
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
 <head>
  <link rel="stylesheet" type="text/css" href="http://olea.org/estilo-web/estilo-comun.css" />
  <meta name="generator" content="cms-cutre.sh, un CMS de lo más cutre, 2003" />
  <link rel="Shortcut Icon" href="http://olea.org/ilustraciones/olea-icono.png" />
  
  <title>$titulo</title>
 </head>
 <body lang="es">                 
  <div class="caja">
PRINCIPIOPAGINA

xmlgrep -S  -g 0 h1 -f INDEX.xml
xmlgrep -S -g 0 p -f INDEX.xml


echo "<ul>"
for a in *; do
    fichero=""
    pdf=""
   	nombretmp=`basename "$a" .html`
    if [ -f $a/index.html ] ; then fichero="$a/index.html"; fi
#    if [ -f $a/slide001.html ] ; then fichero="$a/slide001.html"; fi
    if [ -f $a ] && [ "$a" != "index.html"  ] ; then 
    	if [ "${nombretmp}.html" == "$a" ] ; then fichero="$a"; fi
    fi
    if [ -L $a ] ; then fichero=""; fi

    if [ "$fichero" != "" ]  ; then
        titulo_elemento=`xmlgrep -Scgf $fichero 2 html.head.title `
        if [ "$titulo_elemento" != "" ] ; then 
			echo -n "<li><a href=\"$fichero\">"
			echo -n "$titulo_elemento"
			echo "</a>"
			if [ -f ${nombretmp}.pdf ] ; then echo "<a href=\"${nombretmp}.pdf\"><img style=\"border:0;\" title=\"Documento en PDF\" src=\"http://olea.org/ilustraciones/pdf\" alt=\"PDF\"/></a>" ; fi;
			echo "</li>"
		fi
	fi
done;
echo "</ul>"

cat <<FINDEPAGINA
  </div>
 </body>
</html>

FINDEPAGINA





















