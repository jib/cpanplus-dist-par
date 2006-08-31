use Test::More 'no_plan';
use strict;

use Module::Loaded;
use Module::Load::Conditional;

my $Class   = 'CPANPLUS::Dist::PAR';
my @Deps    = qw[PAR PAR::Dist];

use_ok( $Class );

### check if the format is available
{   ### XXX whitebox test
    local $Module::Load::Conditional::CHECK_INC_HASH = 1;
    local $Module::Load::Conditional::CHECK_INC_HASH = 1;
    
    for ( @Deps ) { 
        mark_as_loaded( $_ ); 
        mark_as_unloaded( $_ ) if is_loaded( $_ ) 
    };
    ok( !$Class->format_available,
                                "Format not available on missing @Deps" );

    for ( @Deps ) { mark_as_loaded( $_ ) if not is_loaded( $_ ) };
    ok( $Class->format_available,
                                "Format available with loaded @Deps" );
}
