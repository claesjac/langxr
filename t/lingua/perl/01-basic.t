#!/usr/bin/env perl

use Test::Most tests => 3;

BEGIN { use_ok("Langxr::Lingua::Perl"); }

use Langxr::Lingua;

my $model = Langxr::Lingua->parse_fh(\*DATA, __FILE__);
isa_ok $model, "Langxr::Model::File";
is $model->name, '01-basic.t';

__DATA__
package Foo;