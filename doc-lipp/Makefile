dvi: 
	cat < /dev/null > lipp2.ind
	latex lipp2.tex
	makeindex lipp2.idx
	latex lipp2.tex
clean:  
	rm -rf *.log *~ *.dvi  *.aux *.toc *.swp *.idx *.ilg *.ind *.pdf
	rm -rf lipp2
	find .. -name '*~' -exec rm -f {} \;
	find .. -name '#*#' -exec rm -f {} \;
	find .. -name '*.log' -exec rm -f {} \;
	find .. -name '*.pdf' -exec rm -f {} \;
ps:dvi
	dvips -o lipp2.ps lipp2.dvi

pdf:dvi
	epstopdf tutorial/dirtree.eps
	pdflatex lipp2.tex	

html:
	latex2html lipp2.tex 
all: html pdf ps dvi

