# Makefile.PL -- Makefile for eps2png
# Author          : Johan Vromans
# Created On      : Sat Jun  6 16:08:33 1998
# Last Modified By: Johan Vromans
# Last Modified On: Sat Jun 23 12:48:57 2001
# Update Count    : 25
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
   VERSION_FROM => "script/$scripts[0]",
   ($] >= 5.005) ?
   ( AUTHOR	=> 'Johan Vromans (jvromans@squirrel.nl)',
     ABSTRACT	=> 'Convert EPS files to PNG, JPG or GIF' ) : (),
   PREREQ_PM	=> { 'Getopt::Long' => 2.1 },
   EXE_FILES    => [ map { "script/$_" } @scripts ],
 );
