#!bin/bash

FILE_NAME=`echo "$1" | awk -F '.' '{print $1}'`

cat << endl > temp.html 
<?xml version="1.0" encoding="iso-8859-1"?>
endl

sed -e '/<?xml version.*?>/d' -e '/<\!D.*/,/">/d' -e '/^<\!--.*$/,/^<\!-- Cuerpo.*$/d' -e '/<head>/,/<\/head>/s/<\/head>/&\<body>/' -e '/^<\!-- Fin cuerpo.*$/,/<\/body>/d' -e 's/<\/html>/<\/body>\<\/html>/' $1 >> temp.html

tidy -m -config config temp.html

sed -e '/<\!D.*/,/">/d' -e 's/<html .*>/<html>/' temp.html > temp1.html 
mv temp1.html temp.html  
sed -e 's/\&ntilde;/ñ/g' -e 's/\&aacute;/á/g' -e 's/\&eacute;/é/g' -e 's/\&iacute;/í/g' -e 's/\&oacute;/ó/g' -e 's/\&uacute;/ú/g' -e 's/\&ordf;/º/g' -e 's/&iuml;/î/g' -e 's/\&iexcl;/¡/g' -e 's/\&Aacute;/Á/g' -e 's/\&Eacute;/É/g' -e 's/\&Iacute;/Í/g' -e 's/\&Oacute;/Ó/g' -e 's/\&Uacute;/Ú/g' -e 's/\&iquest;/¿/g' -e 's/\&laquo;/«/g' -e 's/\&raquo;/»/g' -e 's/\&uuml;/ü/g'  -e 's/\&icirc;/ï/g' -e 's/\&nbsp;/ /g' -e 's/\&shy;//g' -e 's/\&ordm;/ª/g' -e 's/\&sect;/§/g' -e 's/\&ccedil;/ç/g' -e 's/\&middot;/·/g' -e  's/\&auml;/ä/g' temp.html > temp.xml 
mv temp.xml "$FILE_NAME".xml
