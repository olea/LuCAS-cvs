#!/usr/bin/perl -w 
#

use XML::Parser::Expat;

$|=1;

if ( !$ARGV[0] ) 
{
       print "Argument missing\n";
       exit 1;
}

$inline_tags = "acronym|ulink|link|citetitle|firstname|surname|application|guimenu|guisubmenu|guimenuitem|menuchoice|interface|guilabel|guibutton|glossterm|systemitem|filename|xref|emphasis|keycap|markup|email|command|inlinegraphic|entry|email|screeninfo|graphic";
$one_line = "title|member";
	  
$todo = '<?xml version="1.0"?>'."\n";
$temp = "";
$ancho = "  ";
$indentacion = 0;

#open IN , "<$ARGV[0]";
#my $todo = join ('', <IN>);
#close (IN);

$parser = new XML::Parser::Expat;
$parser->setHandlers('Start'   => \&inicio,
                     'End'     => \&fin,
		     'Char'    => \&cadena,
		     'Doctype' => \&doctype,
		     'Comment' => \&comentario);
	  
open(FOO, "$ARGV[0]") or die "Couldn't open";
$parser->parse(*FOO);
close(FOO);


$todo =~ s/\n+/\n/gm;
$todo =~ s/\n *\n/\n/gm;
print "$todo\n";

exit 1;

sub inicio
{
	my ($p, $el, %atts) = @_;
	my $tag = "<$el";
	foreach my $key ( sort %atts)
	{
		if ( $atts{$key} )
		{
			$tag .= " $key=\"$atts{$key}\"";
		}
	}
	$tag .= ">";

	if ( !($el =~ /$inline_tags|$one_line/) )
	{
		$temp = &indentar ($temp, $indentacion);
		if ( $temp ) {
			$todo .= "$temp\n";
		}
		my $pad = $ancho x $indentacion;
		$todo .= "$pad$tag\n";
		$temp = "";
		$indentacion++;
	}
	else
	{
		$temp .= $tag;
	}
}

sub fin
{
	my ($p, $el) = @_;
	my $tag = "</$el>";
	if ( !($el =~ /$inline_tags/) )
	{
		$temp = &indentar ($temp, $indentacion);
		$temp =~ s/\n$// ;
		$todo .= "$temp";
		if ( !($el =~ /$one_line/) )
		{
			$indentacion--;
			if ( !($todo =~ /\n$/) ) {
				$todo .= "\n";
			}
			my $pad = $ancho x $indentacion;
			$todo .= "$pad";
			#$indentacion--;
		}
		$todo .= "$tag\n";
		$temp = "";
		#		$indentacion++;
	}
	else
	{
		$temp .= "$tag";
	}
}

sub cadena
{
	my ($p, $str) = @_;
	$str =~ s/ +/ /g;
	#$str =~ s/^ //;
	#$str =~ s/ $//;
	$temp .= "$str";
}

sub comentario
{
	my ($p, $str) = @_;
	$todo .= "<!--\n $str \n-->\n";
}
		
sub doctype
{
	my ($p, $name, $sysid, $pubid, $internal) = @_;
	$todo .= "<!DOCTYPE $name ";
	if ($pubid) {
	    $todo .= "PUBLIC \"$pubid\" ";
	} else {
	    $todo .= "SYSTEM ";
	}
	$todo .= "\n               \"$sysid\">\n";
	if ( $internal ) {
	    #$todo .= "Internal";
	} else {
	    #$todo .= "Not Internal";
	}
}
		
																	    
sub indentar ()
{
	my $linea = $_[0] ;

	# Quitar retornos de carro y espacios de relleno
	$linea =~ s/\n/ /gm;
	$linea =~ s/ +/ /gm;

	#	print ("Indentacion es $_[1]\nLinea $_[0]\n");
	my $indentacion = $_[1];
	my $cantidad = 75 - ( $indentacion * length($ancho));
	my $pad = $ancho x $indentacion;
	
	my $temp = &cortar_linea ( $linea, $cantidad);
	$temp =~ s/\n/\n$pad/g;
	$temp =~ s/^ //;
	my $resultado = "$pad$temp\n";
	return $resultado;
}

sub cortar_linea ()
{
	my $linea = $_[0];
	#$linea =~ s/\n/ \n/;
	$linea .= " ";
	my $cantidad = $_[1];
	$temp = "";
	$temp2 = "";
	#print "Llega $linea\n";
	while ( $linea =~ /(.+?) / )
	{
		if ( (length ($temp) + length ($+)) <= $cantidad )
		{
			$temp .= "$+ ";
			$linea = $';
		}
		elsif ( length ($+) >= $cantidad ) 
		{
			$linea = $';
			$temp2 .= "$temp\n$+";
			$temp = "";
		}
		else
		{
			$temp2 .= "$temp\n";
			$temp = "$+ ";
			$linea = $';
		}
	}
	$temp2 .= "$temp\n";
	$temp2 =~ s/\n$//;
	$temp2 =~ s/ $//;
	#	print "Sale\n##$temp2##\n";
	return $temp2;
}
