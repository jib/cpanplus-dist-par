use Test::More 'no_plan';

BEGIN { chdir 't' if -d 't' };
BEGIN { use lib '../lib';   };

my $Class = 'CPANPLUS::Dist::Par';

use_ok( $Class );
