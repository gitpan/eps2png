#!/usr/bin/perl
# $Id: basic.pl,v 1.1 2001-06-23 12:44:59+02 jv Exp $

print "ok 1\n";

sub testit {
    my ($type) = @_;
    my $out = "t/x1.out";
    my $ref = "t/x1.$type";

    @ARGV = ( "-$type", "-output", $out, "t/x1.eps" );
    eval { require "blib/script/eps2png"; };
    print "$@\nnot " if $@;
    print "ok 2\n";

    print "not " unless -s $out;
    print "ok 3\n";
    print (-s $out, " <> ", -s $ref, "\nnot ") unless -s $out == -s $ref;
    print "ok 4\n";

    if ( differ($ref, $out) ) {
	print "not ok 5\n";
    }
    else {
	print "ok 5\n";
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
