# Makefile
#
# Copyright (C) 2000 César Ballardini
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# $Id: Makefile,v 1.10 2005/01/08 21:34:08 olea Exp $
# 
# HACER:
# agregar el sistema de control de versión
#
#
FICH=diccionario-us-es
VERSION=0.1.6
FECHA=$(shell date "+%d %b %Y")

#DIR_FUENTES=../../originales-giait/dic-src/
DIR_FUENTES=./datos

DIR_DESTINO=.

DIR_DICT=/usr/lib/dict

INICIALES=0 a b c d e f g h i j k l m n o p q r s t u v w x y z
INICIALES_TEXINFO=${patsubst %$,%.texinfo,${INICIALES}}

CAPITULOS= 1 2 3  4  5  6  7  8  9 10 \
	11 12 13 14 15 16 17 18 19 20 \
	21 22 23 24 25 26 27 28 toc

FUENTES_DESARROLLO=AUTHORS COPYING INSTALL NEWS README TODO VERSION	\
	Makefile txi-es.tex texinfo.tex					\
	mkl nota-gpl.txt gpl-es.txt					\
	diccionario-us-es.texinfo fdl.texi gpl.texi			\
	pc850iso_subst isototexi_subst

PAQUETES=${FICH}-${VERSION}.pdf ${FICH}-${VERSION}-html.tar.gz	\
	${FICH}-${VERSION}.info ${FICH}-${VERSION}-src.tar.gz	\
	${FICH}-${VERSION}-dict.tar.gz ${FICH}-${VERSION}-giait.tar.gz


#
# METAS:
#
all : pdf-pack html-pack info-pack giait-pack src-pack dict-pack VERSION
#all : dvi-pack pdf-pack ps-pack \
	tar cvf ../${FICH}-${VERSION}-full.tar ${PAQUETES}
	#mv ${PAQUETES} ..
	make distclean


#
# Formatos de salida
#
dvi : ${FICH}-${VERSION}.dvi
ps  : ${FICH}-${VERSION}.ps
pdf : ${FICH}-${VERSION}.pdf
html: ${FICH}-${VERSION}/
info: ${FICH}-${VERSION}.info
dict: ${FICH}-${VERSION}.dict.dz


#
# Empaquetados para entregas
#
dvi-pack  : ${FICH}-${VERSION}.dvi.gz
ps-pack   : ${FICH}-${VERSION}.ps.gz
pdf-pack  : ${FICH}-${VERSION}.pdf
html-pack : ${FICH}-${VERSION}-html.tar.gz
info-pack : ${FICH}-${VERSION}.info
src-pack  : ${FICH}-${VERSION}-src.tar.gz
dict-pack : ${FICH}-${VERSION}-dict.tar.gz
giait-pack : ${FICH}-${VERSION}-giait.tar.gz

VERSION : Makefile
	echo ${VERSION} > VERSION


${FICH}-${VERSION}.dvi.gz : ${FICH}-${VERSION}.dvi
	gzip --name --to-stdout $? > $@

${FICH}-${VERSION}.ps.gz : ${FICH}-${VERSION}.ps
	gzip --name --to-stdout $? > $@

${FICH}-${VERSION}-pdf.zip : ${FICH}-${VERSION}.pdf
	zip $@ $?

${FICH}-${VERSION}-giait.tar.gz : ${patsubst %$,${DIR_FUENTES}/%.txt,${INICIALES}}
	-tar cvz --ignore-failed-read --file $@ ${patsubst %$,${DIR_FUENTES}/%.txt,${INICIALES}}

${FICH}-${VERSION}-html.tar.gz : html
	-tar cvz --ignore-failed-read --file $@ ${FICH}-${VERSION}/
#	-tar cvz --ignore-failed-read --file $@		\
#	`for CAP in ${CAPITULOS} ;			\
#	do						\
#		echo ${FICH}-${VERSION}_$${CAP}.html;	\
#	done`

${FICH}-${VERSION}.info.gz : ${FICH}-${VERSION}.info
	gzip $?
