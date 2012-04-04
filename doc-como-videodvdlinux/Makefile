CATALOG :=  /etc/sgml/sgml-docbook.cat
TAR := /bin/tarcd 
ECHO := /bin/echo
ZIP := /usr/bin/zip
DOCBOOK2PS := /usr/bin/docbook2ps
DOCBOOK2PDF := /usr/bin/docbook2pdf
DOCBOOK2TXT := /usr/bin/docbook2txt
XSLTPROC := /usr/bin/xsltproc
XMLLINT := /usr/bin/xmllint
PS2PDF := /usr/bin/ps2pdf

# Parte para Gentoo
#STYLESHEET_PDF := /usr/share/sgml/stylesheets/sgmltools/print.dsl
# Fin Parte para Gentoo
#
# Parte para Debian
#STYLESHEET_PDF := /usr/share/sgml/stylesheet/dsssl/sgmltools/print.dsl
# Fin Parte para Debian

# Parte para Gentoo
#XSLTFILE := /usr/share/sgml/docbook/xsl-stylesheets-1.50.0/html/docbook.xsl
#CHUNKFILE := /usr/share/sgml/docbook/xsl-stylesheets-1.50.0/html/chunk.xsl
# Fin Parte para Gentoo
# 
# Parte para Debian
#XSLTFILE := /usr/share/apps/ksgmltools2/docbook/xsl/html/docbook.xsl
#CHUNKFILE := /usr/share/apps/ksgmltools2/docbook/xsl/html/chunk.xsl
# Fin Parde Debian

NOMBRE := videodvdlinuxcomo
OPCIONES := check single multi ps pdf txt comprimidos

.PHONY: all single multi comprimidos check txt

all: $(OPCIONES)
	@$(ECHO) "Documentos generados y comprimidos"
single: check
ifndef XSLTFILE
	@$(ECHO) "--(!)-- No se encontró la variable XSLTFILE"
	@$(ECHO) "--(!)-- Edita el Makefile para que encaje en tu distro"
else
	$(XSLTPROC) -o $(NOMBRE).html $(XSLTFILE) $(NOMBRE).xml
endif

multi: check
ifndef CHUNKFILE
	@$(ECHO) "--(!)-- No se encontró la variable CHUNKFILE"
	@$(ECHO) "--(!)-- Edita el Makefile para que encaje en tu distro"
else
	$(XSLTPROC) $(CHUNKFILE) $(NOMBRE).xml
endif
	
ps: check
	$(DOCBOOK2PS) -c $(CATALOG) $(NOMBRE).xml

pdf: check
ifndef STYLESHEET_PDF
	@$(ECHO) "--(!)-- No se encontró la variable STYLESHEET_PDF"
	@$(ECHO) "--(!)-- Edita el Makefile para que encaje en tu distro"
else
	$(DOCBOOK2PDF) -d $(STYLESHEET_PDF) $(NOMBRE).xml
endif

comprimidos: txt single multi ps pdf
	$(TAR) jcf $(NOMBRE)-single.tar.bz2 $(NOMBRE).html
	$(TAR) jcf $(NOMBRE)-multi.tar.bz2 *.html
	$(TAR) jcf $(NOMBRE)-pdf.tar.bz2 $(NOMBRE).pdf
	$(TAR) jcf $(NOMBRE)-ps.tar.bz2 $(NOMBRE).ps
	$(TAR) jcf $(NOMBRE)-source.tar.bz2 $(NOMBRE).xml
	$(TAR) zcf $(NOMBRE)-single.tar.gz $(NOMBRE).html
	$(TAR) zcf $(NOMBRE)-multi.tar.gz *.html
	$(TAR) zcf $(NOMBRE)-pdf.tar.gz $(NOMBRE).pdf
	$(TAR) zcf $(NOMBRE)-ps.tar.gz $(NOMBRE).ps
	$(TAR) zcf $(NOMBRE)-source.tar.gz $(NOMBRE).xml
	$(ZIP) $(NOMBRE)-single.zip $(NOMBRE).html
	$(ZIP) $(NOMBRE)-multi.zip *.html
	$(ZIP) $(NOMBRE)-pdf.zip $(NOMBRE).pdf
	$(ZIP) $(NOMBRE)-ps.zip $(NOMBRE).ps
	$(ZIP) $(NOMBRE)-source.zip $(NOMBRE).xml
check:
	$(XMLLINT) --valid --noout $(NOMBRE).xml
txt: check
	$(DOCBOOK2TXT) $(NOMBRE).xml
