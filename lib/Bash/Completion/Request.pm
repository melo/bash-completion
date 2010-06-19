package Bash::Completion::Request;

use strict;
use warnings;

sub new {
  my ($class) = @_;

  return bless {
    line  => $ENV{COMP_LINE},
    point => $ENV{COMP_POINT},
    word  => _get_completion_word(),
  }, $class;
}

## Stolen from http://github.com/yanick/dist-zilla/blob/master/contrib/dzil-complete
sub _get_completion_word {
  my $comp = substr $ENV{'COMP_LINE'}, 0, $ENV{'COMP_POINT'};
  $comp =~ s/.*\h//;
  return $comp;
}

sub line { return $_[0]{line} }
sub word { return $_[0]{word} }

sub candidates {
  my $self = shift;

  print "$_\n" for @_;
}


1;