#
# las siguientes líneas son útiles cuando no se usa el --no-split
#	-tar cvz --ignore-failed-read --file $@		\
#	`for CAP in ${CAPITULOS} ;			\
#	do						\
#		echo ${FICH}-${VERSION}_$${CAP}.info;	\
#	done`

${FICH}-${VERSION}-src.tar.gz : ${FUENTES_DESARROLLO}
	tar cvzf $@ ${FUENTES_DESARROLLO}

${FICH}-${VERSION}-dict.tar.gz : ${FICH}-${VERSION}.dict.dz ${FICH}-${VERSION}.index
	tar cvzf $@ ${FICH}-${VERSION}.dict.dz ${FICH}-${VERSION}.index



#
# genera formato para dictd/dict client/server
#
${FICH}-${VERSION}.txt : ${patsubst %$,${DIR_FUENTES}/%.txt,${INICIALES}} VERSION
	./giait2dict < ${patsubst %$,${DIR_FUENTES}/%.txt,${INICIALES}} > $@


${FICH}-${VERSION}.dict ${FICH}-${VERSION}.index : ${FICH}-${VERSION}.txt
	LANG="es_ES"
	export LANG
	dictfmt -j -u http://lucas.hispalinux.es/diccionario \
		--locale es_ES -s "Diccionario ingles/castellano (${VERSION}/${FECHA})" \
		${FICH}-${VERSION} < $?

${FICH}-${VERSION}.dict.dz : ${FICH}-${VERSION}.dict
	dictzip $?


install.dict : ${FICH}-${VERSION}.index ${FICH}-${VERSION}.dict.dz
	su -c "install -m 755 -d $(DIR_DICT) ; \
	if [ -e ${FICH}-${VERSION}.dict.dz ]; then \
		install -m 644 ${FICH}-${VERSION}.dict.dz $(DIR_DICT); \
	else \
		install -m 644 ${FICH}-${VERSION}.dict $(DIR_DICT); \
	fi ; \
	install -m 644 ${FICH}-${VERSION}.index $(DIR_DICT); \
	killall dictd; \
	/usr/sbin/dictd  -v -c /etc/dictd.conf"



#
# los datos originales estaban codificados en PC850 con retornos
# de carro al estido MS-DOS
#
convertir-a-iso:
	for letra in ${INICIALES} ; do make datos/$$letra.txt ; done

datos/%.txt : pc850-datos/%.txt pc850iso_subst
	sed -e "s///g" -f  pc850iso_subst < $< > $@


#
# genera el texinfo de cada letra (esto se puede mejorar)
#
%.texinfo : ${DIR_FUENTES}/%.txt mkl Makefile
	export DIR_FUENTES; export DIR_DESTINO; cat $< | sed -e "s/@/@@/g" | ./mkl $(patsubst %.txt,%,$(<F)) > $@

${FICH}-${VERSION}.texinfo : ${FICH}.texinfo VERSION
	sed	-e "s/^@setfilename.*/@setfilename ${FICH}-${VERSION}.info/" \
		-e "s/^@include[ ]*fdl.texinfo.*/@include fdl-${VERSION}.texinfo/" \
		-e "s/^VERSION.*/${VERSION}/" \
		-e "s/^FECHA.*/${FECHA}/" \
		< $< > $@

fdl-${VERSION}.texinfo : fdl.texi
	sed -e "s/^@bye.*//" < $? > $@



${FICH}-${VERSION}.dvi: ${FICH}-${VERSION}.texinfo fdl-${VERSION}.texinfo ${INICIALES_TEXINFO} txi-es.tex
	texi2dvi --batch --language=es ${FICH}-${VERSION}.texinfo

${FICH}-${VERSION}.pdf: ${FICH}-${VERSION}.texinfo fdl-${VERSION}.texinfo ${INICIALES_TEXINFO} txi-es.tex
	texi2pdf --batch --language=es ${FICH}-${VERSION}.texinfo

${FICH}-${VERSION}.ps : ${FICH}-${VERSION}.dvi
	dvips -o $@ $?

