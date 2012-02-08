#!/usr/bin/perl

use strict;
use warnings;

use Test::More qw(no_plan);
use Test::Fatal;
use Data::Dumper qw(Dumper);

BEGIN { use_ok("Neo4j::Client"); }

my $client = Neo4j::Client->connect("http://localhost:7474/db/data/");
ok($client);

# Service root just contains some info
ok($client->get_service_root());

# Node retrieval and removal
{
    my $node = $client->create_node();
    ok($node);

    ok($client->get_node($node->id));
    
    # Should return undef
    ok(!$client->get_node($node->id + 1));
    
    ok($client->delete_node($node->id));
    
    my $ex = exception { $client->delete_node($node->id); };
    diag $ex;
    like($ex, qr/No such node/, "Node doesn't exist");
}

# Relations
{
    my $n1 = $client->create_node();
    my $n2 = $client->create_node();
    
    $client->create_relation(foo => $n1, $n2);
    
}