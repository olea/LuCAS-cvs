#!/usr/bin/perl
#
#  genera_validador.pl - Script encargado de generar un documento
#                        en DocBook para poder validar las porciones
#                        del Proyecto Cursos
#
#  Acepta como parámetro la ruta al directorio desde donde
#  se quieren obtener las porciones a validar. Si no se
#  pasa ningún argumento al script, este obtedrá las porciones
#  del directorio por defecto (todo el repositorio)
#
#  NOTA: para la correcta ejecución de este script, es necesario
#        tener instalado el analizador gramatical de XML "xmllint".
#        Indicad en la definición de variables, la localización
#        de este programa en vuestro sistema.
#
#
#  Copyright (C) 2002 Proyecto Cursos <cursos-linux@listas.hispalinux.es>
#
#            http://es.tldp.org/htmls/cursos.html
#
#   Autores:
#
#      Sergio González González <sergio.gonzalez@hispalinux.es>
#
#   Modificaciones:
#
#      Lucas Di Pentima <ldipenti@ciudad.com.ar>
#
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2, or (at your option)
#   any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software Foundation,
#   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#


# -------------------------------
# Definición de algunas variables
#

# Archivo donde se almacenará el documento a validar
my $documento_a_validar = "documento.xml";

# Directorio donde se encuentran las porciones
my $directorio_porciones = "../../contenido/";

# Localización del validador
my $validador = "xmllint";
my $archivo_validador = `which $validador`;
chomp $archivo_validador;

# Variables para el procesado de referencias <xref />
my %xrefs_existentes;
my %ids_existentes;
my %ids_a_completar;

# _______________________________
# Definición de algunas funciones
#


sub cargar_xrefs {

    ##
    # Función que va cargando en listas asociativas las referencias
    # y sus entidades referenciadas.
    #

    my $porcion = shift;

    open(PORCION, "$porcion") or die "open: $!: $porcion";

    while($linea = <PORCION>) {
	my $xref = $linea;
	my $id = $linea;

	if($xref =~ s/.*linkend\=\"(.*?)\"(.*)/$1/) {
	    chomp($xref);
	    $xrefs_existentes{"$xref"} = 1;
	}
	if($id =~ s/.*id\=\"(.*?)\"(.*)/$1/) {
	    chomp($id);
	    $ids_existentes{"$id"} = 1;
	}
    }
    close(PORCION);
}

sub cotejar_xrefs {

    ##
    # Usando las listas generadas por cargar_xrefs(), se genera otra
    # lista asociativa con las referencias incompletas
    #

    my $xref;

    foreach $xref (keys %xrefs_existentes) {
	if(not($ids_existentes{"$xref"})) {
	    print STDERR "CUIDADO: referencia \'$xref\' incompleta!\n";
	    $ids_a_completar{"$xref"} = 1;
	}
    }

}

sub trim {

	##
	# Función que elimina los espacios en blanco (al inicio
	# y al final) del argumento
	#

	s/^\s+//; # Elimina los espacios en blanco existentes al principio
	s/\s+$//; # Elimina los espacios en blanco existentes al final

	return @_;
}



# -------------------
# Comienzo del script
#

print "\nGenerando el documento a validar...";


#
# Obtenemos las porciones del Proyecto Cursos (si no se ha pasado como
# argumento el directorio desde donde se obtendrán las porciones,
# se cogerá el directorio por defecto -> $directorio_porciones)
#

if (length($ARGV[0]) == 0) {
	 
	# Comprobamos que el directorio es accesible
	opendir (DIRECTORIO_PORCIONES, $directorio_porciones) || 
		die ("No se puede abrir el directorio $directorio_porciones: $!\n\n");
	closedir DIRECTORIO_PORCIONES;

	# Obtenemos las porciones del directorio por defecto
	@conjunto_de_porciones = `find $directorio_porciones -name "*.xml.porcion" 2>errores.log`;

	# Comprobamos la salida de find. Si ha tenido algún error, lo notificamos y 
	# salimos del script
	if (($? >> 8) > 0) {
		print "\n\n ERROR al ejecutar `find \$directorio_porciones -name \"*.xml.porcion\"` (compruebe el archivo errores.log)\n\n";
		exit -1;
	} else {
			if (-e "errores.log") { `rm -rf errores.log`; }
		}

} else {

		# Comprobamos que el directorio es accesible
		opendir (DIRECTORIO_PORCIONES, $ARGV[0]) || 
			die ("No se puede abrir el directorio $ARGV[0]: $!\n\n");
		closedir DIRECTORIO_PORCIONES;

		# Obtenemos las porciones del directorio pasado como argumento
		@conjunto_de_porciones = `find $ARGV[0] -name "*.xml.porcion" 2>errores.log`;
	 
		# Comprobamos la salida de find. Si ha tenido algún error, lo notificamos y 
		# salimos del script
		if (($? >> 8) > 0) {
			print "\n\n ERROR al ejecutar `find \$ARGV[0] -name \"*.xml.porcion\" 2>errores.log` (compruebe el archivo errores.log)\n\n";
			exit -1;
		} else {
				if (-e "errores.log") { `rm -rf errores.log`; }
			}
	} #else


