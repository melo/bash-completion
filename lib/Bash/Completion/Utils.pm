package Bash::Completion::Utils;

use strict;
use warnings;
use parent 'Exporter';
use File::Spec::Functions;

@Bash::Completion::Utils::EXPORT_OK = qw(
  command_in_path
  match_perl_modules
  prefix_match
);

=function command_in_path

Given a command name, returns the full path if we find it in the PATH.

=cut

sub command_in_path {
  my ($cmd) = @_;

  for my $path (grep {$_} split(/:/, $ENV{PATH})) {
    my $file = catfile($path, $cmd);
    return $file if -x $file;
  }

  return;
}


=function match_perl_modules

=cut

sub match_perl_modules {
  my ($pm, $bns) = @_;
  my @found;

  my ($ns, $name) = $pm =~ m{^(.+::)?(.*)};
  $ns = '' unless $ns;

  my $base = join('::', grep { $_ } ($bns, $ns));
  $base =~ s{::}{/}g;

  for my $lib (@INC) {
    _scan_dir_for_perl_modules(catdir($lib, $base), $ns, $name, \@found);
  }

  return @found;
}

sub _scan_dir_for_perl_modules {
  my ($dir, $ns, $name, $found) = @_;

  return unless opendir(my $dh, $dir);

  while (my $entry = readdir($dh)) {
    next if $entry =~ /^[.]/;

    my $path = catfile($dir, $entry);

    if (-d $path && $entry =~ m/^$name/) {
      push @$found, "$ns${entry}::";
    }
    elsif (-f _ && $entry =~ m/^($name.*)[.]pm$/) {
      push @$found, "$ns$1";
    }
  }
}


=function prefix_match

=cut

sub prefix_match {
  my $prefix = shift;

  return grep {/^$prefix/} @_;
}

1;

__END__

=head1 SYNOPSIS

    use Bash::Completion::Utils qw( command_in_path );
    
    ...

=head1 DESCRIPTION

A library of utilities functions usefull to plugin writers.
