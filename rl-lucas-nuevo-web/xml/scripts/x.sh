LIST=`ls *.html`
for i in $LIST;
do
	FILE_NAME=`echo "$i" | awk -F '.' '{print $1}'`

	echo "Parsing: $FILE_NAME"
	echo "..."

	sh rl.sh $i

	java -classpath  /home/danguer/public_html/lucas/web/saxon.jar com.icl.saxon.StyleSheet "$FILE_NAME".xml ../lucas.xsl > temp.html

#	xsltproc ../lucas.xsl "$FILE_NAME".xml > temp.html
	mv temp.html $i

done
