package Class::Init;

use 5.008001;
use strict;
use warnings;

use NEXT;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Class::Init ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	new
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.8';


# Preloaded methods go here.

sub _init_handlers () {
    # These get if they exist, in order, by new().
    qw( init _init __init __init__ initialise initialize );
}

sub _default_constructor ($;@) {
    # This gets called if all else fails to create $self.
    bless { @_[1..$#_] }, $_[0];
}

sub new ($;@) {
    # Set $self to our parent's idea of new(), or otherwise just a simple blessed hashref.
    my $self = $_[0]->NEXT::DISTINCT::new(@_[1..$#_]) || $_[0]->_default_constructor(@_[1..$#_]);
    # Call any defined init handlers.
    { no strict 'refs'; for ($_[0]->_init_handlers) {
	next unless defined &$_;
	$self->$_(@_[1..$#_]);
    } }

    $self;
}

sub init ($;%) {
    # Install any default attributes into the object's hash.
    $_[0]->{$_[0+2*$_]} = $_[0]->{$_[1+2*$_]} for (1..($#_-1)/2);
    # Call our parent's init, if it's available.
    $_[0]->NEXT::DISTINCT::init(@_[1..$#_]);
}

1;
__END__

=head1 NAME

Class::Init - A base constructor class with support for local initialization methods.

=head1 SYNOPSIS

  package Something::Spiffy;
  use base Class::Init;
  sub init {
    my $self = shift;
    exists $self->{dsn} || die "parameter 'dsn' missing";
    $self->{_dbh} = DBI->connect($self->{dsn}) || die "DBI->connect failed";
  }
  sub users {
    my $sth = shift->{_dbh}->prepare_cached("SELECT * FROM users");
    $sth->execute(@_); return @{ $sth->fetchall_arrayref };
  }

  package main;
  my $database = Something::Spiffy->new( dsn => '...' );
  my @users = $database->users;
  ...

=head1 DESCRIPTION


=head1 AUTHOR

Richard Soderberg, E<lt>perl@crystalflame.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2004 by Richard Soderberg

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
