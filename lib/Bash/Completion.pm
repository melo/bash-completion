package Bash::Completion;

# ABSTRACT: Extensible system to provide bash completion

use strict;
use warnings;
use Module::Pluggable
  search_path => ['Bash::Completion::Plugins'],
  sub_name    => 'plugin_names';

=method new

Create a L<Bash::Completion> instance.

=cut

sub new { return bless {}, $_[0] }


=method load_plugins

Search C<@INC> for all classes in the L<Bash::Completion::Plugin> namespace.

=cut

sub plugins {
  my ($self) = @_;

  unless ($self->{plugins}) {
    my @plugins;

    for my $plugin_name ($self->plugin_names) {
      eval "require $plugin_name";
      next if $@;

      push @plugins, $plugin_name->new;
    }

    $self->{plugins} = \@plugins;
  }

  return @{$self->{plugins}};
}


1;
