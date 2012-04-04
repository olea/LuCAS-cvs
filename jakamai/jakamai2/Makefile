##
# Código fuente Jakamai
# Copyright (C) 2001 Hispalinux / Juan J. Amor
# Programa bajo la proteccion de GPL 2.0
##
# $Id: Makefile,v 1.1 2002/12/16 09:30:31 teo Exp $
##

damesrv: damesrv.o cadenas.o
	gcc -g -Wall -O2 -o damesrv damesrv.o cadenas.o
	strip damesrv

damesrv.o: damesrv.c damesrv.h 
	gcc -g -Wall -c -O2 -o damesrv.o damesrv.c

cadenas.o: cadenas.c cadenas.h
	gcc -g -Wall -c -O2 -o cadenas.o cadenas.c

install: damesrv
	echo "Te vas a comer los mocos, así que pide en un parte que los administradores te lo instalen"
	/usr/bin/install -o www-data -g www-data -m 4775 damesrv /etc/apache/damesrv

clean:
	rm -f damesrv damesrv.o cadenas.o damesrv.log core

produccion:
	rm -f *.LEEME
	rm -f *.example
	rm -f ChangeLog
	rm -f copyright
	rm -f GPL
	rm -f VERSION
