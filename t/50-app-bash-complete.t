#!perl

use strict;
use warnings;
use Test::More;

use_ok('App::BashComplete') || die "Could not load App::BashComplete, ";

my $app = App::BashComplete->new;
ok($app, 'Have a nice app');
can_ok($app, qw( run ));


## and we are done for today
done_testing();
