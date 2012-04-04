# -*-Perl-*-

#---
# $Id: dict_lib.pl,v 1.1 2005/03/13 20:05:07 felipe.ceballos Exp $
#
# ------------
# Description:
# ------------
#  Dictionary's common shared subroutines/functions.
#
# -----------------
# Revision Details:    (Updated by Revision Control System)
# -----------------
#  $Date: 2005/03/13 20:05:07 $
#  $Author: felipe.ceballos $
#  $Revision: 1.1 $
#  $Source: /cvs/lucas/rl-dict-es/dict_lib.pl,v $
#
# (www.arabeyes.org - under GPL license - see COPYING file)
#---

use Net::Dict;
use Net::Domain;

##
# Read CGI input(s)
sub readform
{
    my $input		= '';
    my %in		= ();
    my $uploaded_file	= '';

    # Dealing with a file upload ?
    if ( defined($ENV{'CONTENT_TYPE'}) &&
	 $ENV{'CONTENT_TYPE'} =~ m|^multipart/form-data| )
    {
	binmode (STDIN);
	read (STDIN, $input, $ENV{'CONTENT_LENGTH'});
	my @intype	= split (/-----------------------------.{9}/, $input);

	for($i=1; $i<=$#intype; $i++)
	{
	    my(
	       @lines,
	       $name,
	       $value,
	       $upload_token,
	       $upload_name,
	       $updata,
	      );

	    @lines	= split (/\n/, $intype[$i], 5);

	    # Dealing with "pair" passed-in values
	    if ( $lines[1] =~ /^.*name=\"(.*?)\"/ &&
		 $lines[1] !~ /\";/ )
	    {
		$name        = $1;
		chop($value  = $lines[3]);

		# Un-Webify plus signs and %-encoding
		$value	=~ tr/+/ /;
		$value	=~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$in{$name}	= $value;
	    }

	    # Dealing with passed-in uploaded file
	    if ($lines[1] =~  /^.*name=\"(.*)\".*filename=\"(.*)\"/ )
	    {
		$upload_token	= $1;
		$upload_name	= $2;
		$upload_name	=~ s/^.*\\//;

		if ( $upload_token ne 'upload_fn' )
		{
		    &error("ERROR: Can't complete your request",
			   "Error with upload token type.",
			   1);
		}

		# Uploaded file contents
		$updata		= $lines[4];

		# Print the uploaded file/data
		if ($updata)
		{
		    $uploaded_file = "$upload_path/$upload_name";

		    open (UPLOAD, "> $uploaded_file") or
			&error("ERROR: Can't complete your request",
			       "Open $upload_name failed - $!",
			       1);

		    binmode (UPLOAD);
		    print UPLOAD $updata or
			&error("ERROR: Can't complete your request",
			       "Can't print $upload_name - $!",
			       1);

		    close (UPLOAD) or 
			&error("ERROR: Can't complete your request",
			       "Can't close $upload_name - $!",
			       1);

		    chmod 0666, "$uploaded_file";
		}
		else
		{
		    &error("ERROR: Can't complete your request",
			   "Upload failed completely - $!",
			   1);
		}
	    }
	}
    }
    # Dealing with normal browser transactions (non file-upload)
    else
    {
	($ENV{'REQUEST_METHOD'} eq "POST") and read(STDIN, $input, $ENV{'CONTENT_LENGTH'});
	($ENV{'REQUEST_METHOD'} eq "GET")  and ($input = $ENV{'QUERY_STRING'});
 
	my @pairs	= split(/&/, $input);

	foreach (@pairs)
	{
	    my ($name,
		$value)	= split /=/;

	    # Un-Webify plus signs and %-encoding
	    $value	=~ tr/+/ /;
	    $value	=~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	    $in{$name}	= $value;
	}
    }
    return(\%in, $uploaded_file);
}

##
# Display contents thus far (ie. output what's at hand)
sub display
{
    my $content	= shift;

    my (
#	$kb_script,
	$blk_top,
	$blk_bot
       );

    if ($embed)
    {
	$blk_top = qq|
$kb_script
<tr>
<td width="100%">
<br>
|;
	$blk_bot = qq|
</td>
|;
    }
    else
    {
	$blk_top = qq|
$doctype
<HTML>
  <HEAD>
    $kb_script
    <TITLE>
       $str_main
    </TITLE>
  </HEAD>
  <BODY>
|;
	$blk_bot = qq|
  </BODY>
</HTML>
|;
    }

    print qq]
$blk_top
    <TABLE CLASS="small" CELLSPACING="0" CELLPADDING="0" BORDER="0"
           WIDTH="98%">
      <TBODY>
        <TR>
          <TD ALIGN="center">
             $page_main
          </TD>
          <TD ALIGN="right">
            <a href="$cgi_main?action=do_search_dict">B&uacute;squeda</a>  
          </TD>
        </TR>
        <TR>
          <TD>&nbsp;</TD>
          <TD ALIGN="center">
            <h1> Grupo DICT-ES : <br>
	    Diccionarios abiertos en espa&ntilde;ol</h1>
          </TD>
        </TR>
      </TBODY>
     </TABLE>
     <BR>
];

    # Print what's been passed-in - new stuff :-)
    print $content;

    # Print package's name and link to home-page
    print qq^<div align="center">|
             <a href="$homepage" style="text-decoration:none">
             $myname [$version] </a>|</div><br>^;

    print $blk_bot;

}

##

##
# A function to display both DICT and local.MySQL search forms
sub displaysearchform
{
    my ($doing_dict,
	$ref_caller,
	$ref_in)	= @_;

    my $cgi_caller	= ${$ref_caller};
    my %in		= %{$ref_in};

    my (
	$function,
	$dict,
	%dict_strat,
	$dict_extra,
	$admin_extra,
       );

    if ($doing_dict)
    {
 	$function	= "search_dict";

	# Below was deemed too expensive (and a resource hog)
	# - Commented out
	if (0)
	{
	    # Find out the supported DICT query strategies & list them
	    my $dict = Net::Dict->new(
				      $dictd_host,
				      Port     => 2628,
				      Client   => "$myname [$version]"
				     );
	    %dict_strat = $dict->strategies();

	    foreach my $key (sort keys %dict_strat)
	    {
		if (($key ne "exact") && ($key ne "substring"))
		{
		    $dict_extra  .= qq|
 <option value="$key">$dict_strat{$key}</option>
 |;
		}
	    }
	}
    }
    else
    {
	$function	= "search_local";
    }

    my $form	= qq|
<form action="$cgi_caller" method="POST">
<input type="hidden" name="action" value="$function">
<input type="hidden" name="dictd_num" value="$in{'dictd_num'}">
$admin_extra
<table border="0">
<tr>
  <td><b>Buscar:</b></td>
  <td><input type="text" onfocus="cur_obj=this;" name="query"
       value="$in{'query'}">
  </td>
  <td>&nbsp;</td>
  <td>
  <select name="type">
    <option value="exact">Palabra Exacta</option>
    <option value="any">Cualquier Ocurrencia</option>
    $dict_extra
  </select>
  </td>
</tr>
|;

    if (!$doing_dict)
    {
	$form .= qq|
<tr>
  <td>Search in:</td>
  <td><input type="checkbox" name="E" value="1" checked>&nbsp;English terms</td>
  <td><input type="checkbox" name="D" value="1">&nbsp;Description</td>
</tr>
|;
    }

    $form .= qq|
<tr>
  <td>
    <input type="reset"  value="Limpiar">
    <input type="submit" value="Enviar b&uacute;squeda">
  </td>
</tr>
</table>
</form>
|;

    return($form);
}

##
# A function to attain the number of terms within the DICT server
sub dictd_term_num
{
    my ($dictd_terms,
	$ref_caller)	= @_;

    my $cgi_caller	= ${$ref_caller};

    my (
	$frmdomain,
	$frm,
	$dict,
	%dict_description,
	$db,
	$dbinfo,
	@info_lines,
	$info_line,
	$dictd_nums,
       );

    if ($dictd_terms)
    {
	return($dictd_terms);
    }
    else
    {
	if ($frmdomain = &Net::Domain::hostdomain())
	{
	    $frm = "($frmdomain)";
	}

	$dict	= Net::Dict->new(
				 $dictd_host,
				 Port     => 2628,
				 Client   => "$myname [$version] $frm"
				);

	# Make sure we have a dictd connection to proceed with
	if (!$dict)
	{
		&error("Imposible acceder a la base de datos dict (servidor abajo)
                     <br><br>
                     Por favor intente m&aacute;s tarde...");
	   
	}

	# Get a description from all dictionaries
	%dict_description	= $dict->dbs();

	# Get the number of dictd terms in the database
	foreach $db (keys %dict_description)
	{
	    $dbinfo	= $dict->dbInfo($db);
	    @info_lines	= split(/\n/, $dbinfo);
	    foreach $info_line (@info_lines)
	    {
		if ($info_line =~ /^NOTE:\s+\D+contiene\s(\d+)\sterms/)
		{
		    $dictd_terms += $1;
		}
	    }
	}

	# Mangle number for readability
	$dictd_nums	= reverse $dictd_terms;
	$dictd_nums	=~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
	$dictd_nums	= reverse $dictd_nums;

	return($dictd_nums);
    }
}

##
# A means to query the DICT server
sub search_dict
{
    my ($ref_caller,
	$ref_in)	= @_;

    my $cgi_caller	= ${$ref_caller};
    my %in		= %{$ref_in};

    my (
	$frmdomain,
	$frm,
	$dict,
	%dict_description,
	%dict_strategies,
	$dict_strat,
	$ref_match,
	$ref_entry,
	$out_db,
	$out_word,
	$ref_word,
	$dict_result_num,
	%assoc_show,
	$content,
	$num,
	$prev_db,
	$key,
	$ref_duple,
	$def,
	$out,
	@out_multi,
	$i,
	$heading,
       );

    if ( $in{'query'} eq "" )
    {
	 &error("ERROR: Se debe introducir un t&eacute;rmino de b&uacute;queda");
    }

    if ($frmdomain = &Net::Domain::hostdomain())
    {
	$frm = "($frmdomain)";
    }

    $dict	= Net::Dict->new(
    				 $dictd_host,
    				 Port     => 2628,
    				 Client   => "$myname [$version] $frm"
				);

     # Make sure we have a dictd connection to proceed with
     if (!$dict)
     {
 	    &error("Imposible acceder a la base de datos dict (servidor abajo)
                    <br><br>
                    Por favor intente m&aacute;s tarde...");
     }

     # Get a description from all dictionaries
     my %dict_description	= $dict->dbs();

    # Get rid of any preceding/trailing spaces
    $in{'query'} =~ s/^\s*(.*\S)\s*$/$1/;

    if ( $in{'type'} ne "exact" )
    {
	# Possible 'match' strategies,
	# - re, regexp, lev, soundex, exact, word, substring, prefix, suffix
	%dict_strategies	= $dict->strategies();

	# For matches, precedence order should be
	# - substring
	# - re
	# - regexp
      CASE_STRAT:
	{
	    # See which ones are available if any
	    if ($dict_strategies{"substring"})
	    {
		$dict_strat = "substring";
		last CASE_STRAT;
	    }
	    if ($dict_strategies{"re"})
	    {
		$dict_strat = "re";
		last CASE_STRAT;
	    }
	    if ($dict_strategies{"regexp"})
	    {
		$dict_strat = "regexp";
		last CASE_STRAT;
	    }
	    # None were found
	    $dict_strat = "exact";
	}

	# NOTE: each '->define' and '->match' method call returns
	#       an array reference to a bunch of arrays.
	$ref_match	= $dict->match($in{'query'}, $dict_strat);
#	$ref_match	= $dict->match($in{'query'}, $in{'type'});

	foreach $ref_entry (@{$ref_match})
	{
	    ($out_db,
	     $out_word)			= @{ $ref_entry };
	    my $ref_word		= $dict->define($out_word);
	    $dict_result_num	       += $#{$ref_word} + 1;
	    $assoc_show{$out_word}	= $ref_word;
	}

    }
    else
    {
	$ref_word			= $dict->define($in{'query'});
# 	($out_db,
# 	 $out_word)			= @{ $ref_word };
	$dict_result_num		= $#{$ref_word} + 1;
	$assoc_show{$in{'query'}}	= $ref_word;
    }

    if (!$dict_result_num)
    {
 	$content = "<hr>" . &displaysearchform(1, \$cgi_caller, \%in);

	$content .= &do_spell_check(\$cgi_caller, \%in);

	&error("Lo siento, el t&eacute;rmino buscado NO se encontr&oacute;", $content);
	
    }

    $content    .= qq|
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
<b>Found $dict_result_num result(s):</b>
<tr><td>&nbsp;</td></tr>
|;
    $num	= 0;
    $prev_db	= '';
    foreach $key (keys %assoc_show)
    {
	foreach $ref_duple ( @{$assoc_show{$key}})
	{
	    $num++;
	    ($db,
	     $def)	= @{ $ref_duple };

	    if ($db ne $prev_db)
	    {
		$content       .= qq|
<tr><td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td align="left"><i>De '$db' ($dict_description{$db})</i></td>
</tr>
<tr><td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
|;
		$prev_db	= $db;
	    }
	    $out	= $def;
	    $out	=~ s/^$key\s*//i;
	    $out	=~ s/[\n]*$//i;

	    # The '::' is a translation delimiter (for multi-translations)
            @out_multi	= split (/\s*\:\:\s*/, $out);

	    $content	.= qq|
<tr><td align="left">$num.</td>
    <td align="left"><font color="Red">$key</font></td></tr>
|;

        # Print-out multiple translations (there is at a min a single (0) term)
	for($i=0; $i<=$#out_multi; $i++)
	{
	    $content	.= qq|
<tr><td></td>
    <td align="left"><font color="black"> $out_multi[$i]</font>
    </td></tr>
|;
	}
	    $content	.= qq|
<tr><td>&nbsp;</td></tr>
|;
	}
    }

    undef(%assoc_show);
    $content	.= "</table>&nbsp;<br><hr>";
    $content	.= &displaysearchform(1, \$cgi_caller, \%in);
    &display($content);
}

##
# Do a spellcheck if no results were present
sub do_spell_check
{
    my ($ref_caller,
	$ref_in)	= @_;

    my $cgi_caller	= ${$ref_caller};
    my %in		= %{$ref_in};

    my (
	$term,
	$option,
	$out,
	$content,
	@lines,
	$line,
	@term_sug,
	@sug,
	$suggest,
	%suggestions,
	$key,
       );

    # Although this is not a proper way to untaint things,
    # this is 100% safe, as I'm simply echo'ing the variable
    $term = $in{'query'};
    $term =~ /(.*)/;
    $term = $1;

    $option	= "-a";

    if (-e $ASPELL)
    {
	$out	= `echo $term | $ASPELL $option`;
    }
    else
    {
	return();
    }

    # See if the spell-checker produced any output
    @have_sug	= split(/\:/, $out);

    if ($have_sug[1])
    {
	$content = "Correctly spelled <b>sugerencias</b>: <br><br>";

	$content .= qq|
<form action="$cgi_caller" method="POST">
  <input type="hidden" name="action" value="search_dict">
  <input type="hidden" name="my_email"  value="$in{'my_email'}">
  <input type="hidden" name="my_priv"   value="$in{'my_priv'}">
  <input type="hidden" name="dictd_num" value="$in{'dictd_num'}">
  <input type="hidden" name="type"      value="exact">
  <select name="query">
|;

	# Process spell-checker's output line-by-line
	@lines	= split(/\n/, $out);

	foreach $line (@lines)
	{
	    if ($line =~ /\:/)
	    {
		@term_sug	= split(/\:\s*/, $line);
		@sug		= split(/\,\s*/, $term_sug[1]);

		# Grab all the unique suggestions (skip multiples)
		foreach $suggest (@sug)
		{
		    $suggestions{uc($suggest)} = $suggest;
		}
		
		# Dump out the suggestions
		foreach $key (sort keys %suggestions)
		{
		    $content .= qq|
    <option value="$suggestions{$key}">$suggestions{$key}</option>
|;
		}
	    }
	}

	$content .= qq|
  </select>
  <input type="submit" value="Submit">
</form>
|;
    }

    return($content);
}



##
# Check validity of UTF-8 input
sub bad_utf8
{
    use utf8;

    my ($utf8_str)	= @_;

    my %ascii_allowed	= (
			   0x09 => 1,		# ASCII - tab
			   0x20 => 1,		# ASCII - space
			   0x21 => 1,		# ASCII - !
			   0x22 => 1,		# ASCII - "
			   0x23 => 1,		# ASCII - #
			   0x24 => 1,		# ASCII - $
			   0x25 => 1,		# ASCII - %
			   0x26 => 1,		# ASCII - &
			   0x27 => 1,		# ASCII - '
			   0x28 => 1,		# ASCII - (
			   0x29 => 1,		# ASCII - )
			   0x2A => 1,		# ASCII - *
			   0x2B => 1,		# ASCII - +
			   0x2C => 1,		# ASCII - ,
			   0x2D => 1,		# ASCII - -
			   0x2E => 1,		# ASCII - .
			   0x2F => 1,		# ASCII - /
	                   0x30 => 1,		# ASCII - 0
	                   0x31 => 1,		# ASCII - 1
	                   0x32 => 1,		# ASCII - 2
	                   0x33 => 1,		# ASCII - 3
	                   0x34 => 1,		# ASCII - 4
	                   0x35 => 1,		# ASCII - 5
	                   0x36 => 1,		# ASCII - 6
	                   0x37 => 1,		# ASCII - 7
	                   0x38 => 1,		# ASCII - 8
	                   0x39 => 1,		# ASCII - 9
			   0x3A => 1,		# ASCII - :
			   0x3B => 1,		# ASCII - ;
			   0x3C => 1,		# ASCII - <
			   0x3D => 1,		# ASCII - =
			   0x3E => 1,		# ASCII - >
			   0x3F => 1,		# ASCII - ?
			   0x40 => 1,		# ASCII - @
			   0x5B => 1,		# ASCII - [ 
			   0x5C => 1,		# ASCII - \ 
			   0x5D => 1,		# ASCII - ]
			   0x5E => 1,		# ASCII - ^
			   0x5F => 1,		# ASCII - _ 
			   0x60 => 1,		# ASCII - `
			   0x27 => 1,           # ASSCI - '
			   0x7B => 1,		# ASCII - {
			   0x7C => 1,		# ASCII - | 
			   0x7D => 1,		# ASCII - } 
			   0x7E => 1,		# ASCII - ~ 
			   0xF1 => 1,		# ASCII - ñ
			   0xD1	=> 1,		# ASCII - Ñ
			  );

    # Restrict STDERR a bit
    # - Avoid mysterious "Malformed UTF-8" messages;
    #   after all we're trying to catch 'em
    open (STDERR, ">/dev/null");

    my @chars		= split(//, $utf8_str);

    my $not_utf8	= 0;

    foreach $one_char (@chars)
    {
       my $hex_char	= unpack("U", $one_char);
       if (! ($ascii_allowed{$hex_char} || ($hex_char >= 0x80)) )
       {
         $not_utf8	= 1;
       }
    }
    # Go back to normal with STDERR :-)
    close (STDERR);
    open STDERR, ">&STDOUT";

    return ($not_utf8);
}

##
# Print the appropriate html header
sub do_html_header
{
    # Passing-in a non-ZERO disables the printing of the header
    my ($disable_print)	= @_;

    if (! $disable_print) { print $header; }

    if ($embed)
    {
	&display_file($title_admin, $file_header);
    }
}

##
# Non-Admin's Error printing
sub error
{
    my ($error,
	$reason,
	$do_header)	= @_;

    if ( $do_header )
    { &do_html_header(); }

    &display("<center><b>$error</b><br>$reason</center><br>");

    # Site specific embedding
    if ($embed)
    {
	&display_file(0, $file_right);
	&display_file(0, $file_footer);
    }

    exit(1);
}

##
# Sanitize things for the browsers
sub unhtml
{
    my $text	= shift;

    $text	=~ s/<!--(.|\n)*-->//g;
    $text	=~ s/<script>/\&lt;script\&gt;/g;
    $text	=~ s/\&/\&amp;/g;
    $text	=~ s/\"/\&quot;/g;
    $text	=~ s/  / \&nbsp;/g;
    $text	=~ s/</\&lt;/g;
    $text	=~ s/>/\&gt;/g;
    $text	=~ s/\|/\&#0124;/g;
    return($text);
}

1;    # for require (if any)
