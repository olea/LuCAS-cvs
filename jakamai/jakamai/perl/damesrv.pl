#!/usr/bin/perl
##
# Código fuente Jakamai
# Copyright (C) 2001 Hispalinux / Juan J. Amor / Ramon G. Camus
# Programa bajo la proteccion de GPL 2.0
##
# $Id: damesrv.pl,v 1.2 2001/07/17 13:26:50 jjamor Exp $
#
# Copiado de: damesrv.pl, v1.9 2001/05/23 19:10:42 jjamor Exp (web-lucas)
#
##

# srand (time^(($$ << 15) + 3 * $$ + 1));

use LWP::UserAgent;

### PARTE DE CONFIGURACION

# CONFIGURACION ACTUAL:
# 1/11 hispalinux.digitel.es
# 2/11 lucas.olea.org
# 2/11 polinux.upv.es
# 2/11 ulises.adi.uam.es
# 2/11 ftp.gul.uc3m.es
# 2/11 dinamica1.fciencias.unam.mx

# Lista de servidores replica
@servers = (
	    'http://lucas.olea.org',
	    'http://ulises.adi.uam.es/LuCAS',
            'http://www.polinux.upv.es/LuCAS',
	    'http://ulises.adi.uam.es/LuCAS',
            'http://ftp.gul.uc3m.es/mirrors/LuCAS',
            'http://www.polinux.upv.es/LuCAS',
            'http://lucas.olea.org',
	    'http://hispalinux.digitel.es/LuCAS',
            'http://dinamica1.fciencias.unam.mx/Linux/LuCAS',
            'http://ftp.gul.uc3m.es/mirrors/LuCAS',
            'http://dinamica1.fciencias.unam.mx/Linux/LuCAS'
	    );

# Numero de servidores replica
$numservers = scalar(@servers);

# URL del servidor principal (no virtual host)
$mainserver = "http://torresquevedo.hispalinux.es/LuCAS";

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

    if (-r $ficheroelegido) {

	# Si la URL es valida buscamos un mirror que pueda servirla
	my $vueltas = $numservers;
	do {
	    $cnt = (($cnt+1) % $numservers);
	    $server = "@servers[$cnt]/$_";
	    $req = new HTTP::Request HEAD => $server; 
	    $res = $ua->request($req);
	    $vueltas--;
	} until ( ($res->is_success) || ($vueltas == 0) );

    } else { 
    	# Ni siquiera existe en LuCAS. Saldrá la pagina de error:
	$server="$mainserver/$_";
    }

    # Devolvemos la URL finalmente elegida
    print "$server\n"; 
    
}

