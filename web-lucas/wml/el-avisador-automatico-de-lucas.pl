#!/usr/bin/perl
##
# Código fuente LuCAS V3
# Copyright (C) 1999 Hispalinux / Juan J. Amor / Ismael Olea
# Programa bajo la proteccion de GPL 2.0
##
# $Id: el-avisador-automatico-de-lucas.pl,v 1.3 2002/09/22 15:36:42 olea Exp $
##
#
# Copyright Ismael Olea <ismael@olea.org>
# Programa bajo la protección de GPL 2.0
#
# Este programa genera un aviso de novedades con el mismo algoritmo que el
# código empotrado de index.wml pero, en este caso, apto para ser enviado,
# vía smtp y nntp, a foros de discusión. 
#
# Los ficheros de configuración son:
# 	- listas-de-correo.conf, direcciones de los foros y texto de
# 	presentación.
#	- novedades.conf, noticias; usado además por novedades.wml e
#	index.wml.
#
# Modificaciones por:
# Juan Jose Amor <jjamor@ls.fi.upm.es>, Abril-1999
#

# Parámetros configurables:
#
$rpost="../bin/rpost";
$sendmail="/usr/lib/sendmail";
$NumeroNoticias=5;
$FichConfiguracion="listas-de-correo.conf";
$FichNoticias="novedades.conf";

sub Filtro_url_nntp {
#
# Esta función toma como parámetro una cadena de texto con un url. 
# En el caso de que el url sea del servicio 'nntp' devolverá un ``hash'' con
# los campos ``Servidor'', ``Puerto'' y ``Grupo''.
# En caso contrario devolverá un 'hash' vacío.
#
	$_=$_[0];
	if ($_ =~ /^nntp/) {
		$Cad=substr $_, 7;
		$Idx1=index $Cad,':';
		$Idx2=rindex $Cad,'/';
		if ($Idx1==-1) {
			$Serv=substr $Cad, 0, $Idx2;
			$Puerto=119;
		} else {
			$Serv=substr $Cad, 0, $Idx1;			
			$Puerto=substr $Cad, $Idx1+1, $Idx2 - $Idx1 -1 ;
		}
		$Grupo=substr $Cad, $Idx2 +1;
		return ('Servidor', $Serv, 'Puerto', $Puerto, 'Grupo', $Grupo);
	} else {
		return ();
	}
}

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

