### Convert cvsbook texinfo files to Info, HTML, PostScript, etc.


VERSION = 1.21
NAME = cvsbook
DISTFILES = README Makefile ChangeLog cvsbook.el TODO

all: version ps pdf info html

version:
	echo "@set VERSION ${VERSION}" > version.texi

info: version
	makeinfo main.texi

html: version html-monolithic html-distributed
#	./fix-anchors.py cvsbook.html cvsbook-fixed.html
	mv cvsbook-fixed.html cvsbook.html

html-monolithic: version
	makeinfo --html main.texi

html-distributed: version
	@echo Non-monolithic HTML is not supported by makeinfo yet.

dvi: version
	for file in *.texi ; do \
	esfile=`echo $${file} | sed -e 's/\.texi/.es.texi/'`; \
	sed -f texi2tex.sed $${file} >$${esfile} ;\
	done
	sed -e 's/\.texi/.es.texi/' main.es.texi >main.es.fix.texi
	mv main.es.fix.texi main.es.texi
	tex main.es.texi

ps: dvi
	dvips main.es.dvi -o cvsbook.ps

pdf: ps
	ps2pdf cvsbook.ps cvsbook.pdf

log:
	cvs2cl.pl -r -t

dist: log info-dist html-dist ps-dist pdf-dist texi-dist big-dist

html-dist: 
	gzip -c --best ${NAME}.html > ${NAME}.html.gz
	zip ${NAME}.html.zip ${NAME}.html

ps-dist: 
	gzip -c --best ${NAME}.ps > ${NAME}.ps.gz
	zip ${NAME}.ps.zip ${NAME}.ps

pdf-dist: 
	gzip -c --best ${NAME}.pdf > ${NAME}.pdf.gz
	zip ${NAME}.pdf.zip ${NAME}.pdf

info-dist: 
	mkdir ${NAME}-${VERSION}
	cp *.info* ${DISTFILES} ${NAME}-${VERSION}
	tar cvf ${NAME}-${VERSION}-info.tar ${NAME}-${VERSION}
	gzip --best ${NAME}-${VERSION}-info.tar
	zip ${NAME}-${VERSION}-info.zip ${NAME}-${VERSION}/*
	rm -rf ${NAME}-${VERSION}

texi-dist: 
	mkdir ${NAME}-${VERSION}
	cp *.texi ${DISTFILES} ${NAME}-${VERSION}
	tar cvf ${NAME}-${VERSION}-texi.tar ${NAME}-${VERSION}
	gzip --best ${NAME}-${VERSION}-texi.tar
	zip ${NAME}-${VERSION}-texi.zip ${NAME}-${VERSION}/*
	rm -rf ${NAME}-${VERSION}

big-dist: 
	mkdir ${NAME}-${VERSION}
	cp ${DISTFILES} *.texi *.info* *.html *.ps *.pdf *.sh \
           ${NAME}-${VERSION}
	if [ -f ${NAME}-${VERSION}/${NAME}.html ]; then        \
             rm -f ${NAME}-${VERSION}/${NAME}-${VERSION}.html; \
        fi
	if [ -f ${NAME}-${VERSION}/${NAME}.ps ]; then          \
             rm -f ${NAME}-${VERSION}/${NAME}-${VERSION}.ps;   \
        fi
	tar cvf ${NAME}-${VERSION}-all.tar ${NAME}-${VERSION}
	gzip --best ${NAME}-${VERSION}-all.tar
	zip ${NAME}-${VERSION}-all.zip ${NAME}-${VERSION}/*
	rm -rf ${NAME}-${VERSION}

texclean: 
	rm -f *~ *.aux *.cp *.cps *.dvi *.fn *.ky *.log *.pg *.toc *.tp *.vr

clean: texclean
	rm -f cvsbook*.info* cvsbook*.html cvsbook*.ps *.pdf *.tar *.gz *.zip
	rm -rf ${NAME}-${VERSION}
	rm -f *.es.texi
