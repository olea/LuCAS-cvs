# rev 0.1: Cancerbero: 
# Comentarios traducidos 

# programas
JADE = openjade


# directorio para las versiones PNG de las fórmulas matemáticas
FIGDIR = figures

# otros archivos
DOC = avl-trees
DSL = sample-both.dsl
MATHSS = TeXMath.dsl
HMATHSS = HTMLMath.dsl

all: pdf html htmls

# obtenemos una salida PDF de los fuentes Tex. Ejecutamos
# pdfjadetex 3 veces
pdf: $(DOC).tex jadetex.cfg
	pdfjadetex $(DOC).tex
	pdfjadetex $(DOC).tex
	pdfjadetex $(DOC).tex

# Para crear los fuentes tex, ejecutamos jade y "liberamos" (unescape)
# la matemática
$(DOC).tex: $(DOC).sgml $(DSL) $(MATHSS)
	$(JADE) -t tex -d $(DSL)\#print $(DOC).sgml
	./unescape_math.pl $(DOC).tex

# para hacer HTML, obtenemos las imágenes PNG de las fórmulas tex y
# luego procesamos el fuente SGML con jade

html_out:
	mkdir html_out
	cp *.png html_out/

htmls_out:
	mkdir htmls_out
	cp *.png htmls_out/

html: $(DOC).sgml $(DSL) $(HMATHSS) html_out
	cd html_out && mkdir -p $(FIGDIR) && \
	$(JADE) -t sgml -ihtml -V nochunks -d ../$(DSL)\#html \
	../$(DOC).sgml > $(DOC).html && \
	../texmath2png.pl equation-list.sgml

htmls: $(DOC).sgml $(DSL) $(HMATHSS) htmls_out
	cd htmls_out && mkdir -p $(FIGDIR) && \
	$(JADE) -t sgml -ihtml -d ../$(DSL)\#html \
	../$(DOC).sgml && \
	../texmath2png.pl equation-list.sgml

clean:
	rm -rf html_out htmls_out *.tex *.aux *.log *.out


