package Bash::Completion::Request;

# ABSTRACT: Abstract a completion request

use strict;
use warnings;

=attr line

The full command line as given to us by bash.

=cut

sub line { return $_[0]{line} }


=attr word

The word to be completed.

=cut

sub word { return $_[0]{word} }


=attr args

The command line, up to and including the word to be completed, as a list of terms.

The split of the command line into terms is very very basic. There might be dragons here.

=cut

sub args { return @{$_[0]{args}} }


=attr count

Number of words in the command line before the completion point.

=cut

sub count { return $_[0]{count} }


=attr point

The index in the command line where the shell cursor is.

=cut

sub point { return $_[0]{point} }


=method new

Constructs a completion request object based on the bash environment
variables: C<COMP_LINE> and C<COMP_POINT>.

=cut

sub new {
  my ($class) = @_;

  return bless {
    candidates => [],

    line  => $ENV{COMP_LINE},
    point => $ENV{COMP_POINT},
    _get_completion_word(),
    _get_arguments(),
  }, $class;
}


=method candidates

Accepts a list of completion candidates and passes them on to the shell.

=cut

sub candidates {
  my $self = shift;
  my $c    = $self->{candidates};

  return @$c unless @_;

  push @$c, @_;
}


#######
# Utils

## Stolen from http://github.com/yanick/dist-zilla/blob/master/contrib/dzil-complete
sub _get_completion_word {
  my $comp = substr $ENV{'COMP_LINE'}, 0, $ENV{'COMP_POINT'};
  $comp =~ s/.*\s//;
  return word => $comp;
}

sub _get_arguments {
  my $comp = substr $ENV{'COMP_LINE'}, 0, $ENV{'COMP_POINT'};
  my @args = split(/\h+/, $comp);

  return args => \@args, count => scalar(@args);
}


1;
