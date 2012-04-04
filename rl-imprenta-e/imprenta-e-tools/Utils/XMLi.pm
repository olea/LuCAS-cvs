# XMLi - imprenta-e XML
#
# Módulo Perl que lee los documentos XML de configuración de la 
# imprenta-e
#
# Author: Gaspar Oriol	gaspar.oriol@hispalinux.es
#
# This program is free software; you can redistribute it and/or 
# modify it under the terms of the GNU General Public License as 
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
# USA
#

package Utils::XMLi;

use Unicode::MapUTF8 qw(from_utf8);

require Exporter;
@ISA = (Exporter);


require XML::DOM;

@EXPORT = qw (getConf
				  getFormats
				  checkAOP
				  getDocFormatAOP
				  getStyleSheetAOP
				  getBaseNameAOP
				  getFileNameAOP
				  getImageOptionsAOP
				  getSamplesOptionsAOP
				  getServerConf
				  getDocVersionOMF
				  getDocDateOMF
				  getDocCreatorOMF
				  getDocCreatorEmailOMF
				  getDocTitleOMF
				  getDocDescriptionOMF
				  getDocTypeOMF);


#####################
#  imprenta-e.conf  #
#####################

# función que lee el archivo /etc/imprenta-e/imprenta-e.conf y devuelve un 
# array bidimensional con la información para obtener los módulos a procesar
#
# los valores del atributo "origen" especifican la forma de obtener la información
# siendo posibles valores como "cvs", "ftp", etc..
# NOTA: En este momento solo se contempla el uso del cvs
#
# Los valores del atributo destino es la dirección donde deben moverse los 
# formatos creados por el impresor-e.

sub XMLi::getConf {
	my $file = shift;
	my $doc;

	my $item;		# un nodo <modulo>
	my $formatos;	# elemento <formatos  >
	my $web;		# elemento <web  >
	my $i = 0;
	my $modulo;		# array bidimensional con la configuracion

	$doc = &loadFile ($file);
	
	if (!$doc->getElementsByTagName("modulo")) {
		print "Error al intentar cargar el elemento <modulo>\n";
		die "El archivo imprenta-e.conf no es correcto.\n";
	}
	foreach $item ($doc->getElementsByTagName("modulo")) {
		if (!$item->getAttribute ("origen")) {
			print "Error al intentar cargar el atributo \"origen\".\n";
			die "El archivo imprenta-e.conf no es correcto.\n";			
		}
		if ($item->getAttribute ("origen") eq "cvs") {
			$modulo->[$i][0] = "cvs";
			
			if (!$item->getElementsByTagName('cvsroot')) {
				print "Error al intentar cargar el elemento.<cvsroot>\n";
				die "El archivo imprenta-e.conf no es correcto.\n";			
			}			
			$modulo->[$i][1] = $item->getElementsByTagName('cvsroot')->item(0)->getFirstChild->getNodeValue;
			
			if (!$item->getElementsByTagName('nombre_modulo')) {
				print "Error al intentar cargar el elemento.<nombre_modulo>\n";
				die "El archivo imprenta-e.conf no es correcto.\n";			
			}			
			$modulo->[$i][2] = $item->getElementsByTagName('nombre_modulo')->item(0)->getFirstChild->getNodeValue;
			
			if (!$item->getElementsByTagName('aop')) {
				print "Error al intentar cargar el elemento.<aop>\n";
				print "del modulo $modulo->[$i][2]\n";
				die "El archivo imprenta-e.conf no es correcto.\n";			
			}			
			$modulo->[$i][3] = $item->getElementsByTagName('aop')->item(0)->getFirstChild->getNodeValue;
			
			if (!$item->getElementsByTagName('destino')) {
				print "Error al intentar cargar el elemento.<destino>\n";
				print "del modulo $modulo->[$i][2]\n";
				die "El archivo imprenta-e.conf no es correcto.\n";			
			}			
			$modulo->[$i][4] = $item->getElementsByTagName('destino')->item(0)->getFirstChild->getNodeValue;
			
			if (!$item->getElementsByTagName('formatos')) {
				print "Error al intentar cargar el elemento.<formatos>\n";
				print "del modulo $modulo->[$i][2]\n";
				die "El archivo imprenta-e.conf no es correcto.\n";			
			}			
			$formatos = $item->getElementsByTagName ('formatos');
			
			if (!$formatos->item(0)->getAttribute ('ps') or 
				!$formatos->item(0)->getAttribute ('pdf') or 
				!$formatos->item(0)->getAttribute ('htmltgz') or 
				!$formatos->item(0)->getAttribute ('html')) {
				print "Error al intentar cargar los atributos\n";
				print "del modulo $modulo->[$i][2]\n";
				die "El archivo imprenta-e.conf no es correcto.\n";			
			}			
			$modulo->[$i][5] = $formatos->item(0)->getAttribute ('ps');
			$modulo->[$i][6] = $formatos->item(0)->getAttribute ('pdf');
			$modulo->[$i][7] = $formatos->item(0)->getAttribute ('htmltgz');
			$modulo->[$i][8] = $formatos->item(0)->getAttribute ('html');
			
			if (!$item->getElementsByTagName('web')) {
				print "Error al intentar cargar el elemento.<web>\n";
				print "del modulo $modulo->[$i][2]\n";
				die "El archivo imprenta-e.conf no es correcto.\n";			
			}			
			$web = $item->getElementsByTagName ('web');
			
			if (!$web->item(0)->getAttribute ('id')) {
				print "Error al intentar cargar el atributo \"id\"\n";
				print "del modulo $modulo->[$i][2]\n";
				die "El archivo imprenta-e.conf no es correcto.\n";			
			}			
			$modulo->[$i][9] = $web->item(0)->getAttribute ('id');
			
			if (!$web->item(0)->getAttribute ('type')) {
				print "Error al intentar cargar el atributo \"type\"\n";
				print "del modulo $modulo->[$i][2]\n";
				die "El archivo imprenta-e.conf no es correcto.\n";			
			}
			
			$modulo->[$i][10] = $web->item(0)->getAttribute ('type');
			
			$i++;	
		}
	}
	return $modulo;
}

