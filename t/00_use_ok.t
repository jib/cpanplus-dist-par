use Test::More 'no_plan';
use strict;

BEGIN { chdir 't' if -d 't' };
BEGIN { use lib '../lib';   };

my $Class   = 'CPANPLUS::Dist::Par';

### does it compile ok?
use_ok( $Class );



