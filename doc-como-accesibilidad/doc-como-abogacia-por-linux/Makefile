# +-----------------------------------------------------+
# |  Makefile.in  |  (c) ZonaSIETE.org Editors Team     |
# +-----------------------------------------------------+
#
#  Ponemos las variables necesarias
CATALOG :=  /etc/sgml/sgml-docbook.cat
# Comandos básicos
RM := /bin/rm
ECHO := /bin/echo
MV := /bin/mv
SED := /bin/sed
# Comandos de compresión
TAR := /bin/tar
ZIP := /usr/bin/zip
# -- Esto está pendiente de cambiar, tengo que mirar la configuración de Autoconf
DOCBOOK2PS := /usr/bin/docbook2ps
DOCBOOK2PDF := /usr/bin/docbook2pdf
DOCBOOK2TXT := /usr/bin/docbook2txt
XSLTPROC := /usr/bin/xsltproc
XMLLINT := /usr/bin/xmllint
# Aquí se pondrán las hojas de estilo del ./configure
STYLESHEET_PDF := /usr/share/sgml/docbook/dsssl-stylesheets-1.76/print/docbook.dsl
XSLTFILE := /usr/share/sgml/docbook/xsl-stylesheets-1.58.1-2/html/docbook.xsl
CHUNKFILE := /usr/share/sgml/docbook/xsl-stylesheets-1.58.1-2/html/chunk.xsl
# Nombre del fichero (proviene del ./configure)
NOMBRE := abogacia-por-linux-como
OPCIONES := check single multi ps pdf txt comprimidos

.PHONY: all single multi comprimidos check txt z7 clean htmlclean

all: $(OPCIONES)
	@$(ECHO) "Documentos generados y comprimidos"
single: check
	$(XSLTPROC) -o $(NOMBRE).html $(XSLTFILE) $(NOMBRE).xml

multi: check
	$(XSLTPROC) $(CHUNKFILE) $(NOMBRE).xml
	
ps: check
	$(DOCBOOK2PS) -c $(CATALOG) $(NOMBRE).xml
	
pdf: check
	@( [ $(STYLESHEET_PDF) = DESACTIVADO ] \
	&& \
	$(ECHO) "--(!)-- Se ha deshabilitado la conversión a PDF" )\
	|| \
	$(DOCBOOK2PDF) -d $(STYLESHEET_PDF) $(NOMBRE).xml
	
comprimidos: txt single multi ps pdf
	$(TAR) jcf $(NOMBRE)-single.tar.bz2 $(NOMBRE).html
	$(TAR) jcf $(NOMBRE)-multi.tar.bz2 *.html
	
	@[ $(STYLESHEET_PDF) != DESACTIVADO ] \
	&& \
		$(TAR) jcf $(NOMBRE)-pdf.tar.bz2 $(NOMBRE).pdf
	
	$(TAR) jcf $(NOMBRE)-ps.tar.bz2 $(NOMBRE).ps
	$(TAR) jcf $(NOMBRE)-source.tar.bz2 $(NOMBRE).xml
	$(TAR) zcf $(NOMBRE)-single.tar.gz $(NOMBRE).html
	$(TAR) zcf $(NOMBRE)-multi.tar.gz *.html
	
	@[ $(STYLESHEET_PDF) != DESACTIVADO ] \
	&& \
		$(TAR) zcf $(NOMBRE)-pdf.tar.gz $(NOMBRE).pdf
	
	$(TAR) zcf $(NOMBRE)-ps.tar.gz $(NOMBRE).ps
	$(TAR) zcf $(NOMBRE)-source.tar.gz $(NOMBRE).xml
	$(ZIP) $(NOMBRE)-single.zip $(NOMBRE).html
	$(ZIP) $(NOMBRE)-multi.zip *.html
	
	@[ $(STYLESHEET_PDF) != DESACTIVADO ] \
	&& \
		$(ZIP) $(NOMBRE)-pdf.zip $(NOMBRE).pdf
	
	$(ZIP) $(NOMBRE)-ps.zip $(NOMBRE).ps
	$(ZIP) $(NOMBRE)-source.zip $(NOMBRE).xml
check:
	$(XMLLINT) --valid --noout $(NOMBRE).xml
txt: check
	$(DOCBOOK2TXT) $(NOMBRE).xml
z7: htmlclean images single multi
	@list=`/bin/ls *.html`; for i in $$list; \
	do \
	$(SED) 's/<head>/<head><link rel=\"stylesheet\" href=\"zonasiete.css\">/g' $$i > $$i"2" ; \
	$(MV) $$i"2" $$i; \
	done; \
	$(ECHO) "Los siguientes ficheros han sido convertidos: "$$list
clean:
	$(RM) *~
htmlclean:
	$(RM) -f *.html
images: images.tar.bz2
	$(TAR) jxvf images.tar.bz2
images.tar.bz2:
	@$(ECHO) "--(!)-- Falta el archivo de imágenes"
