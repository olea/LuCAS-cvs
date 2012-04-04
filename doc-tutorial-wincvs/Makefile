#Author: Jaime Irving Davila
#Date: 23/09/2001
#Given to the public domain

#Variables useful for the customization of the makefile

#Name of the document (without the sgml extension)
DOC = wincvs

#Name of the file used for the index (without the sgml extension)
INDEX = genindex

#Name of the compiler of the sgml, could be jade, nsglms, ..
COMPILER = jade

#Location of the stylesheet for the html output
SINGLEDBSTYLESHEET = /usr/share/sgml/docbook/dsssl/ldp/ldp.dsl

DBSTYLESHEET = /usr/share/sgml/docbook/dsssl/ldp/ldp.dsl

#Options for generating a single HTML output
SINGLEHTMLOPT = -t sgml -d${SINGLEDBSTYLESHEET}\#html -V nochunks

#Options for generating multiple HTML output
MULTIPLEHTMLOPT = -t sgml -ihtml -d${SINGLEDBSTYLESHEET}\#html 

#Name of the directory for the source sgml
SGMLDIR = src

#Name of the directory for the "others" files
OTHERSDIR = others

#Name of the directory for the jpg files
JPGDIR = jpg

#Name of the directory for the output single html
SINGLEHTMLDIR = out-html

#Name of the directory for the output of the multiple html
MULTIPLEHTMLDIR = out-htmls

#Name of the directory for the output the ps file
PSDIR = out-ps

#Name of the script which generates the ps file, in RedHat it's db2ps
SCRIPTPS = db2ps

#Variables needed by the rules, should NOT be changed
#Variable for including the sgml source file
VPATH = ${SGMLDIR}

#Variable for knowing if there exists the sgml index file, in case it
#NOT exists its value is empty, otherwise it's the name of the index
ISINDEX = ${findstring ${INDEX}, ${wildcard ${SGMLDIR}/*.sgml}}

#Variable for knowing if the tag init will be needed
ifneq (${ISINDEX}, ${INDEX})
	USEINIT = init
endif

#Variable for storing the name of all the files in the "others" directory
OTHERFILES = $(wildcard ${OTHERSDIR}/*)

#Variable for storing the names of the "others" files placed in the
#single-html directory
OTHERSINGLE = $(patsubst others/%, ${SINGLEHTMLDIR}/%, ${OTHERFILES} )

#Variable for storing the names of the "others" files placed in the
#multiple-html directory
OTHERMULTIPLE = $(patsubst others/%, ${MULTIPLEHTMLDIR}/%, ${OTHERFILES} )

#Variable for storing the names of the jpg's pictures
JPGFILES = $(wildcard ${JPGDIR}/*.jpg)

#Variable for storing the names of the jpg's files placed on the
#single-html directory
JPGSINGLE = $(patsubst ${JPGDIR}/%, ${SINGLEHTMLDIR}/%, ${JPGFILES})

#Variable for storing the names of the jpg's files placed on the
#single-html directory
JPGMULTIPLE = $(patsubst ${JPGDIR}/%, ${MULTIPLEHTMLDIR}/%, ${JPGFILES})

#Variable for storing the names of the eps files
FIGEPS = $(patsubst ${JPGDIR}/%.jpg, ${PSDIR}/%.eps, ${JPGFILES})

all: single-html multiple-html ps

.PHONY: all single-html clean init cpfilessingle multiple-html cpfilesmultiple distsource ps

#Rules needed for generating a single html
single-html: ${SINGLEHTMLDIR}/${DOC}.html cpfilessingle

${SINGLEHTMLDIR}/${DOC}.html: ${SINGLEHTMLDIR} ${INDEX}.sgml.s
	cp -f ${SGMLDIR}/${INDEX}.sgml.s ${SGMLDIR}/${INDEX}.sgml
	${COMPILER} ${SINGLEHTMLOPT} ${SGMLDIR}/${DOC}.sgml > ${SINGLEHTMLDIR}/${DOC}.html

${SINGLEHTMLDIR}:
	mkdir ${SINGLEHTMLDIR}

${INDEX}.sgml.s: HTML.index.s
	perl -S collateindex.pl -o ${SGMLDIR}/${INDEX}.sgml.s ${SGMLDIR}/HTML.index.s

HTML.index.s: ${DOC}.sgml ${USEINIT}
	${COMPILER} ${SINGLEHTMLOPT} -V html-index ${SGMLDIR}/${DOC}.sgml > /dev/null
	mv HTML.index ${SGMLDIR}/HTML.index.s

cpfilessingle: ${JPGSINGLE} ${OTHERSINGLE}

${SINGLEHTMLDIR}/%.jpg: ${JPGDIR}/%.jpg
	cp -rf $< $@

${SINGLEHTMLDIR}/%: ${OTHERSDIR}/%
	cp -rf $< $@

#Rules needed for generating multiple html files

multiple-html: ${MULTIPLEHTMLDIR}/${DOC}.html cpfilesmultiple

${MULTIPLEHTMLDIR}/${DOC}.html: ${MULTIPLEHTMLDIR} ${INDEX}.sgml.m
	cp -f ${SGMLDIR}/${INDEX}.sgml.m ${SGMLDIR}/${INDEX}.sgml
	${COMPILER} ${MULTIPLEHTMLOPT} ${SGMLDIR}/${DOC}.sgml
	mv *.html ${MULTIPLEHTMLDIR}

HTML.index.m: ${DOC}.sgml ${USEINIT}
	${COMPILER} ${MULTIPLEHTMLOPT} -V html-index ${SGMLDIR}/${DOC}.sgml > /dev/null
	mv HTML.index ${SGMLDIR}/HTML.index.m

${INDEX}.sgml.m: HTML.index.m
	perl -S collateindex.pl -o ${SGMLDIR}/${INDEX}.sgml.m ${SGMLDIR}/HTML.index.m

${MULTIPLEHTMLDIR}:
	mkdir ${MULTIPLEHTMLDIR}

cpfilesmultiple: ${JPGMULTIPLE} ${OTHERMULTIPLE}

${MULTIPLEHTMLDIR}/%.jpg: ${JPGDIR}/%.jpg
	cp -rf $< $@

${MULTIPLEHTMLDIR}/%: ${OTHERSDIR}/%
	cp -rf $< $@

#Rules needed for generating the ps file

ps: ${PSDIR}/${DOC}.ps

${PSDIR}/${DOC}.ps: ${PSDIR} ${FIGEPS}
	cp -rf ${SGMLDIR}/*.sgml ${PSDIR};cd ${PSDIR};${SCRIPTPS} ${DOC}.sgml;cd ..

${PSDIR}/%.eps: ${JPGDIR}/%.jpg ${PSDIR}
	convert $< $@

${PSDIR}:
	mkdir ${PSDIR}

#Some additional and standard tags
init:
	perl -S collateindex.pl -N -o ${SGMLDIR}/${INDEX}.sgml

distsource: clean
	rm -f ${OTHERSDIR}/${DOC}.tar.gz
	tar cvfz ${DOC}.tar.gz *
	mv ${DOC}.tar.gz ${OTHERSDIR}

clean:
	rm -rf ${SINGLEHTMLDIR} ${MULTIPLEHTMLDIR} ${SGMLDIR}/*.index.* ${SGMLDIR}/${INDEX}.sgml*  ${PSDIR}




