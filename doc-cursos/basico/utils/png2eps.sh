#!/bin/sh
# Convierte los archivos PNG en EPS

#    Introducción al uso de GNU/Linux - Manual para el dictado de cursos
#    Copyright (C) 2000 Lucas Di Pentima, Nicolás César
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

for i in `ls $1`;
do
	ARCHIVO=`basename $i .png`
	pngtopnm $i > $ARCHIVO.pnm
	pnmtops -noturn -rle $ARCHIVO.pnm > $ARCHIVO.ps 2>/dev/null
	ps2epsi $ARCHIVO.ps
	rm $ARCHIVO.ps
	rm $ARCHIVO.pnm
	mv $ARCHIVO.epsi $ARCHIVO.eps
done
