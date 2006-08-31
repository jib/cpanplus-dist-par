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
    return unless check_install( module => 'PAR' );
    return 1;
}

sub prepare { }

sub create { }

sub install { }

sub uninstall { }

1;
