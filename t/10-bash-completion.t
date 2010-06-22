#!perl

use strict;
use warnings;
use Test::More;

use_ok('Bash::Completion') || die "Could not load Bash::Completion, ";

my $bc = Bash::Completion->new;
ok($bc,                       'Bash::Completion object ok');
ok(scalar($bc->plugin_names), '... got some plugins');

my @plugins = $bc->plugins;
for my $plugin (@plugins) {
  ok($plugin->isa('Bash::Completion::Plugin'), " ... plugin $plugin is ok");
}

## Test setup
{
  local $ENV{PATH} = "./bin:$ENV{PATH}:./t/tlib/bin";
  chmod(0755, './t/tlib/bin/perldoc');

  my $script = $bc->setup;
  ok($script, 'Got us a setup script');
  like(
    $script,
    qr{bash-complete complete BashComplete},
    '... with the expected setup command for bash-complete'
  );
  like(
    $script,
    qr{bash-complete complete Perldoc},
    '... with the expected setup command for perldoc'
  );
  like(
    $script,
    qr{Perldoc' -o nospace -o default },
    '...... and even using the correct options'
  );
}


## and we are done for today
done_testing();
