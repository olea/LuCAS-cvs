#!/usr/bin/perl
#
# Este programa genera un aviso de novedades con el mismo algoritmo que el
# código empotrado de index.wml pero, en este caso, apto para ser enviado,
# vía correo electrónico, a foros de discusión. Dichos foros están
# configurados en el fichero listas-de-correo.conf, así como los textos de
# los mensajes y los títulos. Las noticias, como siempre, estarán en el
# fichero novedades.conf.


sub borra_marcas_html {
# Esta función toma como parámetro una cadena y devuelve la misma sin marcas
# HTML, aun si éstas no están completas dentro de la misma línea.
#
	$_=$_[0];
	TACA: {
		while (0 != s/<[^>]*>//) {};
		if ( 0 < /</ ) {
			s/<.*$//;
			redo TACA;
		}
		if ( 0 < />/ ) {
			s/^[^>]*>//;	
			redo TACA;
		}
	}
	return $_;
}


open (FICHERO , "listas-de-correo.conf");
LECTURA: while ($CAD=<FICHERO>) {
        if (($CAD !~ /^#/) && ($CAD ne "\n")) {
		($CAD =~ /^TEXTO-H/) && do {
			(defined $TITULO_H) && die "No puede definirse dos veces TEXTO-H.";
			# Proceso el título:
			$TITULO_H=substr($CAD,8);
			# Y ahora leo el texto:
			while ($CAD=<FICHERO>) {
				if ($CAD !~ /^#/) {
					if ($CAD=~/(^HISPANA)|(^INTERNACIONAL)|(^TEXTO-I)/) { 
						redo LECTURA;
					} else { 
						($CAD=~/^TEXTO-H/) && die "Definición incorrecta de TEXTO-H.";
						chop $CAD; push @TEXTO_H,$CAD;
					}
				}
			} 
		};
		($CAD =~ /^TEXTO-I/) && do {
			(defined $TITULO_I) && die "No puede definirse dos veces TEXTO-I.";
			# Proceso el título:
			$TITULO_I=substr($CAD,8);
			# Y ahora leo el texto:
			while ($CAD=<FICHERO>) {
				if ($CAD !~ /^#/) {
					if ($CAD=~/(^HISPANA)|(^INTERNACIONAL)|(^TEXTO-H)/) { 
						redo LECTURA;
					} else { 
						($CAD=~/^TEXTO-I/) && die "Definición incorrecta de TEXTO-I.";
						chop $CAD; push @TEXTO_I,$CAD;
					}
				}
			} 
		};
		($CAD =~ /^HISPANA/) && do {
			split ' ', $CAD;
			# Proceso el URL:
			($_[1] =~ /^mailto:/) && do {
				@CAD = split ':', $_[1];
				push @HISPANA,$CAD[1];
			}
		};
		($CAD =~ /^INTERNACIONAL/) && do {
			split ' ', $CAD;
			# Proceso el URL:
			($_[1] =~ /^mailto:/) && do {
				@CAD = split ':', $_[1];
				push @INTERNACIONAL,$CAD[1];
			}
		};	
	}		
}

# Controlamos una correcta configuración:
#
(!defined @TEXTO_H) && die "No se especificó el texto en español.";
(!defined @HISPANA) && die "No se especificaron foros hispanos.";
(defined @INTERNACIONAL) && (!defined @TEXTO_I) && die "Se especificaron foros internacionales pero no el texto internacional.";
	
# 	Lectura de las noticias (es el código usado para imprimir con las
# marcas HTML pero modificado para filtrar precisamente estas marcas.

# Número de noticias que queremos publicar, por cada una irá decrementando
#
$Cont=5;
open (FICHERO , "novedades.conf");
while (($Cont>0) && ($CAD=<FICHERO>)) {
        if (($CAD !~ /^#/) && ($CAD ne "\n")) {
		$Cont--;
		chop($CAD);
		push @NOVEDADES,$CAD;
		push @NOVEDADES," \n";
		$FLAG=1;
		while ($FLAG && ($CAD=<FICHERO>)) {
			if (($CAD !~ /^#/) && ($CAD ne "\n")) {
				$FLAG=0;
			}
		} 
		$FLAG=1;
		do {
			if (($CAD !~ /^#/) && ($CAD ne "\n")) {
				$CAD=borra_marcas_html $CAD;
 				push @NOVEDADES, $CAD; 
			} else {
				push @NOVEDADES," \n";
				$FLAG=0;
			}
		} while ($FLAG && ($CAD=<FICHERO>))
	}
}

# El siguiente código imprime el texto de los mensajes que habría que enviar
# a cada uno de los foros de marras. Falta el código que se encargue de
# dicho envío puesto que aún no está decidida la forma en la que se hará. La
# línea de almohadillas es simplemente un separador. Debe ser eliminada
# cuando se acabe el código.
#
foreach (@HISPANA) {
	print "To: $_\n";
	print "Subject: $TITULO_H\n";
	foreach (@TEXTO_H) {
        	print "$_\n";
	}
	foreach (@NOVEDADES) {
        	print "$_";
	}
	
	print "########################################\n";
	
};
if (defined @INTERNACIONAL) {
	foreach (@INTERNACIONAL) {
		print "To: $_\n";
		print "Subject: $TITULO_I\n";
        	foreach (@TEXTO_I) {
                	print $_,"\n";
	        }
		print "\n...........................................\n";
		foreach (@TEXTO_H) {
        		print "$_\n";
		}
		foreach (@NOVEDADES) {
        		print "$_";
		}
		print "########################################\n";
	}
}


