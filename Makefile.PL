# Makefile.PL -- Makefile for eps2png
# Author          : Johan Vromans
# Created On      : Sat Jun  6 16:08:33 1998
# Last Modified By: Johan Vromans
# Last Modified On: Sat Jun  6 16:14:16 1998
# Update Count    : 3
# Status          : Released

use ExtUtils::MakeMaker;

my @scripts = qw (eps2png);
my $wrap = join (';', 
		 map ("cat PLheader.pl $_.pl $_.pod PLtrailer.pl > $_.PL",  
		      @scripts));

WriteMakefile
  (
   NAME           => 'eps2png',
   VERSION        => '1.1',
   'dist'         => {
                      PREOP    =>"$wrap",
                      COMPRESS =>"gzip",
                      SUFFIX   =>"gz",
                     },
   'EXE_FILES'    => \@scripts,
 );

              
