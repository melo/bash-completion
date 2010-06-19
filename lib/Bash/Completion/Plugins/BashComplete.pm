package Bash::Completion::Plugins::BashComplete;

use strict;
use warnings;
use parent 'Bash::Completion::Plugin';
use Bash::Completion::Utils qw( command_in_path match_perl_modules prefix_match );

sub should_activate { return command_in_path('bash-complete') }

sub generate_bash_setup {
  return 'complete -C "bash-complete complete BashComplete"';
}

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
    @c = match_perl_modules($word, 'Bash::Completion::Plugins');
  }
  elsif ($count <= 2) {    
    @c = prefix_match($word, @commands, @options);  
  }

  $req->candidates(@c);
}

1;
