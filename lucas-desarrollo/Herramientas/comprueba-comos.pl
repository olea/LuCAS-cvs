#!/usr/bin/perl -w
# comprueba-comos v0.1 Marzo 2000
# (c) 2000 Javier Fernández-Sanguino Peña
# Distribuido bajo licencia GNU, ver http://www.gnu.org
# -------------------------------------------------------------
# Parser para comprobar errores típicos de documentos de INSFLUG
# Esta basado en las reglas establecidas por el grupo coordinador
# de insflug y que puede encontrar en http://www.insflug.org/colaboracion/estilo/
# Método de uso: 'comprueba-comos documento.sgml'

# ENTRADA
# Un documento sgml. Puede utilizar otro tipo de documentos pero los
# errores de formato están preparado para este tipo de documentos

# SALIDA
# La salida se presenta de una forma uniforme:
# tipo de error:línea del documento: descripción del error
# Actualmente hay tres tipos de errores
# - WF -> de formato
# - WP -> de puntuación
# - WG -> gramaticales
# Si desea ver un tipo determinado de error hagalo de la siguiente forma
# 'insflug-check <documento.sgml |grep ^tipo_de_error'

# AHACER: 
# - probar las expresiones de forma intensiva sobre documentos
# - añadir opciones de línea de comandos (--help, --verbose, etc..)
# - añádir más expresiones regulares para manejar más errores típicos
# - posibles mejoras: si spell está instalado ejecutarlo sobre la documentación
# definiendo un ratio aceptable de palabras del documento (wc -w) y
# errores detectados por spell (spell documento|sort|uniq -iu |wc -w para
# ver las palabras únicas y sin el sort ni uniq para verlas todas) se podría llegar
# a ver rápidamente documentos que estén mal escritos. 
# El problema aquí, sin embargo, es que los documentos generalmente tendrán
# muchas cosas en inglés que no son errores (per se), como por ejemplo salidas
# del tipo <code>

# Comprobaciones previas
$file = $ARGV[0];
if ( ! -f $file ) {
	die "No puedo encontrar $file\n";
}
print "Fichero a comprobar: $file\n";

# Lista de errores
# NOTA: Se han dejado suficientes numeros sin asignar como para hacer
# nuevos tests en cada grupo de errores
#	Errores de Formato (1-50)

$errores[1]="Longitud mayor de 74 caracteres";
$errores[2]="Dejar línea en blanco entre parrafo y parrafo en lugar de <P>";
$errores[3]="Separar con líneas en blanco marcas específicas";
$errores[4]="No usar sangrías en el texto";
$errores[5]="Toda URI se debe escribir con letra de anchura fija";
$errores[6]="Los urls deben repetirse en el atributo name";
$errores[7]="No se puede emplear el método abreviado <xx/xx/";
$errores[8]="Es recomendable usar siempre el entorno <tscreen> en lugar de <code>";
#	Errores de puntuación (51-100)
$errores[51]="Usar comillas castellanas «» en lugar de \"\" para palabras"; 
# 	Errores gramaticales (101-150)
$errores[101]="Tratar al lector de vd. y no de tu";
$errores[102]="Hablar de idioma castellano en lugar de español";
$errores[103]="El comienzo de un parrafo debe estar en mayúsculas";
$errores[104]="Parece haber demasiados errores ortográficos\n\to quizás es que hay demasiada palabras en inglés/código con respecto al texto";


$previous_blank = 0;
$previous_section = 0;
$line_number = 0;

open (FILE, "$file") || die "No puedo abrir $file: $!\n";
while ($line=<FILE>) {
	chomp $line;
	$line_number++;
	$line =~ s/\s{2,}//g; # Eliminar espacios en blanco innecesarios
	
	#Errores de formato
	avisoFormato($line_number, 1) if (length($line) > 74);
	avisoFormato($line_number, 2) if ($line =~ /^\<P\>/i and !$previous_blank and !$previous_section);
	# Tags de fecha/autor, debería aplicarlo sobre algunos tipos fijos (date,author..)
	avisoFormato($line_number, 3) if ($line =~ /^\<(\w+)\>/ and lc($1) ne "p" 
			and lc($1) ne "item" and !$previous_blank);
	avisoFormato($line_number, 4) if ($line =~ /^\t/ );
# Esta comprobación todavía no se hace bien
#	avisoFormato($line_number, 5) if ($line !~ /\<tt\>\w+?:\/\/.*?\<\/tt\>/i and $line =~ /.*?:\/\/.*?/i );
	avisoFormato($line_number, 6) if ($line =~ /\<htmlurl\s+url=".*?"\s+\>/ );
	avisoFormato($line_number, 7) if ($line =~ /\<\w+\/\w+\// );
	avisoFormato($line_number, 8) if ($line =~ /\<code\>/ );

	#Busqueda de errores de puntuación
	# Intenta localizar unas comillas que no formen parte de un tag
	avisoFormato($line_number, 51) if ($line =~ /"(\w+)\"/ and $line !~ /="$1"/);

	#Búsqueda de errores de gramática
	# Intenta localizar alguna referencia a tu en lugar de vd.
	avisoFormato ($line_number, 101) if ($line =~ /\stu\s/ or $line =~ /\stú\s/);
	avisoFormato ($line_number, 102) if ($line =~ /español/ );
	avisoFormato ($line_number, 103) if ($line =~ /^(\w)/ and uc($1) ne $1 and $previous_blank);
	
	$previous_blank = 0;
	$previous_section = 0;
	$previous_blank = 1 if ($line eq "");
	$previous_section = 1 if ($line =~ /^<sect.*?>/i);
}


# Aquí  van las comprobaciones de spell
# Observese que el diccionario por defecto debe ser el de español
if ( -x '/usr/bin/spell' ) {
	print "Comprobando ortografía del documento utilizando 'spell'\n";
	my $palabras =  `wc -w $file`;
	my $errores_spell = `spell $file |wc -w`;
	chomp $palabras;
	chomp $errores_spell;
	$palabras =~ s/(\d+)\s.*$/$1/;
	my $ratio = $errores_spell * 100 / $palabras;
	print "Palabras: $palabras, Posibles Errores: $errores_spell, Ratio= $ratio%\n";
	avisoFormato ($line_number, 104)   if ( $ratio > 30 ) ;
}


exit 0;


sub avisoFormato {
	my ($number_line, $warning) = (@_);
	my $type = "W";
	$type .= "F" if $warning < 51; # Errores de Formato
	$type .= "P" if $warning < 101 and $warning > 50; # Errores de puntuación
	$type .= "G" if $warning < 151 and $warning > 100; # Errores de gramática
	print "$type:$number_line:$errores[$warning]\n";
}
