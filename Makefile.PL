# Makefile.PL -- Makefile for eps2png
# Author          : Johan Vromans
# Created On      : Sat Jun  6 16:08:33 1998
# Last Modified By: Johan Vromans
# Last Modified On: Sun Jun  7 13:52:50 1998
# Update Count    : 10
# Status          : Released

use ExtUtils::MakeMaker;

my @scripts = qw (eps2png);

# Wrap commands to combine a .pl and .pod into a .PL file.
my $wrap = join (';', 
		 map ("cat PLheader.pl $_.pl $_.pod PLtrailer.pl > $_.PL",  
		      @scripts));

WriteMakefile
  (
	NAME         => "$scripts[0]",
	VERSION      => "1.4",
	dist         => { PREOP    => "$wrap",
			  COMPRESS => "gzip",
			  SUFFIX   => "gz",
			},
	EXE_FILES    => \@scripts,
 );

              
