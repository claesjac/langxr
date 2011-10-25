package Langxr::Model::File;

use namespace::autoclean;
use Moose;

extends 'Langxr::Model::Entity';

has 'name' => (is => 'ro', isa => 'Str');

1;
__END__
