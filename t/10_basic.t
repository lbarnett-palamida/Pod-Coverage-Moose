#!/usr/bin/perl
use warnings;
use strict;

use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More no_plan => 1;

use_ok('Pod::Coverage::Moose')
    or die "Doesn't make sense to continue without compiling class\n";

{   package NonMoose;
    sub foo { }
}
isa_ok Pod::Coverage::Moose->new(package => 'NonMoose'), 'Pod::Coverage',
    'non Moose package coverage object';

require IsMoose;
my $pcm = Pod::Coverage::Moose->new(package => 'IsMoose');
isa_ok $pcm, 'Pod::Coverage::Moose',
    'Moose package coverage object';

#use Data::Dump qw( dump );
#print dump([$pcm->covered]), "\n";
is_deeply [sort $pcm->covered], [sort qw( attr meta has_complex clear_complex get_complex set_complex )],
    'covered methods contain role methods and meta method';
is_deeply [sort $pcm->uncovered], [qw( bar )],
    'uncovered methods contains method directly in package';