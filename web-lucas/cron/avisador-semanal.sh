#!/bin/sh
##
# Codigo fuente LuCAS V3
# (C) 1999 Juan J. Amor / Hispalinux
##
# $Id: avisador-semanal.sh,v 1.3 2003/01/26 15:23:55 carlos Exp $
##
export PATH=${PATH}:/home/jjamor/bin
umask 002
# Log
exec > /var/www/webdav.es.tldp.org/web-lucas/cron/avisador-semanal.log 2>&1

cd /var/www/webdav.es.tldp.org/web-lucas/wml
make -f Makefile.avisador
