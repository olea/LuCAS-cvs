/*
 * Código fuente Jakamai
 * (C) 2001 Juan J. Amor
 * Programa bajo la proteccion de GPL 2.0
 *
 **
 * $Id: config.h,v 1.17 2002/12/03 17:19:32 ldipenti Exp $
 **
 */



#define MAXSERVERLENGHT 80

#define MAXURLLENGHT 1024

char mainserver[] = "http://genarin.hispalinux.es/LuCAS";

#define MAXSERVERS 21
char servers[MAXSERVERS][MAXSERVERLENGHT] = {
            "http://consejo-eps.uco.es/LuCAS",
  	    "http://genarin.hispalinux.es/LuCAS",
            "http://ulises.adi.uam.es/LuCAS",
            "http://www.ibiblio.org/pub/Linux/docs/LuCaS",
  	    "http://genarin.hispalinux.es/LuCAS",
	    "http://www.dynamics.unam.edu/Replicas/LuCAS",
            "http://lucas.dramor.net",
            "http://genarin.hispalinux.es/LuCAS",
            "http://ulises.adi.uam.es/LuCAS",
            "http://ftp.gul.uc3m.es/mirrors/LuCAS",
            "http://www.polinux.upv.es/LuCAS",
            "http://www.ibiblio.org/pub/Linux/docs/LuCaS/",
  	    "http://genarin.hispalinux.es/LuCAS",
            "http://www.dynamics.unam.edu/Replicas/LuCAS",
            "http://lucas.dramor.net",
            "http://ftp.gul.uc3m.es/mirrors/LuCAS",
            "http://genarin.hispalinux.es/LuCAS",
            "http://www.dynamics.unam.edu/Replicas/LuCAS",
  	    "http://genarin.hispalinux.es/LuCAS",
            "http://www.ibiblio.org/pub/Linux/docs/LuCaS",
	    "http://lucas.okulto.net",
};

char localpath[] = "/var/ftp/pub/LuCAS";
