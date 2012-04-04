# DocBookXML.pm
#
# Módulo Perl que implementa la clase DocBook en su
# versión XML así como los métodos necesarios para 
# procesar este tipo de documento
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

package Printer::DocBookXML;

use strict;

use File::Spec;

##################
#   Constructor  #
##################
sub new {
	my ($class, $filePath) = @_;
	my $self = {};
	my ($volume,$dir,$fileName) = File::Spec->splitpath($filePath);
	my $name; # contiene el nombre del archivo sin la extensión
	my $ext; # contiene la extensión
		
	bless $self, $class;
	
	# la variable local $name se utiliza para crear el directorio que 
	# contendrá el html	
		
	# obtiene la extensión del archivo a procesar
	if ($fileName =~/\./) {
		$ext = $';
		while ($ext =~/\./) {
			$ext = $';
		}
	}
		
	$fileName =~ /\.$ext/;
	$name = $`;
	
	$self->{fileName} = $fileName;
	$self->{name} = $name;
	
	return $self;
}

##############
#   Métodos  #
##############
# Comprueba que el archivo que le pasamos esta en formato DocBook
# buscando la dtd del documento
sub validate {
	my $self = shift;
	my $valid = 1;
	
	print ("\nValidating ".$self->{fileName}."\n");

	if (! -f $self->{fileName}) {
		die "No puedo abrir el archivo\n"
	}	

	open (FILE, $self->{fileName});
	
	while (<FILE>) {
		if ($_ =~ /(DocBook XML)/i) {
			close FILE;
			return 0;
		}
		if ($_ =~ /(DocBook)/i){
			close FILE;
			return $valid;			
		}
	}
	
	return $valid;
}

# Convierte a formato ps
sub convertToPS {
	my ($self, $options) = @_;
	
	system ("docbook2ps -e no-valid $options $self->{fileName}");
}

# Convierte a formato pdf
sub convertToPDF {
	my ($self, $options) = @_;
	
	system ("docbook2pdf -e no-valid $options $self->{fileName}");
}

# Convierte a formato html
sub convertToHTML {
	my ($self, $options) = @_;
	my $filename; 	# contiene el nobre del modulo
	my $directorio;	# variable para crear la estructura de los módulos
	
	$filename = $self->{name};
	
	if (-e "$self->{name}") {
		print "\nEliminando copias anteriores.\n";
		system ("rm -rf $self->{name}");
	} 

	# se crea la estructura de directorios.
	opendir (DIR, ".");
	while ($directorio = readdir(DIR)) {
		if (-d $directorio) {
			system ("mkdir -p $self->{name}/$directorio");
		}
	}
	closedir(DIR);

	# se generan los HTML
	
	system ("docbook2html  -e no-valid -o $self->{name} $options $self->{fileName}");	
	
	chdir ($self->{name});

	# se eliminan los directorios vacios
	system ("rmdir `find . -empty`");
	
	if (-e "book1.html") {
    	&makeIndex ("book1.html");
	}
	
	if (-e "t1.html") {
    	&makeIndex ("t1.html");
	}
	
	if (-e "$filename.html") {
    	&makeIndex ("$filename.html");
	}
 	
	lc ($filename); #convierte la cadena a minusculas
    &makeIndex ("$filename\.html");

	chdir ("..");

}

# Elimina los formatos intermedios log, dvi, etc...
sub deleteIntFormats {
	my $self = shift;
	
	if (-f "$self->{name}.log") {
		system ("rm *.log");
	}
	if (-f "$self->{name}.dvi") {
		system ("rm *.dvi");
	}
	if (-f "$self->{name}.aux") {
		system ("rm *.aux");
	}
	if (-f "$self->{name}.tex") {
		system ("rm *.tex");
	}
	if (-f "$self->{name}.out") {
		system ("rm *.out");
	}		
}

# copia las imágenes sueltas al directorio del html
sub importImagesToHtml {
	my $self = shift;
		
	print "\nImportando imagenes png a $self->{name}\n";
	system ("cp *.png $self->{name}");

	print "\nImportando imagenes jpg a $self->{name}\n";
	system ("cp *.jpg $self->{name}");

	print "\nImportando imagenes gif a $self->{name}\n";
	system ("cp *.gif $self->{name}");
}

# copia el directorio de las imágenes al directorio del html
sub importImagesDirToHtml {
	my ($self, $dir) = @_;
	
	print "\nImportando el directorio $dir a $self->{name}\n";
	system ("cp -r $dir $self->{name}");
}

# crea un paquete tar.gz
sub makeHtmlDist {
	my $self = shift;
	
	system ("tar cfz $self->{name}-html.tar.gz $self->{name}");
}

# rutina que crea un enlace simbolico al archivo index.html
sub makeIndex {
	my $self = shift;
	
    if (-e $self and !-e "index.html") {
		system ("cp $self index.html"); #WebDAV no soporta enlaces simbólicos
	}			
}

1;

__END__

=head1 NAME

Printer::DocBook - Management of DocBook SGML files

=head1 SYNOPSIS

	use Printer::DocBook;

	my $doc = DocBook->new ("file.sgml");

	if ($doc->validate eq 0) {
		$doc->convertToPS;
		$doc->convertToPDF;
		$doc->deleteIntFormats;
		$doc->convertToHTML;
		
		if ($images) {
			$doc->importImagesToHtml;
		}
		if ($imagesdir) {
			$doc->importImagesDirToHtml ("img");
		}	
	}
	else {
		die "The file format is not valid\n";
	}

=head1 DESCRIPTION


=head1 AUTHOR

	Gaspar Oriol 	gaspar.oriol@hispalinux.es
	
=cut
