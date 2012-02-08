package Langxr::Lingua;

use namespace::autoclean;
use Moose;

use Carp qw(croak);
use Class::Load qw(load_class);
use Langxr::Model::File;
use Path::Class;

sub parse_fh {
    my ($self, $fh, $path) = @_;    

    # Strip directory and volume information if any since we only want the actual filename
    my $name = file($path)->basename;
    
    my $parser = _parser_for_file($path)->new();
    
    my $file_node = Langxr::Model::File->new({ name => $name });
    
    my $source = do { local $/; <$fh>; };
    $parser->parse($source, $file_node);
    
    return $file_node;
}

{
    my %Extension;

    # Load extension map
    open my $in, "<", "share/extension-map" or die "Can't load extension map: $!";

    while (<$in>) {
        chomp;
        my ($parser, @exts) = split /\s+/, $_;
        $parser =~ tr/-/_/;
        $Extension{$_} = "Langxr::Lingua::${parser}" for @exts;
    }

    close $in;

    sub _parser_for_file {
        my $path = shift;

        my ($ext) = $path =~ /.*\.(.*)$/;

        my $parser;
        
        if ($ext) {
            # If extension is empty it probably hasn't been loaded                        
            croak "Can't find parser that handles '.${ext}'" unless exists $Extension{$ext};
            
            $parser = $Extension{$ext};
        }
        else {
            ...;
        }
        
        load_class $parser;

        return $parser;
    }
}

1;