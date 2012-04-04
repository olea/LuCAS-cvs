
SOURCE = index.xml

all: html

html: $(SOURCE)
	mkdir -p html
	mkdir -p html/figuras
	cp figuras/*.png html/figuras/
	xmlto html -o html/ index.xml


clean: 
	rm -r html
