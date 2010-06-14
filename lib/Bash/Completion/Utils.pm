package Bash::Completion::Utils;

use strict;
use warnings;
use parent 'Exporter';
use File::Spec::Functions;

@Bash::Completion::Utils::EXPORT_OK = qw(
  command_in_path
);

=function command_in_path

Given a command name, returns the full path if we find it in the PATH.

=cut
sub command_in_path {
  my ($cmd) = @_;
  
  for my $path (grep { $_ } split(/:/, $ENV{PATH})) {
    my $file = catfile($path, $cmd);
    return $file if -x $file;
  }
  
  return;
}

1;

__END__

=head1 SYNOPSIS

    use Bash::Completion::Utils qw( command_in_path );
    
    ...

=head1 DESCRIPTION

A library of utilities functions usefull to plugin writers.
