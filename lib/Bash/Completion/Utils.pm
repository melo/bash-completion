package Bash::Completion::Utils;

# ABSTRACT: Set of utility functions that help writting plugins

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

Given a partial module name, returns a list of all the possible completions.

If a single exact match is found, it returns nothing.

Some examples:

=over 4

=item (empty string)

List all top level modules and namespaces.

=item Template

List C<Template>, the module, and C<Template::>, the namespace.

=item Net::DNS::RR::

Lists all type of Resource Records modules.

=item File::Tempdir

Returns an empty list.

=back

=cut

sub match_perl_modules {
  my ($pm) = @_;
  my ($filler, %found) = ('');

  $pm .= $filler = ':' if $pm =~ /[^:]:$/;

  my ($ns, $filter) = $pm =~ m{^(.+::)?(.*)};
  $ns = '' unless $ns;

  my $sdir = $ns;
  $sdir =~ s{::}{/}g;

  for my $lib (@INC) {
    next if $lib eq '.';
    _scan_dir_for_perl_modules(catdir($lib, $sdir), $ns, $filter, \%found);
  }

  my @found = keys %found;
  map {s/^$ns/$filler/} @found;

  return if 1 == @found && $found[0] eq $filter;    ## Exact match, ignore it
  return @found;
}

sub _scan_dir_for_perl_modules {
  my ($dir, $ns, $name, $found) = @_;

  return unless opendir(my $dh, $dir);

  while (my $entry = readdir($dh)) {
    next if $entry =~ /^[.]/;

    my $path = catfile($dir, $entry);

    if (-d $path && $entry =~ m/^$name/) {
      $found->{"$ns${entry}::"} = 1;
    }
    elsif (-f _ && $entry =~ m/^($name.*)[.]pm$/) {
      $found->{"$ns$1"} = 1;
    }
  }
}


=function prefix_match

Accepts a single word and a list of options.

Returns the options that match the word.

=cut

sub prefix_match {
  my $prefix = shift;

  return grep {/^$prefix/} @_;
}

1;

__END__

=head1 SYNOPSIS

    use Bash::Completion::Utils qw(
      command_in_path match_perl_modules prefix_match
    );

    ...

=head1 DESCRIPTION

A library of utility functions usefull to plugin writers.
