package Bash::Completion::Request;

use strict;
use warnings;

sub new {
  my ($class) = @_;

  return bless {
    line  => $ENV{COMP_LINE},
    point => $ENV{COMP_POINT},
    _get_completion_word(),
    _get_arguments(),
  }, $class;
}

## Stolen from http://github.com/yanick/dist-zilla/blob/master/contrib/dzil-complete
sub _get_completion_word {
  my $comp = substr $ENV{'COMP_LINE'}, 0, $ENV{'COMP_POINT'};
  $comp =~ s/.*\h//;
  return word => $comp;
}

sub _get_arguments {
  my $comp = substr $ENV{'COMP_LINE'}, 0, $ENV{'COMP_POINT'};
  my @args = split(/\h+/, $comp);

  return args => \@args, count => scalar(@args);
}


## Accessors
sub line  { return $_[0]{line} }
sub word  { return $_[0]{word} }
sub args  { return @{$_[0]{args}} }
sub count { return $_[0]{count} }
sub point { return $_[0]{point} }

sub candidates {
  my $self = shift;

  print "$_\n" for @_;
}


1;
