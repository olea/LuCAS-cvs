#!/usr/bin/python
# -*- coding: iso-8859-1 -*-

# Proyecto "Pensar en C++", traducción de "Thinking in C++" de Bruce Eckel
#
# Este programilla prepara los ficheros fuentes .cpp para ser incluidos
# en el texto mediante XInclude.  Para ello cambia los fichero de formato
# DOS a Unix utilizando dos2unix. También elimina las lineas [1:4] de modo
# que queden tal como aparecen en el libro original.
#
#
# Copyright (C) 2004 David Villa
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Library General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

import sys, os


def main(codedir):

   # subdirectorios de las capítulos
   content = [os.path.join(codedir, x) for x in os.listdir(codedir)]
   chapters = [x for x in content if os.path.isdir(x)]

   for d in chapters:
      for f in os.listdir(d):
	 filename = os.path.join(d, f)
	 print 'Arreglando', filename
	 os.system('dos2unix ' + filename)
	 dellines(filename, 1, 4)


# elimina las líneas del rango l1-l2 en el fichero 'name'
def dellines(name, l1, l2):
   handler = open(name)
   content = handler.readlines()
   handler.close()

   handler = open(name, 'w')
   n = 0
   for l in content:
      if  not l2 >= n >= l1:
	 handler.write(l)
      n += 1
	 
   handler.close()
	 

main(sys.argv[1])

