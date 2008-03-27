#!/usr/bin/perl
# $Id: extra.t,v 1.2 2008/03/27 15:03:54 jv Exp $

use Test::More;
plan tests => 5 * 4;

testit ("x0-120.png",    "-width",      120);
testit ("x0-120.png",    "-height",     120);
testit ("x0-80-120.png", "-width",      80, "-height", 120);
testit ("x0-15.png",	 "-scale",      1.5);
testit ("x0-81.png",	 "-resolution", 80);

my $t = 0;

sub testit {
    my $out = "t/x0.out";
    my $ref = "t/".shift;

    unlink($out);
    @ARGV = ( @_, "-png", "-output", $out, "t/x0.eps" );
    delete $INC{"blib/script/eps2png"};
    $t++;
    eval "package t$t; require \"blib/script/eps2png\"";
    ok(!$@, "eval: $@");

    ok(-s $out, "created: $out");
    is(-s $out, -s $ref, "size check");

    ok(!differ($ref, $out), "content check");
}

sub differ {
    # Perl version of the 'cmp' program.
    # Returns 1 if the files differ, 0 if the contents are equal.
    my ($old, $new) = @_;
    unless ( open (F1, $old) ) {
	print STDERR ("$old: $!\n");
	return 1;
    }
    unless ( open (F2, $new) ) {
	print STDERR ("$new: $!\n");
	return 1;
    }
    my ($buf1, $buf2);
    my ($len1, $len2);
    while ( 1 ) {
	$len1 = sysread (F1, $buf1, 10240);
	$len2 = sysread (F2, $buf2, 10240);
	return 0 if $len1 == $len2 && $len1 == 0;
	return 1 if $len1 != $len2 || ( $len1 && $buf1 ne $buf2 );
    }
}

1;
