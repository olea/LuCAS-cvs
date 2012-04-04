#!/usr/bin/perl
#
#   generador_configuracion.pl - Script que genera la organización
#                                preliminar de un curso
#
#   Copyright (C) 2002 Proyecto Cursos <cursos-linux@listas.hispalinux.es>
#
#            http://es.tldp.org/htmls/cursos.html
#
#   Autores:
#
#      Sergio González González <sergio.gonzalez@hispalinux.es> 
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

# Archivo donde se almacenará la organización preliminar del curso
my $cursos_config = "cursos_config.php";

# Directorio donde se encuentran las porciones
my $directorio_porciones = "../../contenido/";


# _______________________________
# Definición de algunas funciones
#


sub trim {

	##
	# Función que elimina los espacios en blanco (al inicio
	# y al final) del argumento
	#
	
	s/^\s+//; # Elimina los espacios en blanco existentes al principio
	s/\s+$//; # Elimina los espacios en blanco existentes al final

	return @_;
}


sub obten_titulo_porcion {

	##
	#	Función que obtiene el título de la porción pasada como argumento
	#
	
	open(PORCION, $_[0]) || die("Imposible abrir el archivo $_[0]: $!");

	while (<PORCION>) {
		&trim($_);
		next if ((/^\<\?xml/) || (length($_) == 0)); 
		if (/^\<title\>/) {
			s/<title>//;
			s/<\/title>//;
			chomp $_;
			@_ = $_;
			last
		}
	} # while
	
	close PORCION;
	return $_[0];
}



# -------------------
# Comienzo del script
#
 
print "\nGenerando la estructura del curso...";


#
# Comprobamos que el directorio es accesible
#

opendir (DIRECTORIO_PORCIONES, $directorio_porciones) || 
	die ("No se puede abrir el directorio $directorio_porciones: $!\n\n");
closedir DIRECTORIO_PORCIONES;


# Obtenemos la estructura del Proyecto Cursos (esta se encuentra dispersa
# en los archivos "Estructura-nombre_capitulo" del repositorio) 
#

my @estructura_curso = `find $directorio_porciones -name "Estructura-*" 2>errores.log`;

# Comprobamos la salida de find. Si ha tenido algún error, lo notificamos y
# salimos del script
if (($? >> 8) > 0) {
	print "\n\n ERROR al ejecutar `find \$directorio_porciones -name \"Estructura-*\"` (compruebe el archivo errores.log)\n\n";
	exit -1;
}
else {
	if (-e "errores.log") { `rm -rf errores.log`; }
}


#
# Comprobamos si hay archivos 'Estructura-TituloCapitulo' en el
# directorio dado. Si no los hay, finalizamos el script
#

if (length($estructura_curso[0]) == 0) {
	print "\n\n    ** No hay archivos 'Estructura-*' para analizar **\n\n";
	exit -1;
}
    

#
# Creamos, si no existe, el archivo $cursos_config (si existe lo abrimos
# y sobreescribimos su contenido)
# 

open(CURSOS_CONFIG, ">$cursos_config") || 
	die("Imposible abrir el archivo $cursos_config: $!");


print CURSOS_CONFIG "<?php\n\n\$cursos_dirs=array(\n";


#
# Definimos los capítulos que conforman el Proyecto Cursos
#

# Array donde se irán colocando los capítulos según el orden establecido
my @capitulos_ordenados;

# Array donde se irán almacenando los Avisos generados, para mostralos al
# final de la ejecución
my @avisos;

# Variable que mantiene la cuenta de los Avisos generados
my $contador_avisos = 0;

# Array donde se almacenarán los capítulos con errores en su definición
my @capitulos_con_errores;


