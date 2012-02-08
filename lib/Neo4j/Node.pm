package Neo4j::Node;

use Moose;

has "id" => ( is => "ro", isa => "Int" );
has "data" => ( is => "ro", isa => "HashRef" );

sub new_from_json {
    my ($pkg, $json) = @_;
    my ($id) = $json->{self} =~ m{node/(\d+)$};    
    return $pkg->new({ id => $id, data => $json->{data} });
}

1;