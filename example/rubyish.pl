#!/usr/bin/perl

use warnings;
use strict;

use Ruby -all;

my @ary = qw(Perl Ruby Perl&Ruby);
my $s   = "rekcaH s% rehtonA tsuJ";

3->times(sub{ 
	my $i = shift;

	puts( $s->reverse % $ary[ $i ] );
});

puts "Loaded:";
rubyify(\%INC)->each(sub{
	puts "\t$_[0]";
});
#ObjectSpace->each_object(sub { ... })