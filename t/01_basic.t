use Test::More 'no_plan';
use strict;

my $Class   = 'CPANPLUS::Dist::PAR';

use_ok( $Class );

### check if the format is available
{   ok( $Class->format_available,   "$Class Format available" );

}
