# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 3;

#########################

use base 'Class::Init';

ok('use base Class::Init');

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

eval {
    sub init { $_[0]->{1} = 2; };

    my $thing = eval { __PACKAGE__->new };
    length($@) ? fail "\$@ = $@" : ok($thing, 'new()');
    is(eval { $thing->{1} }, 2,
	'{1} == 2');
}; fail "\$@ = $@" if length $@;
