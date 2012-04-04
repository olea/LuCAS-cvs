#!/bin/sh
# autogen.sh - generate all files needed to compile this module

if [ -f aclocal.m4 ]
then
        mv aclocal.m4 acinclude.m4
fi
	
srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.
export srcdir

ORIGDIR=`pwd`
cd $srcdir

DIE=0

# Check for autoconf, the required version is set in configure.in
(autoconf --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have at minimum autoconf version 2.12 installed."
	echo "Download the appropriate package for your distribution,"
	echo "or get the source tarball at"
	echo "ftp://ftp.gnu.org/pub/gnu/"
	DIE=1
}

# Check for automake, the required version is set in configure.in
(automake --version) < /dev/null > /dev/null 2>&1 ||{
	echo
	echo "You must have at minimum automake version 1.4 installed."
	echo "Download the appropriate package for your distribution,"
	echo "or get the source tarball at"
	echo "ftp://ftp.cygnus.com/pub/home/tromey/automake-1.4.tar.gz"
	DIE=1
}

if test "$DIE" -eq 1; then
	exit 1
fi


if test -z "$*"; then
	echo "I am going to run ./configure with no arguments - if you wish "
	echo "to pass any to it, please specify them on the $0 command line."
fi

aclocal
automake --add-missing
autoconf

cd $ORIGDIR

echo "Running $srcdir/configure --enable-maintainer-mode" "$@"
if $srcdir/configure --enable-maintainer-mode "$@"
then
	echo "Generación de ficheros completada con exito"
	echo "Teclea 'make' para comenzar la compilación"
else
	 echo "Se ha producido un error. Comprueba los mensajes aparecidos"
fi
