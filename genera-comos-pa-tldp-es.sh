#!/bin/bash

genera_make () {
cat >Makefile <<End-of-message
NOMBREDOC=$2
NOMBREDIR=$1
End-of-message

cat >>Makefile <<"End-of-message"

all: cvs html pdf entrada

cvs:
	if [ -d ACVS ] ; then 
		cvs update
	fi
	
html: $(NOMBREDOC).html

pdf: $(NOMBREDOC).pdf

$(NOMBREDOC).html: $(NOMBREDOC).xml
	xmlto xhtml-nochunks $(NOMBREDOC).xml

$(NOMBREDOC).pdf:	$(NOMBREDOC).xml
	xmlto pdf $(NOMBREDOC).xml

clear:
	rm *pdf *html *~
	
entrada: cacho-entrada.xml

cacho-entrada.xml: $(NOMBREDIR).omf cacho-entrada.xsl
	xsltproc --stringparam PDF $(NOMBREDOC).pdf --stringparam ORIGINAL $(NOMBREDIR) --stringparam DOCUMENTO-HTML $(NOMBREDOC).html cacho-entrada.xsl $(NOMBREDIR).omf >$@ 

po: $(NOMBREDOC).po

$(NOMBREDOC).po: $(NOMBREDOC).xml
	 xml2po -m docbook  -o  $@ $(NOMBREDOC).xml
End-of-message
}


TMP=$(mktemp -d)
for nombredir in doc-como-* ;do
	pushd $nombredir
	nombredocumento=$(echo "xpath /aop/nombre_archivo/text()" | xmllint --shell *.aop |head -n 4|tail -n1|sed "s/^.*content=//g")
	genera_make $nombredir  $nombredocumento
#	make
	popd
	read
done


exit 0
