# Makefile.PL -- Makefile for eps2png
# Author          : Johan Vromans
# Created On      : Sat Jun  6 16:08:33 1998
# Last Modified By: Johan Vromans
# Last Modified On: Thu Jul 13 18:48:56 2000
# Update Count    : 19
# Status          : Released

use ExtUtils::MakeMaker;

my @scripts = qw (eps2png);
my $usrbin = "/usr/bin";
my $installscript = $Config{installscript};

print STDERR <<EOD unless $installscript eq $usrbin;

WARNING: This Makefile will install user accessible scripts.
The location for these scripts is $installscript.
You may consider to pass INSTALLSCRIPT=$usrbin (or some other
convenient location) to "make install".
EOD

print STDERR <<EOD;

IMPORTANT: This program requires ghostscript and may require the
Portable Bitmap package (PBM) for additional conversions.

EOD

WriteMakefile
  (
   NAME         => "$scripts[0]",
   VERSION      => "1.7",
   ($] >= 5.005) ?
   ( AUTHOR	=> 'Johan Vromans (jvromans@squirrel.nl)',
     ABSTRACT	=> 'Modules to get info for/from PostScript fonts' ) : (),
   PREREQ_PM	=> { 'Getopt::Long' => 2.1 },
   EXE_FILES    => [ map { "script/$_" } @scripts ],
 );