foreach $capitulo (@estructura_curso) {

	chomp $capitulo;

	open(CAPITULO, $capitulo) || die("Imposible abrir el archivo $capitulo: $!");

		# Variables auxiliares que indicarán si ya se ha
		# obtenido toda la información nedesaria de un determinado
		# capítulo (cuando todas estén a 1)

		my $cap = 0;
		my $ord = 0;
		my $icl = 0;

		# Obtenemos la información necesaria del capítulo

		while (<CAPITULO>) {
			&trim ($_);
			last if ($cap && $ord && $icl);
			next if ((/^#/) || (length($_) == 0));

			my @estructura = split ("=",$_);

			# Título del capítulo
			if (($estructura[0] eq TituloCapitulo) && (!$cap)) {
				$titulo_capitulo = "$estructura[1]";
				chomp $titulo_capitulo;
				$cap = 1;
			}
			# Orden del capítulo dentro del curso
			elsif (($estructura[0] eq OrdenCapitulo) && (!$ord)) {
				$orden_capitulo = "$estructura[1]";
				chomp $orden_capitulo;
				$ord = 1;
			}
			# ¿Incluímos este capítulo por defecto en el curso?
			elsif (($estructura[0] eq IncluirCapitulo) && (!$icl)) {
				$incluir_capitulo = "$estructura[1]";
				chomp $incluir_capitulo;
				$icl = 1;
			}
			elsif ($cap && $ord && $icl) {
				last;
			}
			# else {
			#         ** La línea es incorrecta (implementarlo si se
			#            considera necesario) **
			# }
		}

	close CAPITULO;

	#
	# Obtenemos la ruta hacia el capítulo
	#
	
	my @ruta_en_trozos = split("-",$capitulo);
	$ruta_en_trozos[0] =~ s/\/Estructura//;
	

	#
	# Comprobamos que la estructura del capítulo está bien formada.
	# Si no es así, generamos un nuevo aviso.
	#

	if (!$cap || !$ord || !$icl) {

		$avisos[$contador_avisos] = 
			"Aviso$contador_avisos: El archivo '$capitulo' no está bien formado, no se tendrá en cuenta.\n";
		$capitulos_con_errores[$contador_avisos] = $ruta_en_trozos[1];
		$contador_avisos++;
		next;

	}
	else {

		# Guardamos la información relativa al capítulo
		$capitulos_ordenados[$orden_capitulo - 1] =
			"array(\"$ruta_en_trozos[0]\",\"$titulo_capitulo\",\"$orden_capitulo\",$incluir_capitulo),\n";

	} #else
} #foreach


#
# Escribimos la información relativa a los capítulos
# en el archivo de configuración del curso
#

print CURSOS_CONFIG @capitulos_ordenados;

print CURSOS_CONFIG ");\n\n\$cursos_array=array(\n";


#
# Definimos la organización de los distintos capítulos del Proyecto Cursos
#

# Array donde se irán almacenando las secciones ordenadas de cada capítulo
my @secciones_ordenadas;

# Variable necesaria para ir ordenando las secciones dentro del array anterior
my $contador = 0;
 
foreach $secciones (@estructura_curso) {

	chomp $secciones;

	# Obtenemos la ruta a las porciones
  my @ruta_en_trozos = split("-",$secciones);
  $ruta_en_trozos[0] =~ s/\/Estructura//;

	# Comprobamos si el capítulo ha tenido algún error. En caso afirmativo,
	# se pasa al siguiente capítulo
	
	my $error_capitulo = 0; # Si está a 1, el capítulo ha tenido errores

	if (length($capitulos_con_errores[0]) != 0) {

		foreach $capitulo (@capitulos_con_errores) {
			if ($capitulo eq $ruta_en_trozos[1]) {
				# El capítulo ha tenido algún error, no lo tenemos en cuenta
				$error_capitulo = 1;
			}
		} #foreach
	} #if

	#pasamos al siguiente capítulo, si este ha tenido algún error
	next if $error_capitulo;

	open(SECCIONES, $secciones) || 
		die("Imposible abrir el archivo $secciones: $!");

	# Obtenemos la estructura de los capítulos del curso, recorriendo
	# el archivo "Estructura-nombre_capitulo"
	while (<SECCIONES>) {

		&trim($_);
		next if ((/^#/) || (length($_) == 0) || (/^TituloCapitulo/) ||
			(/^OrdenCapitulo/) || (/^IncluirCapitulo/));

		if (/^Porcion/) {

			# Obtenemos el nombre de la porción a tratar
			@nombre_porcion = split("=",$_);

			# calculamos la ruta que lleva a la porción
			$ruta_a_porcion = "$ruta_en_trozos[0]\/$nombre_porcion[1].xml.porcion";

			# Obtenemos el título de la porción
			$titulo_porcion = &obten_titulo_porcion($ruta_a_porcion);

			next;

		}		
		elsif (/^IncluirComo/) {

			# Obtenemos la función de la porción (sección, subsección,
			# subsubsección, etc.)
			@funcion_porcion = split("=",$_);
			
			# Guardamos el resultado
			$secciones_ordenadas[$contador] =
				"array(\"$ruta_a_porcion\",\"$titulo_porcion\",\"$funcion_porcion[1]\"),\n";			
			$contador++;
			next;

		}
		elsif (/^Seccion/) {

			# Obtenemos el título de la sección
			my @titulo_seccion = split("=",$_);

			# Guardamos el resultado
			$secciones_ordenadas[$contador] =
				"array(\"$ruta_en_trozos[0]\",\"$titulo_seccion[1]\",\"1\"),\n";			
			$contador++;
			next;

		}
		elsif (/^Subseccion/) {
			
			# Obtenemos el título de la subsección
			my @titulo_subseccion = split("=",$_);

			# Guardamos el resultado
			$secciones_ordenadas[$contador] =
				"array(\"$ruta_en_trozos[0]\",\"$titulo_subseccion[1]\",\"2\"),\n";
			
			$contador++;
			next;

		}
		elsif (/^Subsubseccion/) {

			# Obtenemos el título de la subsección
			my @titulo_subsubseccion = split("=",$_);

			# Guardamos el resultado
			$secciones_ordenadas[$contador] =
				"array(\"$ruta_en_trozos[0]\",\"$titulo_subsubseccion[1]\",\"3\"),\n";

			$contador++;
			next;

		}

	} # while
		
		close SECCIONES;

} #foreach


print CURSOS_CONFIG @secciones_ordenadas;

print CURSOS_CONFIG "\n);\n\n?>";


#
# Finalizamos la ejecución del script
#

close CURSOS_CONFIG;

sleep 1;
print " [Hecho]\n";
sleep 1;
print "(Configuración almacenada en \"$cursos_config\")\n\n";


#
# Mostramos los avisos generados, si los hay
#

if (length($avisos[0]) > 0) {
	print " @avisos\n";
}
