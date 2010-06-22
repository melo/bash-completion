package Bash::Completion::Plugin;

# ABSTRACT: base class for Bash::Completion plugins

use strict;
use warnings;

=method new

A basic plugin constructor. Accepts a list of key/values. Accepted keys:

=over 4

=item args

A list reference with parameters to this plugin.

=back

=cut

sub new {
  my $class = shift;
  my %args = (args => [], @_);

  return bless \%args, $class;
}


=attr args

An list reference with plugin arguments.

=cut

sub args {
  my ($self) = @_;

  return @{$self->{args}};
}


=method should_activate

The method C<should_activate()> is used by the automatic setup of
completion rules in the .bashrc. It should return a reference to a list
of commands that the plugin is can complete.

If this method returns a reference to an empty list (the default), the
plugin will not be used.

A common implementation of this method is to check the PATH for the
command we want to provide completion, and return the com only if that
command is found.

For example:

    sub should_activate {
      return [grep { command_in_path($_) } qw( perldoc pod )];
    }

=cut

sub should_activate { return [] }


=method generate_bash_setup

This method receives the list of commands that where found by
L</should_activate> and must return a list of options to use when
creating the bash C<complete> command.

For example, if a plugin returns C<[qw( nospace default )]>, the
following bash code is generated:

    complete -C 'bash-complete complete PluginName' -o nospace -o default command

By default this method returns a reference to an empty list.

Alternatively, and for complete control, you can return a string with
the entire bash code to activate the plugin.


=cut

sub generate_bash_setup { return [] }

1;

__END__

=head1 SYNOPSIS

    ## Example plugin for xpto command
    package Bash::Completion::Plugin::XPTO;

    use strict;
    use warnings;
    use parent 'Bash::Completion::Plugin';
    use Bash::Completion::Utils qw( command_in_path );

    sub should_activate {
      return [grep { command_in_path(_) } ('xpto')];
    }


    ## Optionally, for full control of the generated bash code
    sub generate_bash_setup {
      return q{complete -C 'bash-complete complete XPTO' xpto};
    }

    ## Use plugin arguments
    sub generate_bash_setup {
      return q{complete -C 'bash-complete complete XPTO arg1 arg2 arg3' xpto};
    }
    ## $plugin->args will have ['arg1', 'arg2', 'arg3']

    1;

=head1 DESCRIPTION

A base class for L<Bash::Completion> plugins that provides the default
implementations for the required plugin methods.

See the L</SYNOPSIS> for an example of a plugin.
