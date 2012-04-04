all: 
	utils/generaEPS.sh
	latex curso
#	latex profesor
	latex curso
	latex profesor
	dvips curso.dvi -o curso.ps
	dvips profesor.dvi -o profesor.ps

clean:
	rm --force *.ps *.aux *.toc *.lo? *~ *.dvi
	rm --force --recursive */*.ps */*.aux */*.toc */*.lo? */*~ */*.dvi
	rm --force imagenes/eps/*.eps

clean2:
	rm --force *.ps *.aux *.toc *.lo? *~ *.dvi
	rm --force --recursive */*.ps */*.aux */*.toc */*.lo? */*~ */*.dvi

images: all html
	ps2pdf curso.ps
	gzip -9 curso.ps
	gzip -9 curso.pdf
	mv curso.ps.gz ../distro/intermedio/intermedio.ps.gz
	mv curso.pdf.gz ../distro/intermedio/intermedio.pdf.gz

html:
	latex2html -address "Proyecto Cursos - LuCAS - http://lucas.hispalinux.es/htmls/cursos.html" -info "Este curso es fruto del esfuerzo de mucha gente, te invitamos a ayudarnos a mejorarlo. Solo debes conectarte a http://lucas.hispalinux.es." -white -local_icons -antialias_text -auto_navigation -antialias -dir ../distro/intermedio/html curso.tex
	tar cvz -C ../distro/intermedio -f ../distro/intermedio/intermedio-html.tar.gz html

distro: images clean
	tar cvz -C .. -f ../distro/intermedio/intermedio.tar.gz intermedio
