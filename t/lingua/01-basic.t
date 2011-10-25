#!/usr/bin/env perl

use Test::Most tests => 2;

BEGIN { use_ok("Langxr::Lingua"); }

is Langxr::Lingua::_parser_for_file('01-basic.t'), 'Langxr::Lingua::Perl';