#!/bin/sh
# Compila todos los gifs en el directorio imagenes/ y coloca los .eps en
# el directorio imagenes/eps
# Ejecutar desde el directorio "raiz"

#    Uso y comprensión avanzados de GNU/Linux - Manual para el dictado de cursos
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

# Chequeos varios
PNM=`whereis pnmtops`
PNMTOPS=`echo $PNM | awk '{print $2}'`

PNG=`whereis pngtopnm`
PNGTOPNM=`echo $PNG | awk '{print $2}'`

EPS=`whereis ps2epsi`
PS2EPSI=`echo $EPS | awk '{print $2}'`

### ATENCION: Dejamos de soportar los GIFs, ya estamos cómodos con PNG ###

# Mas chequeos de las nuevas utilidades
if [ ! $PNGTOPNM ]; then
	echo "ERROR: La utilidad pngtopnm no existe en el sistema, por favor instalar"
	exit
else
	if [ ! $PNMTOPS ]; then
		echo "ERROR: La utilidad pnmtops no existe en el sistema, por favor instalar"
		exit
	fi
fi
echo "Generando archivos EPS desde las imágenes PNGs, por favor espera..."
for i in `ls imagenes/*.png`; 
do
	# Si el .eps correspondiente al .png existe, no lo genero...
	IMAGEN=`basename $i .png`
	if [ ! -e imagenes/eps/$IMAGEN.eps ]; then
		echo -n $i...
	        utils/png2eps.sh $i
	        mv $IMAGEN.eps imagenes/eps
	        echo Listo
	else
		if [ imagenes/eps/$IMAGEN.eps -ot imagenes/$IMAGEN.png ]; then
			echo -n $i...
			utils/png2eps.sh $i
			mv $IMAGEN.eps imagenes/eps
			echo Listo
		fi
	fi
done
	
echo "Listo! imágenes generadas, sigamos con la compilación..."
