#!/bin/sed -f
# Script que reemplaza las apariciones de <graphic=...> por dos
# <mediaobject..> equivalentes dentro de un archivo sgml
# Util en en el caso de facilitar la generación de figuras de pdf's y ps,
# cómo es descrito en el SelfDocBoook de Tim Waugh (ver
# http://cyberelk.net/tim/docbook/selfdocbook/tips.html#IMAGES
# Autor: Jaime Irving Davila, Fecha: Marzo 3-2002
# Se cede al dominio público

s/<graphic\(.*\)fileref="\(.*\)\.\(.*\)"\(.*\)><\/graphic>/\<mediaobject>\
  <imageobject><imagedata\1fileref="\2" format="eps"\4><\/imageobject>\
  <imageobject><imagedata\1fileref="\2.\3" format="\3"\4><\/imageobject>\
<\/mediaobject>/g
