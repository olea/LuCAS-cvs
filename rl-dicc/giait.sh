
# advierto que es offuscated-bash, pero funciona XD

echo "Script que descarga y formatea el Diccionario Informático GIAIT"
echo "por Ramses Rodriguez Martinez <ramses.harpago@gmail.com>"
echo "Para el grupo de trabajo DICT-ES <dict-es@es.tldp.org>"

VERSION=0.1.5

if test -z `which dictzip`; then
  echo "dictzip no encontrado. si no quieres comprimir, borra la penultima linea" && exit
else echo "dictzip OK";
fi;

if test -z `which wget`; then
  echo "necesito wget para descargar el diccionario" && exit
else echo "wget OK";
fi;
  
if test -z `which iconv`; then
  echo "necesito iconv para pasar el diccionario a UTF8" && exit
else echo "iconv OK";
fi;

echo ""

wget http://es.tldp.org/Otros/diccionario-us-es/diccionario-us-es-$VERSION-giait.tar.gz
tar -zxvf diccionario-us-es-$VERSION-giait.tar.gz
rm diccionario-us-es-$VERSION-giait.tar.gz
cd datos
cat *.txt > giait
rm *.txt

cat giait | tr -d "\n" | sed s/@@GLO/\\n@@GLO/g | sed s/@@ING/\\n@@ING/g | \
sed s/@@DIC/\\n@@DIC/g | sed s/@@FIN/\\n@@FIN/g | sed s/"@@CAS "/" ("/g | \
sed -r s/"@@ING".*/\\0\)/g | sed s/"@@ING "//g | sed s/"@@".../""/g | \
sed s/"  "$/""/g | sed s/$$/""/g > giait.1

echo "GIAIT: Diccionario Informático Inglés-Castellano" > header.txt
echo "Distribuido en formato DICT y bajo licencia GPL" >> header.txt

cat header.txt giait.1 > giait.2
cd ..

iconv -t UTF8 datos/giait.2 | dictfmt -f --allchars --locale es_ES.UTF-8 -s \
"GIAIT: Diccionario Informatico Ingles-Castellano" giait 
rm -rf datos/
dictzip giait.dict
echo "giait.dict.dz generado con éxito"
