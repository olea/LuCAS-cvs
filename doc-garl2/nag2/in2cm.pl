#!/usr/bin/perl
# Script que reemplaza las unidades de pulgadas (in) a centímetros (cm) 
# dentro de la especificación del ancho de una columna en una ocurrencia
# de ..colwidth=" ">
# Autor: Jaime Irving Dávila, Fecha: Mayo 5-2002
# Se cede al dominio público

while (<>) {
    s/colwidth=(?:\"*)(.*)i(?:\"*)/"colwidth=\"".($1*2.54)."cm\""/eg;
    print;
}
