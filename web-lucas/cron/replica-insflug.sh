#!/bin/sh
##
# Codigo fuente LuCAS V3
# (C) 1999 Juan J. Amor / Hispalinux
##
# $Id: replica-insflug.sh,v 1.7 2003/12/10 13:02:47 data Exp $
##
##
#
DESTDIR=/srv/chroot/var/www/
WEBDAV=webdav.es.tldp.org
TLDP=es.tldp.org

export PATH=${PATH}:/home/jjamor/bin
umask 002
#
# Este guion hace una replica del ftp de INSFLUG
# Salida a un log ...
# exec > /var/www/webdav.es.tldp.org/web-lucas/cron/replica-insflug.log 2>&1

# Apanyo para que mirror.pl use mi mailx local
PATH=/home/jjamor/bin:$PATH
export PATH

cd /var/www/webdav.es.tldp.org/COMO-INSFLUG
cd $DESTDIR/$WEBDAV/COMO-INSFLUG

# Antiguo: con mirror.pl
# /home/ftp/pub/LuCAS/web-lucas/local/bin/replicar -C../etc/mirror.conf -pinsflug
# /home/ftp/pub/LuCAS/web-lucas/local/bin/replicar -C../etc/mirror.conf -pinsflug-porrevisar

# Con fmirror:
fmirror -f../web-lucas/local/etc/fmirror-insflug.conf 
fmirror -f../web-lucas/local/etc/fmirror-insflug-revisar.conf

# Apaño temporal
rm -f $DESTDIR/$WEBDAV/COMO-INSFLUG/pub/PorRevisar/index.html

## Generacion de la parte navegable
# Salida a un log ...
# exec > /var/www/webdav.es.tldp.org/web-lucas/cron/replica-insflug-navegable.log 2>&1

cd $DESTDIR/$WEBDAV/web-lucas/auto-COMO
make dep
make
make -f Makefile.mini

touch ~www-data/.ssh/UPDATE
