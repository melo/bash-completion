package Bash::Completion;

# ABSTRACT: Extensible system to provide bash completion

use strict;
use warnings;
use Module::Pluggable sub_name => 'list_plugins';

=method new

Create a L<Bash::Completion> instance.

=cut

sub new { return bless {}, $_[0] }


=method load_plugins

Search C<@INC> for all classes in the L<Bash::Completion::Plugin> namespace.

=cut

sub load_plugins {
  my ($self) = @_;

  unless ($self->{plugins}) {
    $self->{plugins} = [map { $_->new } $self->list_plugins];
  }

  return @{$self->{plugins}};
}


1;
