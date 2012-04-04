#!/usr/bin/perl -T
# -*-Perl-*-

#---
# $Id: dict_main.cgi,v 1.1 2005/03/13 20:05:07 felipe.ceballos Exp $
#
# ------------
# Description:
# ------------
#  Dictionary's main search/submit page.
#
#  + Search for approved dictionary terms
#  + Submit new terms for approval
#
# -----------------
# Revision Details:    (Updated by Revision Control System)
# -----------------
#  $Date: 2005/03/13 20:05:07 $
#  $Author: felipe.ceballos $
#  $Revision: 1.1 $
#  $Source: /cvs/lucas/rl-dict-es/dict_main.cgi,v $
#
# (www.arabeyes.org - under GPL license - see COPYING file)
#---

# Let's make perl happy in terms of taint'ness :-)
$ENV{"PATH"}	= undef;

#use strict;

require DBI;

require "./dict_header.pl";
require "./dict_lib.pl";

print $header;

if ($embed)
{
    &display_file($title_main, $file_header);
}

my ($ref_in,
    $ignored)	= &readform;

my %in		= %{$ref_in};

if	( $in{'action'} eq "do_search_dict" )	{ &do_search_dict; }
elsif	( $in{'action'} eq "search_dict" )	{ &search_dict(\$cgi_main,
							       \%in); }

else
{
    # Get the number of terms within the DICT server to display
    $in{'dictd_num'}	= &dictd_term_num($in{'dictd_num'}, \$cgi_main);

    $content   .= &displaysearchform(1, \$cgi_main); 

    &display($content);
}

# If we're embedding into a site - include these site specific files
if ($embed)
{
    &display_file(0, $file_right);
    &display_file(0, $file_footer);
}

# Normal exit
exit(0);

       ###        ###
######## Procedures ########
       ###        ###

##
# Display the search form
sub do_search_dict
{
    my $content	= &displaysearchform(1, \$cgi_main);
    &display($content);
}

1;	# for require (if any)
