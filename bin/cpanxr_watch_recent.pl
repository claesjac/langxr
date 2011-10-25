#!//usr/bin/env perl

use 5.014;
use warnings;

use HTTP::Tiny;
use JSON qw(decode_json);

my $res = HTTP::Tiny->new->get("http://api.metacpan.org/release/_search?size=100&sort=date:desc");

die "Failed to get latest releases" unless $res->{success};

my $data = decode_json($res->{content});

my @archives;
for my $hit (@{$data->{hits}->{hits}}) {
    my $entry = $hit->{_source};
    
    push @archives, { 
        name => $entry->{name}, 
        download_url => $entry->{download_url},
    };
}