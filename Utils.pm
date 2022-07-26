package Utils;

use strict;
use warnings;
use feature 'signatures';
no warnings "experimental::signatures";

sub clamp ( $num, $min, $max ) {
    if ( $num < $min ) {
        return $min;
    }
    elsif ( $num > $max ) {
        return $max;
    }
    else {
        return $num;
    }
}

sub clamp_wrap ( $num, $min, $max ) {
    ( $max, $min ) = ( $min, $max ) if ( $min > $max );
    my $rng = $max - $min + 1;
    $min + ( $num - $min ) % $rng;
}

sub ljust ( $str, $len, $char = ' ' ) {
    if ( length $str < $len ) {
        $str . ( $char x ( $len - ( length $str ) - 1 ) );
    }
    else { $str; }
}

sub rjust ( $str, $len, $char = ' ' ) {
    if ( length $str < $len ) {
        ( $char x ( $len - ( length $str ) - 1 ) ) . $str;
    }
    else { $str; }
}

sub popn ( $ary, $num, $default = 0 ) {
    my @retv = ();
    for ( 0 .. $num - 1 ) {
        push @retv, ( pop @{$ary} or $default );
    }
    return @retv;
}

1;
