#!/usr/bin/perl
# $Id: basic.pl,v 1.1 2001-06-23 12:44:59+02 jv Exp $

print "1..21\n";

print "ok 1\n";

my $t1 = 2;

testit ("x0-120.png",    "-width", 120);
testit ("x0-120.png",    "-height", 120);
testit ("x0-80-120.png", "-width", 80, "-height", 120);
testit ("x0-15.png",	 "-scale", 1.5);
testit ("x0-81.png",	 "-resolution", 80);

sub testit {
    my $out = "t/x0.out";
    my $ref = "t/".shift;

    @ARGV = ( @_, "-png", "-output", $out, "t/x0.eps" );
    delete $INC{"blib/script/eps2png"};
    eval "package t$t1; require \"blib/script/eps2png\"";
    print "$@\nnot " if $@;
    print "ok $t1\n"; $t1++;

    print "not " unless -s $out;
    print "ok $t1\n"; $t1++;
    print (-s $out, " <> ", -s $ref, "\nnot ") unless -s $out == -s $ref;
    print "ok $t1\n"; $t1++;

    if ( differ($ref, $out) ) {
	print "not ok $t1\n"; $t1++;
    }
    else {
	print "ok $t1\n"; $t1++;
	unlink $out;
    }
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