#########
#  AOP  #
#########

# NOTA: de momento los aop (Archivos de Opciones de Procesamiento)
# tienen el formato minimo para procesar los documentos
# en formato docbook de TLDP-ES

# Función que comprueba si el archivo aop es correcto
sub XMLi::checkAOP {
	my $file;
	my $doc;
	my $error;
	my $flag;
	my $i = 0;
	
	$file = shift;
	$doc = &loadFile ($file);
	
	print "Comprobando si el archivo $file es valido.\n";
	# comprueba la existencia de los elementos y atributos necesarios
	if (!$doc->getElementsByTagName('aop')) {
		$error->[$i] = "No existe el elemento raiz <aop>.\n";
		$flag = 1;
		$i++;
	}
	
	if (!$doc->getElementsByTagName('formato_fuente')) {
		$error->[$i] = "No existe el elemento <formato_fuente>.\n";
		$flag = 1;
		$i++;
	}
	
	if (!$doc->getElementsByTagName('formato_fuente')->item(0)->getAttribute('tipo')) {
		$error->[$i] = "No existe el atributo tipo de <formato_fuente>.\n";
		$flag = 1;
		$i++;
	}

	if 	(!$doc->getElementsByTagName('nombre_base')) {
		$error->[$i] = "No existe el elemento <nombre_base>.\n";
		$flag = 1;
		$i++;	
	}

	if 	(!$doc->getElementsByTagName('nombre_archivo')) {
		$error->[$i] = "No existe el elemento <nombre_archivo>.\n";
		$flag = 1;
		$i++;	
	}
	
	if 	(!$doc->getElementsByTagName('imagenes')) {
		$error->[$i] = "No existe el elemento <imagenes>.\n";
		$flag = 1;
		$i++;	
	}

	if (!$doc->getElementsByTagName('imagenes')->item(0)->getAttribute('contiene')) {
		$error->[$i] = "No existe el atributo imagenes de <imagenes>.\n";
		$flag = 1;
		$i++;
	}

	if (!$doc->getElementsByTagName('ejemplos')->item(0)->getAttribute('contiene')) {
		$error->[$i] = "No existe el atributo imagenes de <ejemplos>.\n";
		$flag = 1;
		$i++;
	}

	if ($error) {
		print "\nEl archivo $file no es correcto.\n";
		print "$error\n";
	}
	else {
		print "Archivo $file correcto.\n";
	}

	return $flag;	
}

# Función que obtiene el formato del documento (DocBook, Linux doc, tex)
sub XMLi::getDocFormatAOP {
	my $file = shift;
	my $doc;

	my $item;
	my $format;	

	$doc = &loadFile ($file);

	$item = $doc->getElementsByTagName('aop');
	$format = $doc->getElementsByTagName('formato_fuente')->item(0)->getAttribute('tipo');
	
	return $format;
}

