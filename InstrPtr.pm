package InstrPtr;

use strict;
use warnings;
use feature 'signatures';
no warnings "experimental::signatures";
use lib ".";
use Utils;

sub new ( $class, $size = [ 80, 25 ], $x = 0, $y = 0, $dx = 1, $dy = 0, ) {
    my $self = { _x => $x, _y => $y, _dx => $dx, _dy => $dy, _size => $size };
    return bless $self, $class;
}

sub move ($self) {
    $self->{_x} = Utils::clamp_wrap( $self->{_x} + $self->{_dx},
        0, $self->{_size}->[0] - 1 );
    $self->{_y} = Utils::clamp_wrap( $self->{_y} + $self->{_dy},
        0, $self->{_size}->[1] - 1 );
    $self;
}

sub set_delta ( $self, $x = 0, $y = 0 ) {
    $self->{_dx} = $x;
    $self->{_dy} = $y;
    $self;
}

sub point_down ($self) {
    $self->set_delta( 0, 1 );
}

sub point_up ($self) {
    $self->set_delta( 0, -1 );
}

sub point_left ($self) {
    $self->set_delta( -1, 0 );
}

sub point_right ($self) {
    $self->set_delta( 1, 0 );
}

sub rot_right ($self) {
    $self->set_delta( $self->{_dy}, -$self->{_dx} );
}

sub to_s ($self) {
"InstrPtr { [$self->{_x}, $self->{_y}], [$self->{_dx}, $self->{_dy}] [$self->{_size}[0], $self->{_size}[1]] }";
}

1;
