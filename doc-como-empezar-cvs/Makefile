NOMBREDOC=micro-como-empezar-con-cvs
NOMBREDIR=doc-como-empezar-cvs

all: html pdf entrada

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