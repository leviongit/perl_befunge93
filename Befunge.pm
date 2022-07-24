package Befunge;

use strict;
use warnings;
use feature 'signatures';
no warnings "experimental::signatures";
use Switch;
use lib ".";
use Utils;
use Utils "popn";
use InstrPtr;

sub new ( $class, $code, $size = [ 80, 25 ] ) {

    my @cary = map { @$code[$_] or "" } 0 .. $size->[1] - 1;

    for my $str (@cary) {
        chomp $str;
        $str = substr Utils::ljust( $str, $size->[0] ), 0, $size->[0];
    }

    my $self = {
        _code    => \@cary,
        _size    => $size,
        _iptr    => new InstrPtr($size),
        _stack   => [],
        _strmode => 0
    };
    return bless $self, $class;
}

sub code ($self) {
    $self->{_code};
}

sub iptr ($self) {
    $self->{_iptr};
}

sub stack ($self) {
    $self->{_stack};
}

sub strmode ($self) {
    $self->{_strmode};
}

sub toggle_strmode ($self) {
    $self->{_strmode} = !$self->{_strmode};
}

sub to_s ($self) {
    my $ref = $self->code;
    local $" = "\n";
    my $res = "@$ref";

    $res .= "\n" x 2;

    $ref = $self->stack;

    local $" = ",";
    $res .= "[@$ref]";

    $res;
}

sub run ($self) {
    my $ref   = $self->code;
    my @codea = @$ref;
  LOOP: while (1) {

        # print $self->iptr->{_y}, " ", $self->iptr->{_x}, "\n";
        my $cchar = substr @codea[ $self->iptr->{_y} ], $self->iptr->{_x}, 1;
        if ( $self->strmode ) {
            $self->iptr->move;
            if ( $cchar eq "\"" ) {
                $self->toggle_strmode;
            }
            else {
                push( ( @{ $self->stack } ), ( ord $cchar ) );
            }
            next LOOP;
        }

        switch ($cchar) {
            case ">" { $self->iptr->point_right }
            case "v" { $self->iptr->point_down }
            case "<" { $self->iptr->point_left }
            case "^" { $self->iptr->point_up }
            case "+" {
                my ( $r, $l ) = Utils::popn( @{ [ $self->stack ] }, 2 );
                push @{ $self->stack }, $l + $r;
            }
            case "-" {
                my ( $r, $l ) = Utils::popn( @{ [ $self->stack ] }, 2 );
                push @{ $self->stack }, $l - $r;
            }
            case "*" {
                my ( $r, $l ) = Utils::popn( @{ [ $self->stack ] }, 2 );
                push @{ $self->stack }, $l * $r;
            }
            case "/" {
                my ( $r, $l ) = Utils::popn( @{ [ $self->stack ] }, 2 );
                push @{ $self->stack }, $l / $r;
            }
            case "%" {
                my ( $r, $l ) = Utils::popn( @{ [ $self->stack ] }, 2 );
                push @{ $self->stack }, $l % $r;
            }
            case "!" {
                my $a = ( pop @{ $self->stack } or 0 );
                if   ($a) { push @{ $self->stack }, 0 }
                else      { push @{ $self->stack }, 1 }
            }
            case "`" {
                my ( $r, $l ) = Utils::popn( @{ [ $self->stack ] }, 2 );
                if   ( $l > $r ) { push @{ $self->stack }, 0 }
                else             { push @{ $self->stack }, 1 }
            }
            case "?" {
                my $sign = rand 1;
                my $xy   = rand 1;

                if   ($sign) { $sign = 1 }
                else         { $sign = -1 }

                if   ($xy) { $self->iptr->set_delta( $sign, 0 ) }
                else       { $self->iptr->set_delta( 0,     $sign ) }
            }
            case "_" {
                my $v = ( pop @{ $self->stack } or 0 );
                if   ($v) { $self->iptr->point_left }
                else      { $self->iptr->point_right }
            }
            case "|" {
                my $v = ( pop @{ $self->stack } or 0 );
                if   ($v) { $self->iptr->point_up }
                else      { $self->iptr->point_down }
            }
            case ":" {
                my $v = pop @{ $self->stack };
                push @{ $self->stack }, ( $v, $v );
            }
            case "\\" {
                my ( $r, $l ) = Utils::popn( @{ [ $self->stack ] }, 2 );
                push @{ $self->stack }, ( $r, $l );
            }
            case "\$" {
                pop @{ $self->stack };
            }
            case "." {
                print( ( pop @{ $self->stack } or 0 ), " " );
            }
            case "," {
                print chr( pop @{ $self->stack } or 0 );
            }
            case "#" { $self->iptr->move }
            case "g" {
                my ( $y, $x ) = Utils::popn( @{ [ $self->stack ] }, 2 );
                push @{ $self->stack }, ord substr $codea[$y], $x, 1;
            }
            case "p" {
                my ( $y, $x, $v ) = Utils::popn( @{ [ $self->stack ] }, 3 );
                ( substr $codea[$y], $x, 1 ) = chr $v;
            }
            case "&" {
                push @{ $self->stack }, int <>;
            }
            case "~" {
                push @{ $self->stack }, ord <>;
            }
            case "\"" {
                $self->toggle_strmode
            }
            case (/\d/) {
                push @{ $self->stack }, int $cchar;
            }
            case "@" { last LOOP }
        }

        # local $" = ", ";
        # print "[@{$self->stack}] [$self->{_x}, $self->{_y}]\n";

        # end of loop
        $self->iptr->move;
    }
    print "\n";
}

1;
