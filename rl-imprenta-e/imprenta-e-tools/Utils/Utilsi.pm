# Utilsi - imprenta-e Utils
#
# Módulo Perl de funciones de la imprenta-e
# 
# Funciones de utilidades para:
#		- cvs
#		- ftp y http
#		- comprobar la existencia de las hojas de estilo
#		- manejar archivos zip, tar, etc..
#     - etc ...
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

package Utils::Utilsi;

require Exporter;
@ISA = (Exporter);

@EXPORT = qw (DownloadModuleCVS
				makeDistCVS
				printTotalTime
				makeIndexDoc);

use File::stat qw(:FIELDS);


################################
#        Funciones CVS         #
################################

# Función que descarga el módulo pasado como parámetro
# 
# Esta función recibe como parámetros el CVSROOT y el módulo 
# a descargar
sub Utilsi::DownloadModuleCVS {
	my $cvsroot;
	my $module;
	
	($cvsroot, $module) = @_;
	
	print "\nDescargando el modulo $module.\n";
	
	system ("cvs -d $cvsroot checkout $module");

}

############
#	Misc   #
############
# Función que empaqueta los fuentes para su distribución 
sub Utilsi::makeDistCVS {
	my $module = shift;


	system ("tar cfz $module\.src\.tar\.gz $module");
	
	if (!-f "$module.src.tar.gz") {
		die "Error al crear el paquete con los fuentes del documento.\n";
	}
	else {
		system ("mv $module.src.tar.gz $module");
	}
}

# Fucnión que imprime por pantalla el tiempo total empleado por la imprenta-e
sub Utilsi::printTotalTime {
	my $time;
	my $aux;
	my $end;
	my $h = 0;
	my $m = 0;
	my $s = 0;
	
	$time = shift;
	
	$end = time;
		
	$aux = $end - $time;
	
	if ($aux > 3600) {
		$h = $aux / 3600;
		$aux = $aux % 3600;
	}
	
	if ($aux > 60) {
		$m = $aux / 60;
		if ($m =~ /\./) {
			$m = $`;
		}
		$s = $aux % 60;
	}
	
	if ($aux < 60) {
		$s = $aux;
	}
	
	
	print "\nEl tiempo total de ejecución de la imprenta-e ha sido:\n";
	print "$h:$m:$s\n";
}

# Función que crea el archivo index.xml
# recibe como parámetros el OMF, el nombre de la hoja de estilo y el nombre
# del módulo que procesa además del array @param que contiene los formatos y
# el destino del documento ademas del directorio de la DTD
sub Utilsi::makeIndexDoc {
	my $basename;
	my $omf;
	my $stylesheet;
	my @param;
	my $dest;
	my $DTD_dir;
	
	# variables para contener los datos del OMF
	my $author;
	my $email;
	my $title;
	my $description;
	my $date;
	my $version;
	my $formats;
	my $type;
	my $dist;
	
	my $aux;
	my $ps = "no";
	my $pdf = "no";
	my $html = "no";
	my $htmltgz = "no";
	
	# variables para los tamaños de los archivos
	my $sizeps = 0;
	my $sizepdf = 0;
	my $sizetargz = 0;
	my $sizesrc = 0;
	my $sizes;
	
	# cabecera del documento
	my $head;
	
	($omf, $stylesheet, $DTD_dir, $basename, $dist, $dest, @param) = @_;

	# si falta la / al final de $dest la añade
	if ($dest !~ /\/$/) {
	$dest = "$dest/";
	}

	$head = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>
			<!DOCTYPE index_doc SYSTEM \"$DTD_dir/index-doc.dtd\">
			<?xml-stylesheet type=\"text/xsl\" href=\"$stylesheet\"?>";

	$author = XMLi::getDocCreatorOMF ("$omf");
	$email = XMLi::getDocCreatorEmailOMF ("$omf");
	if (!$email) {
		$email = " ";
	}
	$title = XMLi::getDocTitleOMF ("$omf");
	$date = XMLi::getDocDateOMF ("$omf");
	$version = XMLi::getDocVersionOMF ("$omf");
	$description = XMLi::getDocDescriptionOMF ("$omf");
	$type = XMLi::getDocTypeOMF ("$omf");
	
	# obtiene los formatos del array @param
	foreach $aux (@param) {
		if ($aux eq "--ps") {
			$ps = "si";
			if (-e "$basename\.ps" ) {
				$sizeps = &file_size ("$basename\.ps");
			}
		}
		if ($aux eq "--pdf") {
			$pdf = "si";
			if (-e "$basename\.pdf" ) {
				$sizepdf = &file_size ("$basename\.pdf");
			}
		}
		if ($aux eq "--htmltgz") {
			$htmltgz = "si";
			if (-e "$basename-html\.tar\.gz" ) {
				$sizetargz = &file_size ("$basename-html\.tar\.gz");
			}
		}
		if ($aux eq "--html") {
			$html = "si";
		}
	}
	
	if (-e "$dist\.src\.tar\.gz") {
		$sizesrc = &file_size ("$dist\.src\.tar\.gz");
	}
	
	$sizes = "<tamaño ps=\"$sizeps\" pdf=\"$sizepdf\" htmltgz=\"$sizetargz\" source=\"$sizesrc\"/>";
	
	$formats = "<formatos ps=\"$ps\" pdf=\"$pdf\" htmltgz=\"$htmltgz\" html=\"$html\" source=\"si\"/>";
	
	# crea el archivo index.xml
	open (INDEX, ">". "index.xml") or die "No es posible crear el archivo index.xml\n";

	print INDEX	"$head\n";
	print INDEX "<index_doc>\n";
	print INDEX "\t<title>$title<\/title>\n";	
	print INDEX "\t<author>$author<\/author>\n";
	print INDEX "\t<email>$email<\/email>\n";
	print INDEX "\t<date>$date<\/date>\n";
	print INDEX "\t<version>$version<\/version>\n";
	print INDEX "\t<description>$description<\/description>\n";
	print INDEX "\t<type>$type</type>\n";
	print INDEX "\t<destino>$dest</destino>\n";
	print INDEX "\t<doc_name>$basename</doc_name>\n";
	print INDEX "\t<dist_name>$dist</dist_name>\n";
	print INDEX "\t$formats\n";
	print INDEX "\t$sizes\n";
	print INDEX "<\/index_doc>\n";
	
	close (INDEX);
	
}

# función que devuelve el tamaño de un archivo
sub file_size {
	my $file = shift;
	my $size;
	
	stat ("$file");
	
	$size = $st_size / 1024; 
	
	if ($size =~ /\./) {
		$size = $`;	
	}
	
	return $size;
}
1;
