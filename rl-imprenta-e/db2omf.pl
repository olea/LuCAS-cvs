#!/usr/bin/perl -w

# db2omf.pl
# script que crea el archivo OMF a partir de las fuentes docbook
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

use strict;


my $content = {};
my $db_file;
my $omf_file;
my @param = @ARGV;

	
$db_file = $param[0];
	
if ($param[1]) {
	$omf_file =	$param[1];
}
	
$content = &readFile ($db_file);

&makeOMF ($content);

exit 0;	

# Función que lee los datos del archivo docbook
# devuelve un hash con los datos necesarios

sub readFile {

	my $filename = shift;
	
	my $self = {};
	
	my @file;
	
	my $i = 0;

	my $name;
	my $surname;

	print "Obteniendo los datos del archivo $filename.\n";
		
	$self->{filename} = $filename;	
	
	open (FILE, $filename) or die "No es posible abrir el archivo\n";
	
	@file = <FILE>;

	close (FILE);

	while (($file[$i] !~ /<\/bookinfo>/) and 
			($file[$i] !~ /<\/articleinfo>/) and
			($file[$i] !~ /<\/artheader>/))	{
				
		if ($file[$i] =~ /<title>/)  {
			$self->{title} = $file[$i];
		}

		if ($file[$i] =~ /<firstname>/)  {
			$name = $file[$i];
			$name = &extraer ($name);
			$self->{name} = $name;
			$i++;
		}
		
		if ($file[$i] =~ /<surname>/)  {
			$surname = $file[$i];
			$surname = &extraer ($surname);
			$self->{surname} = $surname;
		}
		
		
		if ($file[$i] =~ /<email>/)  {
			$self->{email} = $file[$i];
			$self->{email} = &extraer ($self->{email});
		}


		if ($file[$i] =~ /<date>/)  {
			$self->{date} = $file[$i];
		}
		
		if ($file[$i] =~ /<abstract>/)  {
			$self->{description} = $file[$i];
			$self->{description} =~ s/^[^>]*>\n?//;
			$i++;
			while ($file[$i] !~ /<\/abstract>/) {
				$self->{description} = "$self->{description} $file[$i]";
				$i++;
			}
			$self->{description} = &extraer ($self->{description});
			
			if (!$self->{description}) {
				$self->{description} = " ";
			}				
		}
		
		$i++;
	}

	if (!$self->{email}) {
		$self->{email} = "<email><\/email>";
	}
	
	if (!$self->{date}) {
		$self->{date} = $file[$i];
	}

	
	if (!$self->{description}) {
		$self->{description} = " ";
	}				
	
	return $self;	
}

# Función que crea el omf
sub makeOMF {
	my $self = shift;
	
	my $ext; # contiene la extensión
	my $name; # nombre del archivo sin la extensión
	
	my $a = 0;
	
	# obtiene la extensión del archivo a procesar
	if ($self->{filename} =~/\./) {
		$ext = $';
		while ($ext =~/\./) {
			$ext = $';
		}
	}
	
	$self->{filename} =~ /\.$ext/;
	
	if ($omf_file) {
		$name = $omf_file;
	}
	else {	
		$name = $`;
	}

	print "\nCreando el archivo $name\.omf\n";	
	
	open (OMF, ">". "$name\.omf") or die "No es posible crear el archivo\n";
	
	print OMF "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n";
	print OMF "<omf>\n";
	print OMF "\t<resource>\n";
	print OMF "\t\t<creator>\n";
	print OMF "\t\t\t<person>\n";
	print OMF "\t\t\t\t<firstName>$self->{name}<\/firstName>\n";
	print OMF "\t\t\t\t<surname>$self->{surname}<\/surname>\n";
	print OMF "\t\t\t\t$self->{email}\n";
	print OMF "\t\t\t<\/person>\n";
	print OMF "\t\t<\/creator>\n";
	print OMF "\t$self->{title}";	
	print OMF "\t$self->{date}";
	print OMF "\t\t<version id=\"1.0\" date=\" \"\/>\n";
	print OMF "\t\t<description>\n";
	print OMF "\t\t\t$self->{description}\n";
	print OMF "\t\t<\/description>\n";
	print OMF "\t\t<type><\/type>\n";
	print OMF "\t<\/resource>\n";
	print OMF "<\/omf>\n";
	
	close (OMF);	
}

# Utilidad que extrae el contenido de un nodo
sub extraer {
	
	my $aux = shift;
	
	$aux =~ s/^[^>]*>\n?//;
	$aux =~ s/\n?\s*<[^<]*$//;
	
	return $aux;
}
