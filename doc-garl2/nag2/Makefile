##
# Guía de Administración de Redes Linux V2.0 / GARL2
# Copyright (C) 2001,2002 Juan J. Amor / Hispalinux
# Modificado por Jaime Irving Davila, 2002, para la
# generación del archivo índice (index.sgml) y para la
# generación de gráficas en pdf y ps
# Programa bajo la proteccion de GPL 2.0
##
# $Id: Makefile,v 1.9 2002/03/04 23:08:55 jjamor Exp $
##

HTMLDSL = $(PWD)/../utiles/html-stylesheets/godoy/livros-html.dsl
PRINTDSL = $(PWD)/../utiles/print-stylesheets/twaugh/selfdocbook.dsl\#print
CSS = $(PWD)/../utiles/html-stylesheets/godoy/publicacoes.css
DIRPUB = $(PWD)/../publicacion
HTMLDOC = /opt/htmldoc/bin/htmldoc
CATALOG = /etc/sgml/catalog

#Lista de todos los archivos sgm, sgml
DEPENDENCIAS = $(wildcard *.sgm*)
#Todos los archivos sgm, sgml excepto el indice
DEPINDICE = $(patsubst index.sgml,,$(DEPENDENCIAS))
#Lista de graficos jpg
JPGGRAFS = $(wildcard *.jpg)
#Lista de graficos png
PNGGRAFS = $(patsubst %.jpg, %.png, $(JPGGRAFS))
#Lista de graficos eps
EPSGRAFS = $(patsubst %.jpg, %.eps, $(JPGGRAFS))

all: nag2.pdf nag2.ps index.html

#Reglas para la generacion de pdf y ps usando htmldoc
nag2.old.pdf: index.sgml htmldoc.cfg $(DEPENDENCIAS)
	docbook2html -u -d /home/jjamor/cvs/garl2/utiles/html-stylesheets/godoy/livros-html.dsl nag2.sgml
	$(HTMLDOC) --batch htmldoc.cfg

nag2.old.ps: nag2.pdf
	$(HTMLDOC) --batch htmldoc-ps.cfg

#Reglas para la generacion de pdf y ps usando docbook2*
nag2.pdf: $(DEPENDENCIAS) $(PNGGRAFS)
	docbook2tex -d $(PRINTDSL) nag2.sgml
	pdfjadetex nag2
	pdfjadetex nag2
	pdfjadetex nag2

nag2.ps: $(DEPENDENCIAS) $(EPSGRAFS)
	docbook2tex -d $(PRINTDSL) nag2.sgml
	jadetex nag2
	jadetex nag2
	jadetex nag2
	dvips -o nag2.ps nag2.dvi

index.sgml: $(DEPINDICE)
	collateindex.pl -N -o index.sgml
	jade -c $(CATALOG) -t sgml -d $(HTMLDSL) -V html-index nag2.sgml > /dev/null
	rm -f *.html
	collateindex.pl -o index.sgml HTML.index

index.html: index.sgml $(DEPENDENCIAS) 
	docbook2html -d $(HTMLDSL) nag2.sgml

publicar: nag2.pdf index.html
	mkdir -p $(DIRPUB)/nag2html
	mv -f nag2.pdf $(DIRPUB)
	mv -f nag2.ps $(DIRPUB)
	mv -f *.html $(DIRPUB)/nag2html
	cp $(CSS) $(DIRPUB)/nag2html
	cp *.jpg $(DIRPUB)/nag2html

clean:
	rm -rf nag2 nag2.tex nag2.dvi nag2.out nag2.aux nag2.pdf nag2.ps nag2.log *.html HTML.index *.eps *.png

#Reglas para la creación de gráficas a partir de jpg's
%.eps: %.jpg
	convert $< $@

%.png: %.jpg
	convert $< $@
