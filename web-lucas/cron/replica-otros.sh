#!/bin/sh
##
# Codigo fuente LuCAS V3
# (C) 1999 Juan J. Amor, Ismael Olea / Hispalinux
##
# $Id: replica-otros.sh,v 1.19 2003/12/10 13:02:47 data Exp $
##

DESTDIR=/srv/chroot/var/www
WEBDAV=webdav.es.tldp.org
TLDP=es.tldp.org

# Apanyo para que mirror.pl use mi mailx y compress local
PATH=/home/jjamor/bin:$PATH
export PATH
umask 002
# Este guion hace una replica de diversas secciones
# Salida a un log ...
# exec > /var/www/webdav.es.tldp.org/web-lucas/cron/replica-otros.log 2>&1

# COES
echo "INICIANDO REPLICA COES:"
echo ""
mkdir -p $DESTDIR/$WEBDAV/COES && cd $DESTDIR/$WEBDAV/COES && fmirror -f../web-lucas/local/etc/fmirror-coes.conf

# PAMELI
echo "INICIANDO REPLICA PAMELI:" 
echo ""
mkdir -p $DESTDIR/$WEBDAV/PAMELI && cd $DESTDIR/$WEBDAV/PAMELI && wget -a $DESTDIR/$WEBDAV/web-lucas/cron/replica-otros.log -m -nH --relative --no-parent http://ditec.um.es/~piernas/manpages-es/

# DEBIAN (DOC-ES)
echo "INICIANDO REPLICA DEBIAN (DOC-ES):"
echo ""
mkdir -p $DESTDIR/$WEBDAV/DEBIAN && cd $DESTDIR/$WEBDAV/DEBIAN && wget -a $DESTDIR/$WEBDAV/web-lucas/cron/replica-otros.log -m -nH --relative --no-parent http://www.dat.etsit.upm.es/~jfs/debian/doc/es/

# GNOME
echo "INICIANDO REPLICA GNOME:"
echo ""
mkdir -p $DESTDIR/$WEBDAV/GNOME && cd $DESTDIR/$WEBDAV/GNOME && fmirror -f../web-lucas/local/etc/fmirror-gnome-es1.conf && fmirror -f../web-lucas/local/etc/fmirror-gnome-es2.conf

# LINUXFOCUS ES
echo "INICIANDO REPLICA LINUXFOCUS-ES: "
echo ""
mkdir -p $DESTDIR/$WEBDAV/LinuxFocus && cd $DESTDIR/$WEBDAV/LinuxFocus && fmirror -f../web-lucas/local/etc/fmirror-lfcast.conf && fmirror -f../web-lucas/local/etc/fmirror-lfcommon.conf

# CERVANTeX
echo "INICIANDO REPLICA CERVANTeX: "
echo ""
mkdir -p $DESTDIR/$WEBDAV/CervanTeX && cd $DESTDIR/$WEBDAV/CervanTeX && wget -a $DESTDIR/$WEBDAV/web-lucas/cron/replica-otros.log -m -nH --relative --no-parent http://w3.mecanica.upm.es/CervanTeX/

# ORCA
echo "INICIANDO REPLICA ORCA: "
echo ""
mkdir -p $DESTDIR/$WEBDAV/ORCA && cd $DESTDIR/$WEBDAV/ORCA && fmirror -f../web-lucas/local/etc/fmirror-orca.conf

# NuLies
echo "INICIANDO RÉPLICA de NuLies: "
echo ""
mkdir -p $DESTDIR/$WEBDAV/NuLies/ && cd $DESTDIR/$WEBDAV/NuLies/ && cvs update -d

# Cursos
echo "INICIANDO RÉPLICA de Cursos: "
echo ""
mkdir -p $DESTDIR/$WEBDAV/Cursos && cd $DESTDIR/$WEBDAV/Cursos/ && cvs update -d

# Postgresqles
#
# Desactivada a petición de Roberto el 31-08-2001
#
echo "INICIANDO RÉPLICA de Postgresqles: "
echo ""
mkdir -p $DESTDIR/$WEBDAV/Postgresql-es/web && cd $DESTDIR/$WEBDAV/Postgresql-es/web && cvs update -d

# Articulos periodisticos
echo "INICIANDO RÉPLICA de Artículos periodísticos: "
echo ""
mkdir -p $DESTDIR/$WEBDAV/Articulos-periodisticos && cd $DESTDIR/$WEBDAV/Articulos-periodisticos && cvs update -d

# Allegro-es
echo "INICIANDO RÉPLICA de Allegro-es: "
echo ""
mkdir $DESTDIR/$WEBDAV/Allegro-es && cd $DESTDIR/$WEBDAV/Allegro-es && cvs update -d

# Tutorial de PERL
#echo "INICIANDO RÉPLICA del tutorial de PERL: "
#echo ""
# /home/ftp/pub/LuCAS/web-lucas/local/bin/repl-tutperl
#cd /home/ftp/pub/LuCAS/Tutoriales/PERL
#wget http://granavenida.com/perl/tutoperl.tgz
#wget http://granavenida.com/perl/tutoperl.zip
#wget http://granavenida.com/perl/tutoperl-ejemplos.zip

