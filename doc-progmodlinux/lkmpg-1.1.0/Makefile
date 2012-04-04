# Make file para documentos del estilo LDP TeX LDP
# Ori Pomerantz, 1998
# Modificado para pdflatex por Fco. Javier Fernández

default: dvi

paquete: pdf html ps
	mkdir -p ../paquete
	cp progmodlinux.pdf ../paquete/
	cp progmodlinux.ps  ../paquete/
	cp progmodlinux.dvi ../paquete/
	(cd ../source; tar cvf ../paquete/progmodlinux_src.tar .)
	tar cvf ../paquete/progmodlinux_html.tar html
	tar cvf ../paquete/progmodlinux_tex.tar *.m4 Makefile	

tex: progmodlinux.m4 thankme.m4 gpl.m4 copyright.m4 ../source/*/*.c ../source/*/*.h
	m4 <progmodlinux.m4 > progmodlinux.tex
#	patch -p0 < progmodlinux.diff

dvi: tex 
	cat </dev/null > progmodlinux.ind
	latex progmodlinux
	makeindex progmodlinux.idx
	latex progmodlinux

ps: dvi
	dvips -o progmodlinux.ps progmodlinux.dvi

pdf: tex
	pdflatex progmodlinux.tex

html: tex
	mkdir -p html
	latex2html -dir html progmodlinux.tex

clean:
	rm -r html *.dvi *.ps *.i* *.aux *.log *.toc progmodlinux.tex *~ *.pdf 
	find .. -name '*.o' -exec rm {} \;
	find .. -name '*~' -exec rm {} \;
	find .. -name '#*#' -exec rm {} \;
	find .. -name core -exec rm {} \;