# Función que obtiene la hoja de estilo a aplicar al documento
sub XMLi::getStyleSheetAOP {
	my $file = shift;
	my $doc;

	my $item;
	my $aux;
	my $style;	

	$doc = &loadFile ($file);

	$item = $doc->getElementsByTagName('aop');
	if ($doc->getElementsByTagName('formato_fuente')->item(0)->getAttribute('estilo')) {
		$aux = $doc->getElementsByTagName('formato_fuente')->item(0)->getAttribute('estilo');
		$style = "--stylesheet $aux";
	}
	
	return $style;
}
	
# Función que obtiene el nombre que recibirá el documento
sub XMLi::getBaseNameAOP {
	my $file = shift;
	my $doc;

	my $item;
	my $filename;	

	$doc = &loadFile ($file);

	$item = $doc->getElementsByTagName('aop');
	$filename = $doc->getElementsByTagName('nombre_base')->item(0)->getFirstChild->getNodeValue;
	
	return $filename;
}

# Función que obtiene el nombre del archivo a procesar
sub XMLi::getFileNameAOP {
	my $file = shift;
	my $doc;

	my $item;
	my $filename;	

	$doc = &loadFile ($file);
	
	$item = $doc->getElementsByTagName('aop');
	$filename = $doc->getElementsByTagName('nombre_archivo')->item(0)->getFirstChild->getNodeValue;
	
	return $filename;
}
	
# Función que obtiene las opciones de imagen
sub XMLi::getImageOptionsAOP {
	my $file = shift;
	my $doc;

	my $attr;
	my $images;	

	$doc = &loadFile ($file);
	
	if ($doc->getElementsByTagName ('imagenes')->item(0)->getAttribute ('contiene') eq "si") {
		if ($doc->getElementsByTagName ('imagenes')->item(0)->getAttribute ('nombre_directorio')) {
			$attr = $doc->getElementsByTagName ('imagenes')->item(0)->getAttribute ('nombre_directorio');
			
			if ($attr eq "no") {
				$images = "--images";
			} 
			else {
				$images = "--imagesdir $attr";
			}
		}	
	}
	
	return $images;
}

# Función que obtiene las opciones de ejemplos
sub XMLi::getSamplesOptionsAOP {
	my $file = shift;
	my $doc;

	my $attr;
	my $samples;	

	$doc = &loadFile ($file);
	
	if ($doc->getElementsByTagName ('ejemplos')->item(0)->getAttribute ('contiene') eq "si") {
		if ($doc->getElementsByTagName ('ejemplos')->item(0)->getAttribute ('nombre_directorio')) {
			$attr = $doc->getElementsByTagName ('ejemplos')->item(0)->getAttribute ('nombre_directorio');
		
			$samples = "--samplesdir $attr";
		}
	}
	
	return $samples;
}

#################
#  server.conf  #
#################

# Función que lee la configuración del servidor de /etc/imprenta-e/server.conf
# y la almacena en un hash que contiene un array de tres elementos

sub XMLi::getServerConf {
	my $file = shift;
	my $doc;
	my $aux;

	my $self;		# nodo del documento <item>
	my $items; 		# array bidimensional que contiene los datos del web 
	my $id;			# contiene el nombre del web permite relacionarlo con el id
					# de imprenta-e.conf
	my $i = 0;
	
	
	$doc = &loadFile ($file);
		
	foreach $self ($doc->getElementsByTagName("item")) {
		$items->[$i][0] = $self->getAttribute ("id");
		$items->[$i][1] = $self->getAttribute ("url_index_doc");
		$items->[$i][2] = $self->getAttribute ("url_doc");
		$items->[$i][3] = $self->getAttribute ("stylesheet");
		
		$aux = $self->getAttribute ("type");
		$items->[$i][4] = from_utf8 ({ -string => "$aux", -charset => 'ISO-8859-1' });
		
		$aux = $self->getAttribute ("title");
		$items->[$i][5] = from_utf8 ({ -string => "$aux", -charset => 'ISO-8859-1' });
		
		$aux = $self->getAttribute ("description");
		$items->[$i][6] = from_utf8 ({ -string => "$aux", -charset => 'ISO-8859-1' });
		$i++;
	}
	

	return $items;
}

###########
#   OMF   #
###########

