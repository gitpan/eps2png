#!/usr/bin/perl
# $Id: eps2png.t,v 1.2 2008/03/27 15:03:54 jv Exp $

use Test::More;
plan tests => 5;

require_ok "t/basic.pl";

SKIP: {
    skip "GhostScript (gs) not available", 4
      unless findbin("gs");
    testit("png");
}