#
# Comprobamos si hay porciones en el directorio dado. Si no las hay,
# finalizamos el script
#

if (length($conjunto_de_porciones[0]) == 0) {
	print "\n\n    ** No hay porciones para analizar **\n\n";
	exit -1;
}


#
# Creamos, si no existe, el archivo $documento_a_validar (si existe lo
# abrimos y sobreescribimos su contenido)
#

open(DOCUMENTO_A_VALIDAR, ">$documento_a_validar") ||
	die("Imposible abrir el archivo $documento_a_validar: $!");


print DOCUMENTO_A_VALIDAR "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>
<!DOCTYPE article PUBLIC \"-//OASIS//DTD DocBook XML V4.1.2//EN\"
       \"file:///usr/share/sgml/docbook/dtd/xml/4.1.2/docbookx.dtd\" [\n";


#
# Definimos las entidades asociadas a las porciones
#

my $contador_porciones = 1; # Variable encargada de generar los nombres de las entidades

foreach $porcion (@conjunto_de_porciones) {
	chomp $porcion;

#	print DOCUMENTO_A_VALIDAR "\<\!ENTITY porcion$contador_porciones.xml SYSTEM \"$porcion\"\>\n";

	# Llevamos cuenta de las referencias
	&cargar_xrefs($porcion);

	$contador_porciones++;
} #foreach

&cotejar_xrefs();

print DOCUMENTO_A_VALIDAR "]>

<article lang=\"es\" id=\"index\">

	<articleinfo>
		<title>Ejemplo para validar</title>

		<author>
			<firstname>Proyecto</firstname>
			<surname>Cursos</surname>
		</author>

		<abstract>
			<para>
				Este es un ejemplo para comprobar si las porciones están
				correctamente formadas
			</para>
		</abstract>

	</articleinfo>

	<!-- Fin sección cabecera -->\n";


#
# Generamos los párrafos tontos con referencias incompletas
#
print DOCUMENTO_A_VALIDAR "
<section><title>Sección «tonta»</title>
    <para>
        Las siguientes son referencias incompletas que deben ser resueltas
        de algún modo. A efectos que el validador funcione, se han generado
        los ids necesarios.
    </para>
";
foreach $id (keys %ids_a_completar) {
    print DOCUMENTO_A_VALIDAR "
    <para id=\"$id\" xreflabel=\"[¡XREF \'$id\' INCOMPLETO!]\">
      XREF \'$id\' no corresponde a ninguna porción incluida.
    </para>\n";
}
print DOCUMENTO_A_VALIDAR "
</section>
";

#
# Generamos las secciones donde se incluirán las entidades anteriormente generadas
#

foreach $porcion (@conjunto_de_porciones) {
	chomp $porcion;

	print DOCUMENTO_A_VALIDAR "
<section>
    <xi:include xmlns:xi=\"http://www.w3.org/2001/XInclude\"
      href=\"$porcion\#xpointer(/section/*)\">
      <xi:fallback>
	<para><emphasis>ADVERTENCIA: Porción <filename>$porcion</filename> no pudo incluirse</emphasis></para>
      </xi:fallback>
    </xi:include>
</section>
  <!-- Fin sección -->
";
} #foreach


#my $contador_entidades = 1; # Variable encargada de generar los nombres de las entidades y los "id"
#
#while ($contador_entidades != $contador_porciones) {
#	print DOCUMENTO_A_VALIDAR "
#<section>
#    &porcion$contador_entidades.xml;
#</section>
#  <!-- Fin sección -->
#";
#	$contador_entidades++;
#
#} #while


print DOCUMENTO_A_VALIDAR "\n</article>";

close DOCUMENTO_A_VALIDAR;

sleep 1;
print " [Hecho]\n";
sleep 1;

#
# Analizamos el documento generado a partir de las porciones (si está presente
# el programa validador en el sistema), para ver si contiene errores.
#

if (-e $archivo_validador) { 

	`$archivo_validador --valid --xinclude --insert $documento_a_validar >/dev/null 2>$validador.log`;

	if (($? >> 8) == 0) {

		# Porciones sin errores
		print "\n      ** Enhorabuena **: las porciones no poseen errores\n\n";
	
		# Eliminamos el archivo rxp.log
		if (-e "$archivo_validador.log") { `rm -rf $validador.log`; }

	} else  {	 
			# Alguna porción está mal formada o posee errores
			print "\n       ** Aviso **: revisa el archivo $validador.log, las porciones contienen errores\n\n";
		}

} else {
		print "\n   ** $validador no está presente en su sistema, no se realiza la validación. **\n\n";
	}

#
# Finalizamos la ejecución del script e informamos de los resultados
#

print "(El documento generado se ha guardado en \"$documento_a_validar\")\n\n";
