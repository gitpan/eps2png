#!/usr/bin/perl
# $Id: eps2gif.t,v 1.1 2001-06-23 12:45:18+02 jv Exp $

print "1..5\n";

eval { require "t/basic.pl"; };
print "$@\nnot ok 1\n" if $@;

testit ("gif");
