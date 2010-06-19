#!perl

use strict;
use warnings;
use Test::More;

use_ok('Bash::Completion') || die "Could not load Bash::Completion, ";

my $bc = Bash::Completion->new;
ok($bc,                  'Bash::Completion object ok');
ok(scalar($bc->plugins), '... got some plugins');

my @plugins = $bc->load_plugins;
for my $plugin (@plugins) {
  ok($plugin->isa('Bash::Completion::Plugin'), " ... plugin $plugin is ok");
}


## and we are done for today
done_testing();
