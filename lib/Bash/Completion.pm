package Bash::Completion;

# ABSTRACT: Extensible system to provide bash completion

use strict;
use warnings;
use Bash::Completion::Request;
use Module::Load ();
use Module::Pluggable
  search_path => ['Bash::Completion::Plugins'],
  sub_name    => 'plugin_names';

=method new

Create a L<Bash::Completion> instance.

=cut

sub new { return bless {}, $_[0] }


=method complete

Given a plugin name and a list reference of plugin arguments, loads the
proper plugin class, creates the plugin instance and asks for possible
completions.

Returns the L<Bash::Completion::Request> object.

=cut

sub complete {
  my ($self, $plugin, $cmd_line) = @_;

  my $class = "Bash::Completion::Plugins::$plugin";
  return unless $self->_load_class($class);

  my $req = Bash::Completion::Request->new;
  $class->new(args => $cmd_line)->complete($req);

  return $req;
}


=method setup

Checks all plugins found if they should be activated.

Generates and returns the proper bash code snippet to it all up.

=cut

sub setup {
  my ($self) = @_;
  my $script = '';

  for my $plugin ($self->plugins) {
    my $cmds = $plugin->should_activate;
    next unless @$cmds;

    my $snippet = $plugin->generate_bash_setup($cmds);

    if (ref $snippet) {
      my $options = join(' ', map {"-o $_"} @$snippet);
      my $plugin_name = ref($plugin);
      $plugin_name =~ s/^Bash::Completion::Plugins:://;

      $snippet = join(
        "\n",
        map {
          qq{complete -C 'bash-complete complete $plugin_name -- ' $options $_}
          } @$cmds
      );
    }

    $script .= "$snippet\n" if $snippet;
  }

  return $script;
}


=method plugins

Search C<@INC> for all classes in the L<Bash::Completion::Plugins::>
namespace.

=cut

sub plugins {
  my ($self) = @_;

  unless ($self->{plugins}) {
    my @plugins;

    for my $plugin_name ($self->plugin_names) {
      next unless $self->_load_class($plugin_name);

      push @plugins, $plugin_name->new;
    }

    $self->{plugins} = \@plugins;
  }

  return @{$self->{plugins}};
}


#######
# Utils

sub _load_class {
  eval { Module::Load::load($_[1]); 1 };
}

1;

=head1 SYNOPSIS

    ## For end users, in your .bashrc:
    ##
    . setup-bash-complete
    ##
    ## Now install all the Bash::Completion::Plugins:: that you need
    ##
    ## For plugin writters, see Bash::Completion::Plugin

=head1 DESCRIPTION

C<bash> completion should just work when you install new commands.
C<Bash::Completion> is a system to use and write bash completion rules.

For end-users, you just need to add this line to your C<.bashrc> or
C<.bash_profile>:

    . setup-bash-complete

This will load all the installed C<Bash::Completion> plugins, make sure
they should be activated and generate the proper bash code to setup bash
completion for them.

If you later install a new command line tool, and it has a L<Bash::Completion::Plugin>-
based plugin, all your new shells will have bash completion rules for
it. You can also force immediate setup by running the same command:

    . setup-bash-complete

To write a new C<Bash::Completion> plugin, see L<Bash::Completion::Plugin>.
