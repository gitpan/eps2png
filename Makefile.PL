# Makefile.PL -- Makefile for eps2png
# Author          : Johan Vromans
# Created On      : Sat Jun  6 16:08:33 1998
# Last Modified By: Johan Vromans
# Last Modified On: Thu Mar 27 16:21:55 2008
# Update Count    : 51
# Status          : Released

use strict;
use warnings;
use Config;
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

IMPORTANT: This program requires Ghostscript and may require the
Portable Bitmap package (PBM) for additional conversions.

IMPORTANT: Due to ongoing development of the Ghostscript output
drivers, some tests may fail. See README for details.

EOD

$ENV{LC_ALL} = "C";
my $gs = `gs --help`;
unless ( $gs =~ /^available devices:/im ) {
    warn("Ghostscript not found. Cannot continue\n");
    exit 0;
}

foreach my $type ( qw(pngmono pnggray png16 png256 pngalpha jpeggray) ) {
    next if $gs =~ / $type( |$)/m;
    warn("No Ghostscript driver for $type. You won't be able to use these.\n");
}
foreach my $type ( qw(png16m jpeg) ) {
    next if $gs =~ / $type( |$)/m;
    warn("No Ghostscript driver for $type. Some tests will fail.\n");
}
my $needpbm = 0;
foreach my $type ( qw(gif gifmono) ) {
    next if $gs =~ / $type( |$)/m;
    warn("No Ghostscript driver for $type. PBM fallback required.\n");
    $needpbm = 1;
}

my $x =
WriteMakefile
  (
   NAME         => "$scripts[0]",
   VERSION_FROM => "src/$scripts[0].pl",
   ($] >= 5.005) ?
   ( AUTHOR	=> 'Johan Vromans (jvromans@squirrel.nl)',
     ABSTRACT	=> 'Convert EPS files to PNG, JPG or GIF' ) : (),
   PREREQ_PM	=> { 'Getopt::Long' => 2.1 },
   EXE_FILES    => [ map { "script/$_" } @scripts ],
 );

warn("Creating script\n");
open(my $src, "<", "src/eps2png.pl")
  or die("src/eps2png.pl: $!\n");
open(my $dst, ">", "script/eps2png")
  or die("script/eps2png: $!\n");

while ( <$src> ) {
    s/my \$use_pbm = .;/my \$use_pbm = $needpbm;/;
    print { $dst } $_;
}

close($dst);
close($src);

WriteSpecfile($x->{NAME}, $x->{VERSION});

1;

sub WriteSpecfile {
    my $name    = shift;
    my $version = shift;

    vcopy( _tag	    => "RPM spec file",
	   _dst	    => "$name.spec",
	   pkgname  => $name,
	   version  => $version,
	 );
}

sub vcopy {
    my (%ctrl) = @_;

    $ctrl{_src} ||= $ctrl{_dst} . ".in";

    return unless open(my $fh, "<", $ctrl{_src});

    print("Writing ", $ctrl{_tag}, "...\n") if $ctrl{_tag};

    my $newfh;
    open ($newfh, ">", $ctrl{_dst})
      or die($ctrl{_dst}, ": $!\n");

    my $pat = "(";
    foreach ( grep { ! /^_/ } keys(%ctrl) ) {
	$pat .= quotemeta($_) . "|";
    }
    chop($pat);
    $pat .= ")";

    $pat = qr/\[\%\s+$pat\s+\%\]/;

    while ( <$fh> ) {
	s/$pat/$ctrl{$1}/ge;
	print { $newfh } $_;
    }
    close($newfh);
}
