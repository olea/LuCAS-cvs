#!/usr/bin/perl
# Uses a .version file to hold the minor version, the minor version is only
# incremented if asked for.  Generates latex output which gives the book version.
#
# david.rusling@digital.com

use Getopt::Long;
use DB_File ;
use Fcntl ;
use FileHandle ;

#
# print some help
#
sub printHelp {
    print "\nVersion [1.0]\n\n" ;
    print "This tool generates a version string\n\n" ;
    print "--help, -h\t\t: print this help\n" ;
    print "--increment, -i\t\t: increment the minor version\n" ;
    print "\nWritten in perl by david.rusling\@digital.com\n" ;
}

# Figure out the arguments
$help = 0;
$increment = 0;
&GetOptions(
	    "help" => \$help, "h" => \$help,
	    "increment" => \$increment, "i" => \$increment, 
	    ) ;

# initialise some variables
$phase = "REVIEW";
$major = "0.8";

# now go and do stuff depending on the arguments
if ($help) {
    printHelp() ;
    exit 0 ;
}

# If there is already a version file, read the version from there.
if (! -f ".version") {
# We need to create the .version file
#
    $increment = 1;
    $minor = 1;
} else {
# Figure out the current version (and leave the file open in case we
# have to auto increment the version string
    sysopen VERSIONFILE, ".version", O_RDWR|O_CREAT, 0622
	or die "Couldn't open .version: $!\n";
    sysread VERSIONFILE, $minor, 80;
    chop $minor;
    
# If we need to, auto increment it
    if ($increment) {
	$minor = int $minor + 1;
    }

# close it
    close VERSIONFILE;
}

# recreate the version file, if we have to
if ($increment) {
    if (-f ".version") {
# finally, delete it
	unlink ".version";
    }
    sysopen VERSIONFILE, ".version", O_RDWR|O_CREAT, 0622
	or die "Couldn't open .version: $!\n";
    print VERSIONFILE "$minor\n";
    close VERSIONFILE;
}

# Generate latex in version.tex
if (-f "version.tex") {
    unlink "version.tex";
}
sysopen LATEXFILE, "version.tex", O_RDWR|O_CREAT, 0622
    or die "Couldn't open version.tex: $!\n";
print LATEXFILE "\\def\\bookversion{$phase, Version $major-$minor}\n" ;
close LATEXFILE;

