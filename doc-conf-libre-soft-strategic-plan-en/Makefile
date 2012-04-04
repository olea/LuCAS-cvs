
all: transpas

transpas: slide001.html

slide001.html: guion.txt
	@tidy -c -asxml -quiet -latin1 -i -wrap 9000 -slides < guion.txt 2> /dev/null 
	@ln -s slide001.html index.html

guion.html: guion.txt
	@tidy  -asxml -quit -latin1 -i -wrap 9000 < guion.txt > guion.html 2> /dev/null

clean:
	@rm -f slide*html guion.html


guion.pdf: guion.html
	@sed -e "s/<h2>/<\!--NewPage--><h2>/g" guion.html | html2ps  -D -f transpas.rc | gs -sPAPERSIZE=a4  -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=guion.pdf -

guion-tres.pdf: guion.html
	@sed -e "s/<h2>/<\!--NewPage--><h2>/g" guion.html | html2ps  -D -f transpas.rc |psnup -3 |gs -sPAPERSIZE=a4  -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=guion-tres.pdf -
