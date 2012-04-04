# Convert a date into a time.
# By Lee McLoughlin <lmjm@doc.ic.ac.uk>
#  You can do what you like with this except claim that you wrote it or
#  give copies with changes not approved by Lee.  Neither Lee nor any other
#  organisation can be held liable for any problems caused by the use or
#  storage of this package.
# $Id: dateconv.pl,v 1.1.1.1 2000/07/10 17:49:08 jjamor Exp $
# $Log: dateconv.pl,v $
# Revision 1.1.1.1  2000/07/10 17:49:08  jjamor
# Importando LuCAS en nuevo servidor CVS
#
# Revision 1.1.1.1  2000/04/08 19:12:33  olea
# Importando LuCAS que te cagas...
#
# Revision 2.4  1994/06/10  18:28:24  lmjm
# Added a CMS format, from Andrew.
#
# Revision 2.3  1994/01/28  17:58:21  lmjm
# Added parsing of CTAN (tex archive) dates an the two common HTTP dates.
#
# Revision 2.2  1993/12/14  11:09:05  lmjm
# Correct order of packages.
# Make sure use_timelocal defined.
#
# Revision 2.1  1993/06/28  15:04:22  lmjm
# Full 2.1 release
#

# input date and time string from ftp "ls -l" format ("Feb 01 13:25"),
# return data and time string in Unix format "dd Mmm YY HH:MM", "such as
# "1 Feb 92 13:25"
sub lstime_to_standard
{
	local( $ls ) = @_;

	return &time_to_standard( &lstime_to_time( $ls ) );
}


require 'timelocal.pl';
package dateconv;

# Use timelocal rather than gmtime.
$use_timelocal = 1;

@months = ( "zero", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" );

$month_num{ "jan" } = 0;
$month_num{ "feb" } = 1;
$month_num{ "mar" } = 2;
$month_num{ "apr" } = 3;
$month_num{ "may" } = 4;
$month_num{ "jun" } = 5;
$month_num{ "jul" } = 6;
$month_num{ "aug" } = 7;
$month_num{ "sep" } = 8;
$month_num{ "oct" } = 9;
$month_num{ "nov" } = 10;
$month_num{ "dec" } = 11;

( $mn, $yr ) = (localtime)[ 4, 5 ];


# input date and time string from ftp "ls -l", such as Mmm dd yyyy or
# Mmm dd HH:MM,
# return $time number via gmlocal( $string ).
sub main'lstime_to_time
{
	package dateconv;

	local( $date ) = @_;

	local( $mon, $day, $hours, $mins, $month, $year );
	local( $secs ) = 0;

	# Unix ls, dls and Netware
	if( $date =~ /^(\w\w\w)\s+(\d+)\s+((\d\d\d\d)|((\d+):(\d+)))$/ ){
		($mon, $day, $year, $hours, $mins) = ($1, $2, $4, $6, $7);
	}
	elsif( $date =~ /^(\d+)\s+(\w\w\w)\s+((\d\d\d\d)|((\d+):(\d+)))$/ ){
		($day, $mon, $year, $hours, $mins) = ($1, $2, $4, $6, $7);
	}
	elsif( $date =~ /^(\w\w\w)\s+(\d+)\s+(\d\d)\s+(\d+):(\d+)$/ ){
		($mon, $day, $year, $hours, $mins) = ($1, $2, $3, $4, $5);
	}
	# VMS, Supertcp, DOS style
	elsif( $date =~ /(\d+)-(\S+)-(\d+)\s+(\d+):(\d+)/ ){
		($day, $mon, $year, $hours, $mins) = ($1, $2, $3, $4, $5);
	}
	# CTAN style (and HTTP)
	elsif( $date =~ /^\w+\s+(\w+)\s+(\d+)\s+(\d+):(\d+):(\d+)\s+(\d+)/ ){
		($mon, $day, $hours, $mins, $secs, $year ) =
			($1, $2, $3, $4, $5, $6);
	}
	# another HTTP
        elsif( $date =~ /^\w+,\s+(\d+)-(\w+)-(\d+)\s+(\d+):(\d+):(\d+)/ ){
                ($day, $mon, $year, $hours, $mins, $secs ) =
                        ($1, $2, $3, $4, $5, $6);
        }
	else {
		printf STDERR "invalid date $date\n";
		return time;
	}
	
	if( $mon =~ /^\d+$/ ){
		$month = $mon - 1;
	}
	else {
		$mon =~ tr/A-Z/a-z/;
		$month = $month_num{ $mon };
	}

	if( $year !~ /\d\d\d\d/ ){
		$year = $yr;
		$year-- if( $month > $mn );
	}
	if( $year > 1900 ){
		$year -= 1900;
	}
	 
		$x = &'timelocal( $secs, $mins, $hours, $day, $month, $year );
	if( $use_timelocal ){
		return &'timelocal( $secs, $mins, $hours, $day, $month, $year );
	}
	else {
		return &'timegm( $secs, $mins, $hours, $day, $month, $year );
	}
}

# input time number, output GMT string as "dd Mmm YY HH:MM"
sub main'time_to_standard
{
	package dateconv;

	local( $time ) = @_;

	local( $sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst ) =
		 gmtime( $time );
	return sprintf( "%2d $months[ $mon + 1 ] %2d %02d:%02d", $mday, $year, $hour, $min );
}
