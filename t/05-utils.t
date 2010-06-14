#!perl

use strict;
use warnings;
use Test::More;

use_ok('Bash::Completion::Utils', qw(command_in_path))
  || die "Could not load Bash::Completion::Utils, ";

## command_in_path
ok(command_in_path('perl'), 'command_in_path(perl) works');
ok(
  !command_in_path('non_existing_command'),
  'command_in_path(non_existing_command) also works'
);

## and we are done for today
done_testing();