# Función que obtiene la versión de un documento
sub XMLi::getDocVersionOMF {
	my $file = shift;
	my $doc;
	my $version;
	
	$doc = &loadFile ($file);
	
	if ($doc->getElementsByTagName ('version')->item(0)->getAttribute ('id')) {
		$version = $doc->getElementsByTagName ('version')->item(0)->getAttribute ('id');
	}
	else {
		die "Error al obtener la version del docuemnto $file.\n";
	}
	
	return $version;
}

# Función que obtiene la fecha del documento
sub XMLi::getDocDateOMF {
	my $file = shift;
	my $doc;
	my $date;
	
	$doc = &loadFile ($file);
	
	if ($doc->getElementsByTagName ('version')->item(0)->getAttribute ('date')) {
		$date = $doc->getElementsByTagName ('version')->item(0)->getAttribute ('date');
	}
	else {
		die "Error al obtener la fecha del docuemnto $file.\n";
	}
	
	return $date;
}

# Función que obtiene el autor del documento
# Por ser obligatorio no se comprueba su existencia, esta se
# realizará de forma general mediante otra fucnión
sub XMLi::getDocCreatorOMF {
	my $file;
	my $author;
	my $doc;
	my $firtsname;
	my $surname;
	
	$file = shift;
	
	$doc = &loadFile ($file);
	
	$firtsname = $doc->getElementsByTagName('firstName')->item(0)->getFirstChild->getNodeValue;
	$surname = $doc->getElementsByTagName('surname')->item(0)->getFirstChild->getNodeValue;
	
	$author = from_utf8 ({ -string => "$firtsname $surname", -charset => 'ISO-8859-1' });
	
	return $author;
}
	
# Función que retorna la dirección de correo-e del creador
sub XMLi::getDocCreatorEmailOMF {
	my $file;
	my $email;
	my $doc;
	
	$file = shift;
	
	$doc = &loadFile ($file);
	
	if ($doc->getElementsByTagName ('email')) {
		if ($doc->getElementsByTagName('email')->item(0)->getFirstChild) {
			$email = $doc->getElementsByTagName('email')->item(0)->getFirstChild->getNodeValue;
		}
	}
	
	return $email;
}

# Función que devuelve el título
sub XMLi::getDocTitleOMF {
	my $file;
	my $doc;
	my $title;
	my $aux;
	
	$file = shift;
	
	$doc = &loadFile ($file);
	
	if ($doc->getElementsByTagName ('title')) {
		$aux = $doc->getElementsByTagName('title')->item(0)->getFirstChild->getNodeValue;
		$title = from_utf8 ({ -string => "$aux", -charset => 'ISO-8859-1' });
	}
	
	return $title;
}

# Función que devuelve la descripción del documento
sub XMLi::getDocDescriptionOMF {
	my $file;
	my $doc;
	my $description;
	my $aux;
	
	$file = shift;
	
	$doc = &loadFile ($file);
	
	$aux = $doc->getElementsByTagName('description')->item(0)->getFirstChild->getNodeValue;
	$description = from_utf8 ({ -string => "$aux", -charset => 'ISO-8859-1' });
	
	return $description;
}

# Función que devuelve el tipo del documento (COMO, Manual, Desarrollo, etc..)
sub XMLi::getDocTypeOMF {
	my $file;
	my $doc;
	my $type;
	my $aux;
	
	$file = shift;
	
	$doc = &loadFile ($file);
	
	$aux = $doc->getElementsByTagName('type')->item(0)->getFirstChild->getNodeValue;
	$type = from_utf8 ({ -string => "$aux", -charset => 'ISO-8859-1' });
	return $type;
}


############
#   Misc   #
############

# Función que obtiene los formatos a crear (ps, pdf, html, htmltgz)
# y devuelve un array con los formatos a crear
sub XMLi::getFormats {

	my @formats = @_;	
	my @result;
	
	if ($formats[0] eq 'si') {
		push (@result, '--ps');
	}
	
	if ($formats[1] eq 'si') {
		push (@result, '--pdf');
	}
	
	if ($formats[2] eq 'si') {
		push (@result, '--htmltgz');
	}
	
	if ($formats[3] eq 'si') {
		push (@result, '--html');
	}
	
	return @result;
}


# Función privada que carga un archivo XML
sub loadFile {
	my $file = shift;
	my $parser = XML::DOM::Parser->new();
	my $doc;
	
	if ($parser->parsefile ($file)) {
		$doc = $parser->parsefile ($file);
	}
	else {
		die "El archivo $file no es un archivo valido.\n";
	}
	
	return $doc;	
}


1;
