#---
# $Id: dict_header.pl,v 1.3 2005/03/25 23:05:57 setepo Exp $
#
# ------------
# Description:
# ------------
#  Dictionary's header/configuration file.
#
# -----------------
# Revision Details:    (Updated by Revision Control System)
# -----------------
#  $Date: 2005/03/25 23:05:57 $
#  $Author: setepo $
#  $Revision: 1.3 $
#  $Source: /cvs/lucas/rl-dict-es/dict_header.pl,v $
#
# (www.arabeyes.org - under GPL license - see COPYING file)
#---

# Package specific settings (version/home-page)
$myname		= "Grupo DICT-ES";
$mystring	= "Diccionarios abiertos en espa&ntilde;ol";
$homepage	= "http://es.dict.org";

# Domain name of dictd server
$dictd_host    = "localhost";

# Domain name of where local dictionary will reside
$dom		= "es.dict.org";
$Dom		= "\u$dom\E";

# Site URL
$url		= "/bin";

# Main dictionary URL
$cgi_main       = "$url/Dict";

# Specify sendmail's location
$sendmail	= "/usr/sbin/sendmail";

# Indicate the height of an input form
$height		= "30";

# Cookie domain name
$dot_domain	= ".$domain";

# Cookie path (all below browser will send cookie)
$cookie_path	= "/";

# Cookie expiration (beginnig of time - ie. now)
$comp_big_bang	= "Thu, 01-Jan-1970 00:00:00 GMT";

# Specify common header to be used
$doctype	= qq
|<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">|;
$header		= "Content-type: text/html; charset=utf-8\n\n";

# Specify local titles & messages to be used in HTML output
$str_main	= "$myname $mystring";
$title_main	= "title=$str_main";
$page_main	= "<h2>\[$Dom - $myname\]</h2>";
$page_main	= qq|<center><img src="http://dict.org/gifs/dict.org-300x83.gif"
			  alt="\[$Dom - $myname\]"</center>|;

# Specify directory to upload files to
$upload_path    = "/CHANGE_ME/path/path";

# Specify whether to print debug messages (debug mode)
$debug          = 0;

# Specify whether this code is embedded or stand-alone (site specific)
$embed		= 0;

# Specify file names and paths of files to embed
#$file_header	= "";
#$file_right  	= "";
#$file_footer	= "";

# Specify various support applications
$ASPELL		= "/usr/bin/aspell";

1;   # for require (if any)
