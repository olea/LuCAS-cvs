# RDFi - imprenta-e RDF
#
# Módulo Perl que crea los documentos RSS y RDF
# con los datos generados por la imprenta-e
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

package Utils::RDFi;

require Exporter;
@ISA = (Exporter);

require XML::DOM;
require XML::RSS;

@EXPORT = qw (makeRSS
				add_itemRSS);
				  
############
#	RSS    #	
############
# Función que crea un archivo RSS versión 1.0
# recive como parámetros el nombre del archivo a 
# crear y un hash con los datos del canal
sub RDFi::makeRSS {
	my $filename;
	my $channel;
	my $rss;
	
	($filename, $channel) = @_;
	
	$rss = new XML::RSS (version => '1.0', encoding => 'ISO-8859-1');
	
	$rss->channel (title 			=> $channel->{title},
				link 			=> $channel->{link},
				description		=> $channel->{description}, 
				dc => 	{
						creator => 'imprenta-e',
					});
					
	$rss->save ($filename);
}

# Función que añade una entrada al RSS
sub RDFi::add_itemRSS {
	my $filename;
	my $item;
	my $rss;

	($filename, $item) = @_;
	
	$rss = new XML::RSS (version => '1.0', encoding => 'ISO-8859-1');
	
	$rss->parsefile ($filename);
	
	$rss->add_item (title		=> $item->{title},
				link		=> $item->{url_doc},
				description => $item->{description},
				mode => 'insert');
	
	$rss->save ($filename);	
}

1;
