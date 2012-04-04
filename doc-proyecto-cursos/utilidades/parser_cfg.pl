#!/usr/bin/perl
#
# Analiza el archivo .cfg de definición de cursos y 
# arma el archivo .xml para generarlo, chequeando la existencia
# de las porciones involucradas, y su validez.
#
# Lucas Di Pentima <ldipenti@ciudad.com.ar> - 07/10/2002

###
# El archivo de datos que lee debe tener el siguiente formato:
#
# N identificador/de/porcion/sin/extension
#
# una entrada por línea, N es el nivel de profundidad, y debe estar separado
# por uno o varios espacios del identificador de porcion.
# Los caracteres # y las líneas en blanco se ignoran.

# Uso de parámetros
use Getopt::Long;

# Valores por defecto
my $titulo = "Documento de prueba";
my $debug = 0;

# Otras variables
my $genera_db = "utilidades/genera_target_db.sh";
my $target_xml = "database.xml";
my $baseuri = 'http://es.tldp.org/cursos/porciones/'; # Esto debemos verlo bien
my %porciones_incluidas;
my %porciones_referenciadas;

# Opciones de ejecución
&GetOptions("f|file=s" => \$file,
	    "o|output=s" => \$output,
	    "t|titulo=s" => \$titulo,
	    "d|debug" => \$debug,
	    "h|help" => \$help);

if($help || not ($file && $output)) { &help; }

$file = &get_cwd($file);
$output = &get_cwd($output);

open(FILE, "$file") or die "open: $!: $file";
open(OUTF, ">$output") or die "open: $!: $output";

# Algunas variables...
my $profundidad = 0;
my $nro_linea = 0;
my $nueva_prof;
my $porcion;

# Agregamos encabezado al archivo
&encabezado($titulo);

while($linea = <FILE>) {
    chomp($linea);
    $nro_linea++;

    # Eliminamos comentarios
    $linea =~ s/\#.*//;
    # Transformamos TABs en espacios
    $linea =~ s/\t/ /g;
    # Reemplazamos múltiples espacios por uno solo
    $linea =~ s/  (.*)/ $1/;

    # Si lo que encontramos es una linea válida...
    if($linea =~ /.+ .+/) {
	($nueva_prof,$porcion) = split(" ", $linea);
	
	if($nueva_prof > $profundidad) {
	    # Bajamos en profundidad
	    if($nueva_prof - $profundidad > 1) {
		die "Error en archivo $file; línea $nro_linea\n";
	    }
	    print OUTF &indent($nueva_prof)."<section>\n";
	} elsif ($nueva_prof < $profundidad) {
	    # Subimos en profundidad
	    my $prof_dif = $profundidad - $nueva_prof + 1;
	    for($prof_dif; $prof_dif > 0; $prof_dif--) {
		print OUTF &indent($nueva_prof + $prof_dif - 1)."</section>\n";
	    }
	    print OUTF &indent($nueva_prof)."<section>\n";
	} else {
	    # La profundidad no cambia
	    print OUTF &indent($nueva_prof)."</section>\n";
	    print OUTF &indent($nueva_prof)."<section>\n";
	}
	
	# Procesamos las referencias de cada porción
	open(PORCION, "$porcion.xml.porcion") or die "Porción $porcion.xml.porcion no existe, corregir línea $nro_linea\n";
	print "Analizando: $porcion.xml.porcion\n" if $debug;

	# Agregamos la porción en la lista de porciones incluidas
	$porciones_incluidas{$porcion} = 1;

	# Buscamos por porciones referenciadas
	while($p_linea = <PORCION>) {
	    chomp($p_linea);
	    if($p_linea =~ s/.*targetdoc\=\"(.*?)\"(.*)/$1/) {
		$porciones_referenciadas{"$p_linea"} = 1;
		print "REF: $porcion -> $p_linea\n" if $debug;
	    }
	}
	close(PORCION);

	print OUTF &indent($nueva_prof+1)."<xi:include xmlns:xi=\"http://www.w3.org/2001/XInclude\"\n";
	print OUTF &indent($nueva_prof+1)." href=\"$porcion.xml.porcion#xpointer(/section/*)\">\n";
	print OUTF &indent($nueva_prof+2)."<xi:fallback>\n";
	print OUTF &indent($nueva_prof+3)."<para>ATENCIÓN: <emphasis>Xinclude falló con $porcion</emphasis></para>\n";
	print OUTF &indent($nueva_prof+2)."</xi:fallback>\n";
	print OUTF &indent($nueva_prof+1)."</xi:include>\n";
	
	$profundidad = $nueva_prof;
    }
}
# Cerramos las marcas <section> que quedaron abiertas
for($profundidad; $profundidad > 0; $profundidad--) {
    print OUTF &indent($profundidad)."</section>\n";
}

