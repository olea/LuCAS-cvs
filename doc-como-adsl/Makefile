#NOMBREDOC=adsl-como.xml
#NOMBREDIR=doc-como-adsl

all: html pdf entrada

html: .html

pdf: .pdf

.html: .xml
	xmlto xhtml-nochunks .xml

.pdf:	.xml
	xmlto pdf .xml

clear:
	rm *pdf *html *~
	
entrada: cacho-entrada.xml

cacho-entrada.xml: .omf cacho-entrada.xsl
	xsltproc --stringparam PDF .pdf --stringparam ORIGINAL  --stringparam DOCUMENTO-HTML .html cacho-entrada.xsl .omf >doc-como-adsl adsl-como.xml 

po: .po

.po: .xml
	 xml2po -m docbook  -o  doc-como-adsl adsl-como.xml .xml