${FICH}-${VERSION}.info : ${FICH}-${VERSION}.texinfo fdl-${VERSION}.texinfo ${INICIALES_TEXINFO} txi-es.tex
	-makeinfo --force --no-split ${FICH}-${VERSION}.texinfo

${FICH}-${VERSION}/: ${FICH}-${VERSION}.texinfo fdl-${VERSION}.texinfo ${INICIALES_TEXINFO} txi-es.tex
	#texi2html -verbose  -expandinfo -split_node ${FICH}-${VERSION}.texinfo
	makeinfo --force --css-include=estilo.css  --html ${FICH}-${VERSION}.texinfo


.PHONY: clean distclean veryyclean
#
# borrar todos los ficheros auxiliares
#
clean:
	-rm -f ${FICH}-${VERSION}.log ${FICH}-${VERSION}.aux  $(FICH)-${VERSION}.toc \
		${FICH}-${VERSION}.cps ${FICH}-${VERSION}.fns ${FICH}-${VERSION}.kys \
		${FICH}-${VERSION}.pgs ${FICH}-${VERSION}.tps ${FICH}-${VERSION}.vrs \
		${FICH}-${VERSION}.cp ${FICH}-${VERSION}.fn ${FICH}-${VERSION}.ky \
		${FICH}-${VERSION}.pg ${FICH}-${VERSION}.tp ${FICH}-${VERSION}.tmp ${FICH}-${VERSION}.vr \
		${FICH}.aux ${FICH}.cp ${FICH}.fn ${FICH}.ky ${FICH}.log ${FICH}.pg \
		${FICH}.toc ${FICH}.tp ${FICH}.vr

#
# borrar todo aquello que puede ser generado excepto los paquetes de entrega
#
distclean: clean
	-rm -f ${FICH}-${VERSION}.dvi					\
		${FICH}-${VERSION}.ps					\
		${FICH}-${VERSION}.dict ${FICH}-${VERSION}.dict.dz ${FICH}-${VERSION}.index \
		${FICH}-${VERSION}.texinfo fdl-${VERSION}.texinfo	\
		${FICH}-${VERSION}.html  ${FICH}-${VERSION}_*.html	\
		${FICH}-${VERSION}.txt					\
		$(DIR_DESTINO)/[0a-z].texinfo

#
# borrar los archivos de entrega
#
veryclean: distclean
	-rm -f ${PAQUETES}


#
# control de versiones (robado inmisericordemente de dict-misc)
#
#.PHONY: ChangeLog
#ChangeLog:
#	@(echo "***** Making new ChangeLog..."; \
#	rm -f ChangeLog; \
#	AWK=gawk rcs2log -i 2 > ChangeLog)
#
#dist: ChangeLog
#	@(NAME=$(NAME); \
#	export NAME; \
#	CVSROOT=`cat CVS/Root`; \
#	export CVSROOT; \
#	VERSION=$(VERSION); \
#	export VERSION; \
#	echo "***** Copying ChangeLog for $${NAME}-$${VERSION}..."; \
#	cp ChangeLog /tmp; \
#	echo "***** Exporting files for $${NAME}-$${VERSION}..."; \
#	cd /tmp; \
#	rm -rf /tmp/$${NAME}-$${VERSION} /tmp/$${NAME}-$${VERSION}.tar.gz; \
#	cvs export -fNd $${NAME}-$${VERSION} -r HEAD $${NAME}; \
#	cd $${NAME}-$${VERSION}; \
#	make -f Makefile.conf; \
#	mv ../ChangeLog .; \
#	cd ..; \
#	echo "***** Taring and zipping $${NAME}-$${VERSION}.tar.gz..."; \
#	tar cvvf $${NAME}-$${VERSION}.tar $${NAME}-$${VERSION}; \
#	gzip -9 $${NAME}-$${VERSION}.tar; \
#	echo "***** Done making /tmp/$${NAME}-$${VERSION}.tar.gz")

# EOF Makefile
