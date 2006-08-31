use Test::More 'no_plan';
use strict;

use Module::Loaded;
use Module::Load::Conditional;

my $Class   = 'CPANPLUS::Dist::PAR';
my $Dep     = 'PAR';

use_ok( $Class );

### check if the format is available
{   ### XXX whitebox test
    local $Module::Load::Conditional::CHECK_INC_HASH = 1;
    local $Module::Load::Conditional::CHECK_INC_HASH = 1;
    
    mark_as_unloaded( $Dep ) if is_loaded( $Dep );
    ok( !$Class->format_available,
                                "Format not available on missing $Dep" );
    mark_as_loaded( $Dep ) if not is_loaded( $Dep );
    ok( $Class->format_available,
                                "Format available with loaded $Dep" );
}
