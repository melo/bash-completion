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
completion rules in the .bashrc.

When collecting plugins to activate, the system calls this method. If
this method returns false, the default, the plugin is not used.

A common implementation of this method is to check the PATH for the
command we want to provide completion, and return true only if that
command is found.

=cut

sub should_activate {return}


=method generate_bash_setup

This method should generate the bash commands to enable completion for
the commands the plugin targets.

For example, something like:

    complete -C "bash-complete cmd Perldoc" perldoc

This will execute C<bash-complete cmd Perldoc> to complete the
C<perldoc> command. The C<Perldoc> string is the plugin name.

=cut

sub generate_bash_setup {return}

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
      return command_in_path('xpto');
    }

    sub generate_bash_setup {
      return 'complete -C "bash-complete cmd XPTO" xpto';
    }

    1;

=head1 DESCRIPTION

A base class for L<Bash::Completion> plugins that provides the default
implementations for the required plugin methods.

See the L</SYNOPSIS> for an example of a plugin.
