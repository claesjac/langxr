package Neo4j::Client;

use 5.014;
use warnings;

use Carp qw(croak);
use Neo4j::Node;
use Neo4j::Relation;
use Net::HTTP::Spore;
use Params::Classify qw(is_ref is_blessed);

my $NODE_REF_FMT = "";

{
    my $client;

    sub connect {
        my ($pkg, $base_url) = @_;            
        $client and croak "Already connected";
        $base_url .= "/" unless substr($base_url, -1, 1) eq "/";
        
        $client = Net::HTTP::Spore->new_from_spec("share/neo4j.json", base_url => $base_url);    
        $client->enable("Format::JSON");

        $NODE_REF_FMT = $base_url . "node/%d";
        
        return $pkg;
    }
    
    sub client {
        $client or croak "Not connected";
        return $client;
    }
}

sub get_service_root {
    client->get_service_root->body;
}

sub create_node {
    my ($self, $attrs) = @_;
    $attrs = {} unless is_ref($attrs, "HASH");
    return Neo4j::Node->new_from_json(client->create_node(payload => $attrs)->body);
}

sub get_node {
    my ($self, $id) = @_;
    my $response = client->get_node(id => $id);

    # This means there's no such node
    return if $response->status == 404;
    
    return Neo4j::Node->new_from_json($response->body);
}

sub delete_node {
    my ($self, $id) = @_;
    
    my $response = client->delete_node(id => $id);

    croak "No such node" if $response->status == 404;
    croak $response->body->{message} if $response->status == 409;
    
    1;
}

sub create_relation {
    my ($self, $type, $from, $to, $data) = @_;
    
    $from = $from->id if is_blessed $from, "Neo4j::Node";
    $to   = $to->id    if is_blessed $to, "Neo4j::Node";
    
    $to = sprintf $NODE_REF_FMT, $to;
    
    $type = Neo4j::Relation->pkg_to_type($type) || $type;
    
    $data = {} unless is_ref($data, "HASH");
    
    my $response = client->create_relation(from => $from, payload => {
        to => $to, 
        type => $type,
        data => $data,
    });
        
    return Neo4j::Relation->new_from_json($response->body);    
}

1;