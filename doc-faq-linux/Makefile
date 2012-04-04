#
# $Id: Makefile,v 1.3 2003/03/21 11:56:52 rafael Exp $
#


#Variables useful for the customization of the makefile

#Name of the document (without the xml extension)
DOC = faqlinux

#Name of the file used for the index (without the xml extension)
INDEX = genindex

#Name of the compiler of the xml, could be jade, openjade, ..
COMPILER = openjade

#Location of the stylesheet for the html output
SINGLEDBSTYLESHEET = dsssl/ldp.dsl\#html
DBSTYLESHEET = dsssl/ldp2.dsl\#html

#Name of the directory for the source xml
XMLDIR = .

#Name of the directory for the png files
IMGDIR = img

#Name of the directory for the output single html
SINGLEHTMLDIR = out-html

#Name of the script which generates the html file, in RedHat it's db2html
SCRIPTHTML = docbook2html

#Options for generating a single HTML output
SINGLEHTMLOPT = -d ${SINGLEDBSTYLESHEET} -o ${SINGLEHTMLDIR} -u

#Name of the directory for the output of the multiple html
MULTIPLEHTMLDIR = out-htmls

#Options for generating a single HTML output
MULTIPLEHTMLOPT = -d ${SINGLEDBSTYLESHEET} -o ${MULTIPLEHTMLDIR}

#Name of the directory for the output the ps file
PSDIR = out-ps

#Name of the script which generates the ps file, in RedHat it's db2ps
SCRIPTPS = docbook2ps

#Name of the directory for the output the dvi file
DVIDIR = out-dvi

#Name of the script which generates the dvi file.
SCRIPTDVI = docbook2dvi

#Name of the directory for the output the pdf file
PDFDIR = out-pdf

#Name of the script which generates the ps file, in RedHat it's db2pdf
SCRIPTPDF = docbook2pdf

#Name of the directory for the output the rtf file
RTFDIR = out-rtf

#Name of the script which generates the ps file, in RedHat it's db2rtf
SCRIPTRTF = docbook2rtf

#Name of the directory for the output the txt file
TXTDIR = out-txt

#Name of the script which generates the txt file.
SCRIPTTXT = docbook2txt

#Variables needed by the rules, should NOT be changed
#Variable for including the xml source file
VPATH = ${XMLDIR}

