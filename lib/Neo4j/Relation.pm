package Neo4j::Relation;

use Moose;

has "id" => (is => "ro", isa => "Int");
has "from" => (is => "ro", isa => "Int");
has "to" => (is => "ro", isa => "Int");
has "data" => (is => "ro", isa => "HashRef");


sub new_from_json {
    my ($pkg, $json) = @_;
    
    my ($id) = $json->{self} =~ m{relationship/(\d+)$};    
    my ($from) = $json->{start} =~ m{node/(\d+)$};    
    my ($to) = $json->{end} =~ m{node/(\d+)$};    

    my $type = $json->{type};
    
    $pkg = type_to_pkg($type) || $pkg;
    
    return $pkg->new({ 
        id      => $id,
        from    => $from,
        to      => $to,
        data    => $json->{data},
        type    => $type
    });
}

{
    my %Types;
    my %Packages;
    
    sub bind_type {
        my ($type, $pkg) = @_;
        $Types{lc $type} = $pkg;
        $Packages{$pkg} = $type;
    }

    sub type_to_pkg {
        my $type = pop;
        return $Types{lc $type};
    }
    
    sub pkg_to_type {
        my $pkg = pop;
        return $Packages{$pkg};
    }
}

1;

