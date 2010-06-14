package App::BashComplete;

# ABSTRACT: command line interface to Bash::Complete

use strict;
use warnings;
use Bash::Completion;
use Getopt::Long qw(GetOptionsFromArray);

############
# Attributes

=attr opts

Returns an HashRef with all the command line options used.

=cut
sub opts { return $_[0]->{opts} }

=attr cmd_line

Returns a ArrayRef with the parts of the command line that could not be parsed as options.

=cut
sub cmd_line { return $_[0]->{cmd_line} }


#########
# Methods

=method new

Creates a new empty instance.

=cut
sub new { return bless {opts => {}, cmd_line => []}, shift }


=method run

Processes options, using both command line and arguments to run(), and
executes the proper action.

=cut
sub run {
  my $self = shift;

  return unless $self->_parse_options(@_);

  # TODO: deal with opts
}


#######
# Utils

sub _parse_options {
  my $self = shift;

  my $cmd_line = $self->{cmd_line} = [@_, @ARGV];
  my $opts = $self->{opts} = {};

  my $ok = GetOptionsFromArray($cmd_line, $opts, 'setup');

  # TODO: deal with !$ok

  return $ok;
}

1;


__END__


