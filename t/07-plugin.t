#!perl

use strict;
use warnings;
use Test::More;

use_ok('Bash::Completion::Plugin')
  || die "Could not load Bash::Completion::Plugin, ";

ok(
  !Bash::Completion::Plugin->should_activate,
  'Default should_activate() returns false'
);
ok(
  !Bash::Completion::Plugin->generate_bash_setup,
  'Default generate_bash_setup() returns false'
);


## and we are done for today
done_testing();