# Limpiamos el hash de porciones referenciadas
foreach $p_ref (keys %porciones_referenciadas) {
    if($porciones_incluidas{$p_ref}) {
	$porciones_referenciadas{$p_ref} = "";
	print "Referencia a $p_ref resuelta, se incluye porcion\n" if $debug;
    }
}

# Por último el pie...
&pie;

close(FILE);
close(OUTF);

####
# A partir de acá se trabaja para generar los .db y el target
# database...
#

open(TDB, ">$target_xml") or die "open: $!: $file";

print TDB '<?xml version="1.0"?>'."\n";
print TDB '<!DOCTYPE targetset SYSTEM'."\n";
print TDB '    "utilidades/xsl/docbook-xsl/common/targetdatabase.dtd">'."\n\n";
print TDB '<targetset>'."\n";


foreach $porcion (keys %porciones_incluidas) {
    if($porciones_incluidas{$porcion}) {
	print "Target DB para: $porcion.xml.porcion\n" if $debug;
	system("$genera_db $porcion.xml.porcion");

	print TDB "    <document targetdoc=\"$porcion\"\n";
	print TDB "      baseuri=\"\">\n";
	print TDB '        <xi:include xmlns:xi="http://www.w3.org/2001/XInclude"'."\n";
	print TDB "          href=\"$porcion.db\"/>\n";
	print TDB '    </document>'."\n\n";
    }
}
foreach $porcion (keys %porciones_referenciadas) {
    if($porciones_referenciadas{$porcion}) {
	print "Target DB para: $porcion.xml.porcion\n" if $debug;
	system("$genera_db $porcion.xml.porcion");

	print TDB "    <document targetdoc=\"$porcion\"\n";
	print TDB "      baseuri=\"$baseuri\">\n";
	print TDB '        <xi:include xmlns:xi="http://www.w3.org/2001/XInclude"'."\n";
	print TDB "          href=\"$porcion.db\"/>\n";
	print TDB '    </document>'."\n\n";
    }
}

print TDB "</targetset>\n";

close(TDB);

##############################################################
######### F U N C I O N E S   U T I L I T A R I A S ##########
##############################################################

sub help {
    print << "EOH";
Uso:
    parser_cfg.pl -f <archivo.cfg> -o <salida.xml> [-t titulo] [-d]

    <archivo.cfg>           Archivo de definición de curso
    <salida.xml>            Archivo DocBook XML resultante
    [-t titulo]             Titulo del documento (opcional)
    [-d]                    Activar mensajes extras.

EOH
    exit(0);
}

# Si el archivo pasado no tiene ruta absoluta, agregarle una.
sub get_cwd {
    my $file = shift;
    

    if($file !~ /^\/.*/) {
	my $cwd = `pwd`;
	chomp($cwd);
	$file = $cwd."/".$file;
    }
    return $file;
}

# Retorna un string de espacios dependiente del parámetro
sub indent {
    my $prof = shift;
    my $str = "";

    for($prof; $prof > 0; $prof--) {
	$str .= "    ";
    }
    return $str;
}

# Impresión de encabezado, toma como argumento el título.
sub encabezado {
    my $tit = shift;

    print OUTF << "EOE";
<?xml version="1.0" encoding="ISO-8859-1"?><!-- -*- xml -*- -->
<!DOCTYPE article PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
  "file:///usr/share/sgml/docbook/dtd/xml/4.1.2/docbookx.dtd">

<article lang="es">
    <articleinfo>
        <title>$tit</title>
	<author>
	    <firstname>Proyecto Cursos</firstname>
	    <surname>http://es.tldp.org/htmls/cursos.html</surname>
	</author>
    </articleinfo>


EOE
}

# Impresión del pie del documento.
sub pie {
    print OUTF << "EOP";

</article>

EOP
}
