#!/bin/sh
##
# Codigo fuente de LuCAS V3
# (C) 1999 Juan J. Amor / Hispalinux
##
# $Id: actualiza-lucas.sh,v 1.4 2003/01/26 15:23:55 carlos Exp $
##
#
# Este guion actualiza las paginas de LuCAS
#
# Salida a un log...
exec > /var/www/webdav.es.tldp.org/web-lucas/cron/actualiza-lucas.log 2>&1
#
export PATH=${PATH}:/home/jjamor/bin
umask 002
#
# En primer lugar sincronizamos con CVS
cd /var/www/webdav.es.tldp.org/web-lucas/
cvs update -d
#
cd /var/www/webdav.es.tldp.org/web-lucas/wml/
make dep
make
