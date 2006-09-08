package CPANPLUS::Dist::PAR;
use strict;

use vars    qw[@ISA $VERSION];
use base    'CPANPLUS::Dist::Base';

use CPANPLUS::Error;
use File::Basename              qw[basename];
use Params::Check               qw[check];
use Module::Load::Conditional   qw[can_load];
use Locale::Maketext::Simple    Class => 'CPANPLUS', Style => 'gettext';

$VERSION =  '0.01';

local $Params::Check::VERBOSE = 1;

=head1 NAME

CPANPLUS::Dist::PAR

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

### we can't install things withour our dependencies.
sub format_available { 
    return unless can_load( modules => {
                            'PAR::Dist' => 0 
                        } );
    return 1;
}

sub create { 
    ### just in case you already did a create call for this module object
    ### just via a different dist object
    my $dist        = shift;
    my $self        = $dist->parent;
    my $dist_cpan   = $self->status->dist_cpan;
    $dist           = $self->status->dist   if      $self->status->dist;
    $self->status->dist( $dist )            unless  $self->status->dist;

    my $cb   = $self->parent;
    my $conf = $cb->configure_object;
    
    $dist->SUPER::create( @_ ) or return;
    
    msg( loc("Creating PAR dist of '%1'", $self->name), 1);

    ### par::dist is noisy, silence it
    ### XXX this doesn't quite work -- restoring STDOUT still has
    ### it closed
    #*STDOUT_SAVE = *STDOUT; close *STDOUT;
    my $par = eval {
        ### pass name and version explicitly, as parsing doesn't always
        ### work
        PAR::Dist::blib_to_par( 
            path    => $self->status->extract,
             version => $self->package_version,
             name    => $self->package_name,
        );
    };          
    
    ### error?
    if( $@ or not $par or not -e $par ) {
        error(loc("Could not create PAR distribution of %1: %2",
                  $self->name, $@ ));
        return;                  
    }

    my ($to,$fail);
    MOVE: {
        my $dir = File::Spec->catdir(
                        $conf->get_conf('base'),
                        CPANPLUS::Internals::Utils
                           ->_perl_version(perl => $^X),
                        $conf->_get_build('distdir'),
                        'PAR'
                    );      
        my $to  = File::Spec->catfile( $dir, basename($par) );

        $cb->_mkdir( dir => $dir )              or $fail++, last MOVE;                     
        $cb->_move( file => $par, to => $to )   or $fail++, last MOVE;                     
        msg(loc("PAR distribution written to: '%1'", $to), 1);
    
        $dist->status->dist( $to );
    } 
    
    return $dist->status->created(1) unless $fail;
    return;
}

1;
