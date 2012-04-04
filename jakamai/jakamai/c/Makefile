##
# Código fuente Jakamai
# Copyright (C) 2001 Hispalinux / Juan J. Amor
# Programa bajo la proteccion de GPL 2.0
##
# $Id: Makefile,v 1.3 2002/02/02 14:47:22 olea Exp $
##

damesrv: damesrv.o
	gcc -Wall -O2 -o damesrv damesrv.o
	strip damesrv

damesrv.o: damesrv.c config.h
	gcc -Wall -c -O2 -o damesrv.o damesrv.c

install: damesrv
	echo "Te vas a comer los mocos, así que pide en un parte que los administradores te lo instalen"
	/usr/bin/install -o www-data -g www-data -m 4775 damesrv /etc/apache/damesrv

clean:
	rm -f damesrv damesrv.o
