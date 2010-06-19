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

  # TODO: move commands to a plugin system

  # TODO: proper usage message
  return 1 unless my $cmd = $self->_parse_options(@_);

  return $self->setup    if $cmd eq 'setup';
  return $self->complete if $cmd eq 'complete';

  # TODO: proper unknown command message
  return 1;
}


#########
# Actions

=method complete

=cut

sub complete {
  my ($self)   = @_;
  my $cmd_line = $self->cmd_line;
  my $plugin   = shift @$cmd_line;

  ## TODO: need a plugin
  return 1 unless $plugin;

  my $bc = Bash::Completion->new;
  return 0 if $bc->complete($plugin, $cmd_line);
  return 1;
}


=method setup

Collects all plugins, decides which ones should be activated, and generates the bash complete command lines for each one.

This allows you to setup your bash completion with only this:

    # Stick this into your .bashrc
    eval $( bash-complete setup )

The system will adjust to new plugins that you install via CPAN.

=cut

sub setup {
  my ($self) = @_;
  my $bc_src = '';

  my $bc = Bash::Completion->new;

  for my $plugin ($bc->plugins) {
    next unless $plugin->should_activate;

    if (my $setup = $plugin->generate_bash_setup()) {
      $bc_src .= "\n$setup\n";
    }
  }

  print "\n$bc_src\n";
  return 0;
}


#######
# Utils

sub _parse_options {
  my $self = shift;

  my $cmd_line = $self->{cmd_line} = [@_];
  my $opts     = $self->{opts}     = {};

  my $ok = GetOptionsFromArray($cmd_line, $opts, 'help');

  # TODO: deal with !$ok
  return unless $ok;

  return shift(@$cmd_line);
}

1;


__END__


