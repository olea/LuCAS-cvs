#$Id: Makefile,v 1.1.1.1 2004/03/03 10:15:33 luismiguel.morillas Exp $
all:	Faltas

Faltas:	
	#python ../cherrypy.py  Tldp.cpy
	python ../cherrypy.py  -D Tldp.cpy

load:
	python TldpServer.py
hot:
	python ../cherryhotreload.py localhost:8008

tar:
	cp *.cpy *.py tldp-xml
	tar zcvf tldp-xml.tgz   tldp-xml

clean: 
	rm *.*~ 
	rm *.pyc
	rm *.*#
	