#Variable for knowing if there exists the xml index file, in case it
#NOT exists its value is empty, otherwise it's the name of the index
ISINDEX = ${findstring ${INDEX}, ${wildcard ${XMLDIR}/*.xml}}

#Variable for knowing if the tag init will be needed
ifneq (${ISINDEX}, ${INDEX})
	USEINIT = init
endif

#Variable for storing the name of all the xml source files directory
SRCFILES = $(patsubst ${XMLDIR}/${INDEX}.xml,,$(wildcard ${XMLDIR}/*))

#Variable for storing the name of all the files in the "others" directory
OTHERFILES = $(wildcard ${OTHERSDIR}/*)

#Variable for storing the names of the "others" files placed in the
#single-html directory
OTHERSINGLE = $(patsubst others/%, ${SINGLEHTMLDIR}/%, ${OTHERFILES} )

#Variable for storing the names of the "others" files placed in the
#multiple-html directory
OTHERMULTIPLE = $(patsubst others/%, ${MULTIPLEHTMLDIR}/%, ${OTHERFILES} )

#Variable for storing the names of the png's pictures
PNGFILES = $(wildcard ${PNGDIR}/*.png)

#Variable for storing the names of the png's files placed on the
#single-html directory
PNGSINGLE = $(patsubst ${PNGDIR}/%, ${SINGLEHTMLDIR}/%, ${PNGFILES})

#Variable for storing the names of the png's files placed on the
#single-html directory
PNGMULTIPLE = $(patsubst ${PNGDIR}/%, ${MULTIPLEHTMLDIR}/%, ${PNGFILES})

#Variable for storing the names of the eps files
FIGEPS = $(patsubst ${PNGDIR}/%.png, ${PSDIR}/%.eps, ${PNGFILES})

all: clean html htmls ps dvi pdf rtf txt

#Rules needed for generating a single html
html: ${SINGLEHTMLDIR}/${DOC}.html cpfilessingle

${SINGLEHTMLDIR}/${DOC}.html: ${SINGLEHTMLDIR} ${DOC}.xml
	${SCRIPTHTML} ${SINGLEHTMLOPT} ${XMLDIR}/${DOC}.xml

${SINGLEHTMLDIR}:
	mkdir ${SINGLEHTMLDIR}

cpfilessingle: ${IMGSINGLE} ${OTHERSINGLE}

${SINGLEHTMLDIR}/%.png: ${IMGDIR}/%.png
	cp -rf $< $@

${SINGLEHTMLDIR}/%: ${OTHERSDIR}/%
	cp -rf $< $@

#Rules needed for generating multiple html files

htmls: ${MULTIPLEHTMLDIR}/${DOC}.html cpfilesmultiple

${MULTIPLEHTMLDIR}/${DOC}.html: ${MULTIPLEHTMLDIR} ${DOC}.xml
	${SCRIPTHTML} ${MULTIPLEHTMLOPT} ${XMLDIR}/${DOC}.xml

${MULTIPLEHTMLDIR}:
	mkdir ${MULTIPLEHTMLDIR}

cpfilesmultiple: ${IMGMULTIPLE} ${OTHERMULTIPLE}

${MULTIPLEHTMLDIR}/%.png: ${IMGDIR}/%.png
	cp -rf $< $@

${MULTIPLEHTMLDIR}/%: ${OTHERSDIR}/%
	cp -rf $< $@

#Rules needed for generating the ps file

ps: ${DOC}.xml
	${SCRIPTPS} -d ${SINGLEDBSTYLESHEET} -o ${PSDIR} ${DOC}.xml 

#Rules needed for generating the ps file

dvi: ${DOC}.xml
	${SCRIPTDVI} -d ${SINGLEDBSTYLESHEET} -o ${DVIDIR} ${DOC}.xml 


#Rules needed for generating the pdf file

pdf: ${DOC}.xml
	${SCRIPTPDF} -d ${SINGLEDBSTYLESHEET} -o ${PDFDIR} ${DOC}.xml 

#Rules needed for generating the rtf file

rtf: ${DOC}.xml
	${SCRIPTRTF} -d ${SINGLEDBSTYLESHEET} -o ${RTFDIR} ${DOC}.xml 

#Rules needed for generating the txt file

txt: ${DOC}.xml
	${SCRIPTTXT} -d ${SINGLEDBSTYLESHEET} -o ${TXTDIR} ${DOC}.xml 


#Some additional and standard tags
init:
	perl -S collateindex.pl -N -o ${XMLDIR}/${INDEX}.xml

distsource: clean
	tar cvfz ${DOC}.tar.gz *

clean:
	rm -rf ${XMLDIR}/${SINGLEHTMLDIR} 
	rm -rf ${XMLDIR}/${MULTIPLEHTMLDIR}
	rm -rf ${XMLDIR}/${PSDIR}
	rm -rf ${XMLDIR}/${DVIDIR}
	rm -rf ${XMLDIR}/${PDFDIR}
	rm -rf ${XMLDIR}/${RTFDIR}
	rm -rf ${XMLDIR}/${TXTDIR}
	rm -rf ${XMLDIR}/*~ 
	rm -rf ${XMLDIR}/${INDEX}.xml* 
	rm -rf ${XMLDIR}/${DOC}/ 
	rm -rf ${XMLDIR}/${DOC}.junk/
	rm -rf ${XMLDIR}/docbook2html-dir/ 
	rm -rf ${XMLDIR}/*.tar.gz