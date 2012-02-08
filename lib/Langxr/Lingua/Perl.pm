package Langxr::Lingua::Perl;

use 5.014;
use warnings;

use namespace::clean;

use Moose;
use Module::Find qw(usesub);
use PPI;

# Runs once at loading
{
    my @modules = usesub __PACKAGE__;
    
    for my $module (@modules) {
        if (my $register = $module->can("register")) {
            $register->();
        }
    }
}

sub parse {
    my ($self, $source) = @_;
    
    my $doc = PPI::Document->new(\$source);
    $doc->index_locations();
    
    $self->handle_node($doc);
}

my %Handler = (
    'PPI::Statement::Package' => 'handle_package_decl',
    'PPI::Statement::Include' => 'handle_include_decl',
    'PPI::Statement::Sub'     => 'handle_sub_decl',
);

sub handle_node {
    my ($self, $node) = @_;
    
    for my $child ($node->elements) {
        my $class = $child->class;

        if (my $handler = $Handler{$class}) {
            $self->$handler($child);
        }
        
        if ($child->isa("PPI::Node")) {
            $self->handle_node($child);
        }
    }
}

sub handle_package_decl {
    my ($self, $node) = @_;
    
    my $package = $node->namespace;
    say "Found namespace: $package";
}

sub handle_include_decl { 
    my ($self, $node) = @_;
    
    my $module = $node->module;
    if ($module) {
        say "Found include: $module";
    }
}

sub handle_sub_decl {
    my ($self, $node) = @_;
    
    my $name = $node->name;
    if ($name) {
        say "Found sub: $name";
    }
}

1;
__END__