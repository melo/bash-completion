#!perl

use strict;
use warnings;
use Test::More;

use_ok('App::BashComplete') || die "Could not load App::BashComplete, ";
local @ARGV = ();

my $app = App::BashComplete->new;
ok($app, 'Have a nice app');
can_ok($app, qw( run ));

ok($app->_parse_options('--setup'), "Parsed '--setup' cmd line");
ok($app->opts->{setup}, '... setup option properly set');


## and we are done for today
done_testing();
