#!perl

use strict;
use warnings;
use Test::More;
use File::Temp;
use File::Spec::Functions 'catfile';
use Config;

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
  my $bin_dir = File::Temp->newdir;
  local $ENV{PATH} = "$bin_dir$Config{path_sep}$ENV{PATH}";
  my $fake_perldoc       = catfile($bin_dir->dirname, 'perldoc');
  my $fake_bash_complete = catfile($bin_dir->dirname, 'bash-complete');
  open(my $has_fake_perldoc,       '>', $fake_perldoc);
  open(my $has_fake_bash_complete, '>', $fake_bash_complete);

  my $script = $bc->setup;
  ok($script, 'Got us a setup script');

  like(
    $script,
    qr{bash-complete complete BashComplete},
    '... with the expected setup command for bash-complete'
  ) if $has_fake_bash_complete;
  like(
    $script,
    qr{bash-complete complete Perldoc},
    '... with the expected setup command for perldoc'
  ) if $has_fake_perldoc;
  like(
    $script,
    qr{-o nospace -o default perldoc},
    '...... and it even has the correct options'
  ) if $has_fake_perldoc;
}


## and we are done for today
done_testing();
