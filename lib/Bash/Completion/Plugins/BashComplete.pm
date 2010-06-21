package Bash::Completion::Plugins::BashComplete;

# ABSTRACT: Plugin for bash-complete

use strict;
use warnings;
use parent 'Bash::Completion::Plugin';
use Bash::Completion::Utils
  qw( command_in_path match_perl_modules prefix_match );

=method should_activate

Makes sure we only activate this plugin if we can find C<bash-complete>
on the PATH.

=cut

sub should_activate { return command_in_path('bash-complete') }


=method generate_bash_setup

Generates the proper complete command to enable completion for
our C<bash-complete> command.

=cut

sub generate_bash_setup {
  return q{complete -C 'bash-complete complete BashComplete' bash-complete};
}


=method complete

Completion logic for C<bash-complete>

=cut

my @commands = qw{ setup complete };
my @options = ('--help', '-h');

sub complete {
  my ($class, $req) = @_;
  my $word  = $req->word;
  my @args  = $req->args;
  my $count = $req->count;

  my @c;
  if (index($word, '-') == 0) {
    @c = prefix_match($word, @options);
  }
  elsif ($count >= 2 && $args[1] eq 'complete') {
    @c = match_perl_modules("Bash::Completion::Plugins::$word");
  }
  elsif ($count <= 2) {
    @c = prefix_match($word, @commands, @options);
  }

  $req->candidates(@c);
}

1;

__END__

=head1 SYNOPSIS

    ## not to be used directly

=head1 DESCRIPTION

A plugin for the C<base-complete> command. Completes options and
sub-commands.

For the C<complete> sub-command, it completes with the plugin names.
