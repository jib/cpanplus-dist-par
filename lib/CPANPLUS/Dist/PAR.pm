package CPANPLUS::Dist::PAR;
use strict;

use vars    qw[@ISA $VERSION];
@ISA =      qw[CPANPLUS::Dist];
$VERSION =  '0.01';

use CPANPLUS::Error;
use CPANPLUS::Internals::Constants;

use Params::Check               qw[check];
use Module::Load::Conditional   qw[can_load check_install];
use Locale::Maketext::Simple    Class => 'CPANPLUS', Style => 'gettext';

local $Params::Check::VERBOSE = 1;

sub format_available { 
    return unless can_load( 'PAR'       => 0,
                            'PAR::Dist' => 0 );
    return 1;
}

sub init { 
    return 1;
}

sub prepare { 
    ### just in case you already did a create call for this module object
    ### just via a different dist object
    my $dist        = shift;
    my $self        = $dist->parent;
    my $dist_cpan   = $self->status->dist_cpan;
    $dist           = $self->status->dist   if      $self->status->dist;
    $self->status->dist( $dist )            unless  $self->status->dist;

    my $cb   = $self->parent;
    my $conf = $cb->configure_object;
    my %hash = @_;

    my $fail;
    
    ### build it first
    DIST_CPAN: {
        $dist_cpan->prepare( @_ ) or ++$fail, last DIST_CPAN;
        $dist_cpan->create(  @_ ) or ++$fail, last DIST_CPAN;
    }

    return $dist->status->prepared(0) if $fail;
    
    

}

sub create { }

sub install { }

sub uninstall { }

1;
