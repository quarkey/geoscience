#!/usr/bin/perl

use warnings;
use strict;
use Term::ANSIColor qw(:constants);


my $coordsfile = shift;

if ( -e $coordsfile ) {
    print "INFO: reading $coordsfile\n\n";
}
else {
    print "INFO: Unable to read coordinate file\n";
    die();
}
open my $handle, '<', $coordsfile;
chomp( my @coords = <$handle> );
close $handle;

my @polyX;
my @polyY;
my $x;
my $y;

my $points = 0;
my $area;

print "\tX\tY\n\n";

foreach my $xy (@coords) {
    my @seperated = split( ",", $xy );

    push @polyX, $seperated[0];
    push @polyY, $seperated[1];
    print "\t$seperated[0]\t$seperated[1]\n";
    $points++;
}

print "INFO: Found $points points in $coordsfile\n";

if ( ( $polyX[0] != $polyX[ $points - 1 ] )
    and $polyY[0] != ( $polyY[ $points - 1 ] ) )
{
    print YELLOW, "WARNING: Not a closed polygon, adding x=$polyX[0] y=$polyY[0] to close it.\n", RESET;

    push @polyX, $polyX[0];
    push @polyY, $polyY[0];
}

for ( my $i = 0 ; $i < $points ; $i++ ) {
    #print "CALC: x: " . $polyX[$i] * $polyY[ $i + 1 ];
    #print " y: " . $polyY[$i] * $polyX[ $i + 1 ] . "\n";
    $x += $polyX[$i] * $polyY[ $i + 1 ];
    $y += $polyY[$i] * $polyX[ $i + 1 ];
    print "INFO: Distance for "
      . ( $i + 1 )
      . " XY direction "
      . ( $polyX[ $i + 1 ] - $polyX[$i] ) . "/"
      . ( $polyY[ $i + 1 ] - $polyY[$i] ) . "\n";
}
$area = ( $x - $y ) / 2.0;
my $km2 = $area / 1000 / 1000;
print GREEN, "RESULT: Area of polygon: $area meters or $km2 km2 \n", RESET;