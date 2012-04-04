#!/usr/bin/perl
##
# Código fuente Jakamai
# Copyright (C) 2001 Hispalinux / Juan J. Amor / Ramon G. Camus
# Programa bajo la proteccion de GPL 2.0
##
# $Id: damesrv.pl,v 1.13 2001/07/31 21:28:19 jjamor Exp $
##

# srand (time^(($$ << 15) + 3 * $$ + 1));

use LWP::UserAgent;

### PARTE DE CONFIGURACION

# CONFIGURACION ACTUAL:
# 2/14 hispalinux.digitel.es
# 2/14 lucas.olea.org
# 2/14 lucas.dramor.net
# 2/14 polinux.upv.es
# 2/14 ulises.adi.uam.es
# 2/14 ftp.gul.uc3m.es
# 2/14 dinamica1.fciencias.unam.mx

# Lista de servidores replica
@servers = (
	    'http://lucas.olea.org',
	    'http://ulises.adi.uam.es/LuCAS',
            'http://lucas.dramor.net',
            'http://www.polinux.upv.es/LuCAS',
	    'http://ulises.adi.uam.es/LuCAS',
            'http://ftp.gul.uc3m.es/mirrors/LuCAS',
            'http://www.polinux.upv.es/LuCAS',
            'http://lucas.olea.org',
	    'http://hispalinux.digitel.es/LuCAS',
            'http://dinamica1.fciencias.unam.mx/Linux/LuCAS',
            'http://lucas.dramor.net',
            'http://ftp.gul.uc3m.es/mirrors/LuCAS',
            'http://dinamica1.fciencias.unam.mx/Linux/LuCAS',
	    'http://hispalinux.digitel.es/LuCAS'
	    );

# Numero de servidores replica
$numservers = scalar(@servers);

# URL del servidor principal (no virtual host)
$mainserver = "http://tquevedo.hispalinux.es/LuCAS";

# Directorio fisico de los ficheros en el servidor principal
$dirlucas = "/var/www/LuCAS";

### FIN DE PARTE CONFIGURABLE



$ua = new LWP::UserAgent; 
$ua->agent("LuCAS-forwarder/0.5 " . $ua->agent) ; 

# $sel = int(rand($numservers));

$| = 1;

$cnt = 0; # Round-robin

while (<STDIN>) {

    # Existe realmente en lucas:

    #my $req = new HTTP::Request HEAD => "$mainserver/$_" ; 
    #my $res = $ua->request($req);

    #$_ = "index.html" if ($_ =~ /\/$/);

    chop; # Quitar el \n del final

    my $ficheroelegido = "$dirlucas/$_";

    if (! -r $ficheroelegido) {

    	# Ni siquiera existe en LuCAS. Saldrá la pagina de error:
	$server="$mainserver/$_";

    } else { 

	$cnt = (($cnt+1) % $numservers);
	$server = "@servers[$cnt]/$_";

    }

    # Devolvemos la URL finalmente elegida
    print "$server\n"; 
    
}

