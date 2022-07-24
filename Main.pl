#! /usr/bin/perl

use strict;
use warnings;
use feature 'signatures';
no warnings "experimental::signatures";
use lib ".";
use InstrPtr;
use Utils;
use Befunge;

my $filename = shift or die("Please provide a file");

open( InFile, "<" . "$filename" ) or die("File doesn't exist");

my @contents = <InFile>;

my $befunge = new Befunge( \@contents, [ 80, 25 ] );

$befunge->run;

close InFile;
