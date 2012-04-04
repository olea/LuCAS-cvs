#/bin/bash

DIR_CVS="cvs_lucas"
DIRS="htmls"
DIR_OUTPUT="public_html/lucas"
DIR_XSLT="cvs_lucas/xslt"

xsltproc "$DIR_XSLT/news.xsl" "$DIR_CVS/htmls/novedades.rss" > "$DIR_XSLT/novedades.xsl"
xsltproc "$SIR_XSLT/lucas.xsl" "$DIR_CVS/index.xml" > "$DIR_OUTPUT/index.html"
#copiar el css por algun cambio
cp "$DIR_CVS/tldp_es.css" "$DIR_OUTPUT/"

for subdir in $DIRS
do
        FILES=`ls $DIR_CVS/$subdir/*.xml`

        if [ ! -d "$DIR_OUTPUT/$subdir" ]
        then
                mkdir "$DIR_OUTPUT/$subdir"
        fi
        for file in $FILES
        do
                FILE_NAME=`echo $file | sed -e 's/\..*//g' -e 's/.*\///g'`
                echo "Processing: $file ($FILE_NAME)"
                xsltproc "$DIR_XSLT/lucas.xsl" $file > "$DIR_OUTPUT/$subdir/$FILE_NAME.html"
        done
done