open (FICHERO , $FichConfiguracion);
LECTURA: while ($CAD=<FICHERO>) {
        if (($CAD !~ /^#/) && ($CAD ne "\n")) {
		($CAD =~ /^TEXTO-H/) && do {
			(defined $TITULO_H) && die "No puede definirse dos veces TEXTO-H.";
			# Proceso el título:
			$TITULO_H=substr($CAD,8);
			chop $TITULO_H;
			# Y ahora leo el texto:
			while ($CAD=<FICHERO>) {
				if ($CAD !~ /^#/) {
					if ($CAD=~/(^HISPANA)|(^INTERNACIONAL)|(^PIE-I)|(^PIE-H)|(^TEXTO-I)/) { 
						redo LECTURA;
					} else { 
						($CAD=~/^TEXTO-H/) && die "Definición incorrecta de TEXTO-H.";
						chop $CAD; push @TEXTO_H,$CAD;
					}
				}
			} 
		};
		($CAD =~ /^PIE-H/) && do {
			# Y ahora leo el texto:
			while ($CAD=<FICHERO>) {
				if ($CAD !~ /^#/) {
					if ($CAD=~/(^HISPANA)|(^INTERNACIONAL)|(^PIE-I)|(^PIE-H)|(^TEXTO-H)/) { 
						redo LECTURA;
					} else { 
						($CAD=~/^PIE-H/) && die "Definición incorrecta de PIE-H.";
						push @PIE_H,$CAD;
					}
				}
			} 
		};
		($CAD =~ /^PIE-I/) && do {
			# Y ahora leo el texto:
			while ($CAD=<FICHERO>) {
				if ($CAD !~ /^#/) {
					if ($CAD=~/(^HISPANA)|(^INTERNACIONAL)|(^PIE-I)|(^PIE-H)|(^TEXTO-H)/) { 
						redo LECTURA;
					} else { 
						($CAD=~/^PIE-I/) && die "Definición incorrecta de PIE-I.";
						push @PIE_I,$CAD;
					}
				}
			} 
		};
		($CAD =~ /^TEXTO-I/) && do {
			(defined $TITULO_I) && die "No puede definirse dos veces TEXTO-I.";
			# Proceso el título:
			$TITULO_I=substr($CAD,8);
			chop $TITULO_I;
			# Y ahora leo el texto:
			while ($CAD=<FICHERO>) {
				if ($CAD !~ /^#/) {
					if ($CAD=~/(^HISPANA)|(^INTERNACIONAL)|(^TEXTO-H)|(^PIE-I)|(^PIE-H)/) { 
						redo LECTURA;
					} else { 
						($CAD=~/^TEXTO-I/) && die "Definición incorrecta de TEXTO-I.";
						chop $CAD; push @TEXTO_I,$CAD;
					}
				}
			} 
		};
		($CAD =~ /^DIR-SPAM/) && do {
			split ' ', $CAD;
			$DIR_SPAM = substr($CAD,9);
			chop $DIR_SPAM;
		};
		($CAD =~ /^HISPANA/) && do {
			split ' ', $CAD;
			# Proceso el URL:
			($_[1] =~ /^mailto:/) && do {
				@CAD = split ':', $_[1];
				push @SMTP_H,$CAD[1];
			};
			($_[1] =~ /^nntp:/) && do {
				(!defined $Cont_H) && do { $Cont_H=0;};
				%Url=Filtro_url_nntp $_[1];
				$NNTP_H[$Cont_H]{'Servidor'}=$Url{'Servidor'};
				$NNTP_H[$Cont_H]{'Puerto'}=$Url{'Puerto'};
				$NNTP_H[$Cont_H]{'Grupo'}=$Url{'Grupo'};
				$Cont_H++;	
    			}
		};
		($CAD =~ /^INTERNACIONAL/) && do {
			split ' ', $CAD;
			# Proceso el URL:
			($_[1] =~ /^mailto:/) && do {
				@CAD = split ':', $_[1];
				push @SMTP_I,$CAD[1];
			};
			($_[1] =~ /^nntp:/) && do {
				(!defined $Cont_I) && do {$Cont_I=0;};
				%Url=Filtro_url_nntp $_[1];
				$NNTP_I[$Cont_I]{'Servidor'}=$Url{'Servidor'};
				$NNTP_I[$Cont_I]{'Puerto'}=$Url{'Puerto'};
				$NNTP_I[$Cont_I]{'Grupo'}=$Url{'Grupo'};
				$Cont_I++;	
    			}
		}
	}		
}

# Controlamos una correcta configuración:
#
(!defined $DIR_SPAM) && die "No se ha definido la dirección de origen.";
(!defined @TEXTO_H) && die "No se especificó el texto en español.";
((!defined @SMTP_H) && (!defined @NNTP)) && die "No se especificaron foros hispanos.";
((defined @SMTP_I) || (defined @NNTP_I)) && (!defined @TEXTO_I) && die "Se especificaron foros internacionales pero no el texto internacional.";
((!defined @PIE_I) || (!defined @PIE_H)) && die "No se especificaron los pies de mensaje.";

# 	Lectura de las noticias (es el código usado para imprimir con las
# marcas HTML pero modificado para filtrar precisamente estas marcas.

# Número de noticias que queremos publicar, por cada una irá decrementando
#
$Cont=$NumeroNoticias;
open (FICHERO , $FichNoticias);
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

# Preparación del texto a enviar (español)
#
foreach (@TEXTO_H) {
       	push @MENSAJE, "$_\n";
}
foreach (@NOVEDADES) {
       	push @MENSAJE, $_;
}	

# Creación de los mensajes smtp:
#
foreach (@SMTP_H) {
	# Invocación del programa de correo:
	#
	open SMTP, "|$sendmail -f $DIR_SPAM $_";
	# open SMTP, "|cat > sendmail.salida";

	print SMTP "From: Anuncios de TLDP-ES <$DIR_SPAM>\n";
	print SMTP "To: $_\n";
	print SMTP "Subject: [TLDP-ES] $TITULO_H\n";
	print SMTP "X-Mailer: El-avisador-automatico-de-LuCAS v1.0\n";
	print SMTP "MIME-Version: 1.0\n";
	print SMTP "Content-transfer-encoding: 8BIT\n";

#
# Añadido por Isma porque no salía bien en su Notescapes linuxero:

        print SMTP "Content-Type: text/plain; charset=iso-8859-1\n";
	
	print SMTP "\n";
	foreach (@MENSAJE) { print SMTP; }
	print SMTP "\n--\n";
	foreach (@PIE_H) { print SMTP; }
	close SMTP;
};

if (defined @SMTP_I) {
	# Preparación del texto a enviar (internacional)
	#
	foreach (@TEXTO_I) {
       		push @MESSAGE, "$_\n";
	}
	push @MESSAGE,"\n------------------------8<--------------8<--------------------\n";            
	push @MESSAGE, @MENSAJE;
	foreach (@SMTP_I) {
		# Invocación del programa de correo:
		#
		open SMTP, "|$sendmail -f $DIR_SPAM $_";
		# open SMTP, "|cat > sendmail.salida-i";

		print SMTP "From: Anuncios de TLDP-ES <$DIR_SPAM>\n";
		print SMTP "To: $_\n";
		print SMTP "Subject: [TLDP-ES] $TITULO_H\n";
		print SMTP "X-Mailer: El-avisador-automatico-de-LuCAS v1.0\n";
		print SMTP "MIME-Version: 1.0\n";
		print SMTP "Content-transfer-encoding: 8BIT\n";

#
# Añadido por Isma porque no salía bien en su Notescapes linuxero:

        print SMTP "Content-Type: text/plain; charset=iso-8859-1\n";
	
		print SMTP "\n";
        	foreach (@MESSAGE) { print SMTP; }
		print SMTP "\n--\n";
		foreach (@PIE_I) { print SMTP; }
        	close SMTP;
	}
}

# Creación de los mensajes nntp:
#
for $Cont ( 0 .. $#NNTP_H) {
	# Invocación del programa de noticias:
	#
        open NNTP, "|$rpost $NNTP_H[$Cont]{'Servidor'} -N $NNTP_H[$Cont]{'Puerto'}";
	# open NNTP, "|cat > nntp.salida";

	print NNTP "From: Anuncios de TLDP-ES <$DIR_SPAM>\n";
	print NNTP "Newsgroups: $NNTP_H[$Cont]{'Grupo'}\n";
	print NNTP "Subject: [TLDP-ES] $TITULO_H\n";
	print NNTP "MIME-Version: 1.0\n";
	print NNTP "Content-transfer-encoding: 8BIT\n";

#
# Añadido por Isma porque no salía bien en su Notescapes linuxero:

        print NNTP "Content-Type: text/plain; charset=iso-8859-1\n";
	
	print NNTP "Organization: TLDP-ES\n";
	print NNTP "X-News-App: El-avisador-automatico-de-LuCAS v1.0\n";
	print NNTP "\n";
	foreach (@MENSAJE) { print NNTP; }
	print NNTP "\n--\n";
	foreach (@PIE_H) { print NNTP; }
	close NNTP;
};
for $Cont ( 0 .. $#NNTP_I) {
	# Invocación del programa de noticias:
	#
	open NNTP, "|$rpost $NNTP_I[$Cont]{'Servidor'} -N $NNTP_H[$Cont]{'Puerto'}";
	# open NNTP, "|cat > nntp.salida-i";

	print NNTP "From: Anuncios de TLDP-ES <$DIR_SPAM>\n";
	print NNTP "Newsgroups: $NNTP_I[$Cont]{'Grupo'}\n";
	print NNTP "Subject: [TLDP-ES] $TITULO_H\n";
	print NNTP "MIME-Version: 1.0\n";
	print NNTP "Content-transfer-encoding: 8BIT\n";


#       
# Añadido por Isma porque no salía bien en su Notescapes linuxero:
        
        print NNTP "Content-Type: text/plain; charset=iso-8859-1\n";
        
	print NNTP "Organization: TLDP-ES\n";
	print NNTP "X-News-App: El-avisador-automatico-de-LuCAS v1.0\n";
	print NNTP "\n";
	foreach (@MESSAGE) { print NNTP; }
	print NNTP "\n--\n";
	foreach (@PIE_I) { print NNTP; }
	close NNTP;
};




