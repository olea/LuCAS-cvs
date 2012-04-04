#!/bin/sh
#
# Genera los target dbs de cada porción del proyecto
# chequeando primero si el archivo .db no ha sido 
# generado con anterioridad.
#
# Como argumento recibe la ruta a la porcion
# (relativa al directorio raíz del repositorio)
#
# Lucas Di Pentima - 06/10/2002


# Primero chequeamos que me estén ejecutando desde el
# directorio raíz del repositorio
if [ -d contenido ]; then

    i=$1
    if [ -f "$i" ]; then
	id=`echo $i | awk -F . '{print $1}'`
	
	if [ -f "$id.db" ]; then
        # Chequeamos si el .db es mas nuevo que su porcion
	    if [ "$id.db" -ot "$id.xml.porcion" ]; then
		echo "Actualizando $id.db..."
		xsltproc \
		    --xinclude \
		    --param collect.xref.targets "'only'" \
		    --param targets.filename "'$id.db'" \
		    utilidades/xsl/docbook-xsl/html/docbook.xsl \
		    $id.xml.porcion
	    fi
	else
	# Si no existe el .db, lo creamos...
	    echo "Generando $id.db..."
	    xsltproc \
		--xinclude \
		--param collect.xref.targets "'only'" \
		--param targets.filename "'$id.db'" \
		utilidades/xsl/docbook-xsl/html/docbook.xsl \
		$id.xml.porcion
	fi
    else
	echo "ERROR: $i no existe!"
    fi
else
    echo "ATENCIÓN: ¡Debes ejecutarme desde el directorio raíz de tu copia CVS!"
fi