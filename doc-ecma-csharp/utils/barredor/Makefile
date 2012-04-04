all: barredor.exe

barredor.exe: Barredor.cs
	mcs -g Barredor.cs -out:barredor.exe

clean:
	rm -f barredor.exe*
	rm -f output.xml
	rm -f *.html
	
run: barredor.exe
	mono barredor.exe && xsltproc estilo.xslt output.xml > terminos.html
