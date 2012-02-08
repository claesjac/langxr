#!/usr/bin/env perl

use Test::Most qw(no_plan);

use Langxr::Lingua;

my $model = Langxr::Lingua->parse_fh(\*DATA, __FILE__);
isa_ok $model, "Langxr::Model::File";
is $model->name, '02-moose.t';

__DATA__
package Foo;

use Moose;

has "foo" => (is => "rw");

1;