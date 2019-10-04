#!/usr/bin/perl

use strict;
use File::Copy qw(cp);

my $inFile = $ARGV[0];
my $outFile = $ARGV[1];

die "Usage: $0 [inputFile] [outputFile]" unless $inFile && $outFile;

die "No such file: $inFile" unless -f $inFile;

die "Sorry, I can't deal with filenames containing whitespace ($inFile)" if $inFile =~ /\s/;

my @party = qw(
  FA8C8E
  FCD890
  36FF89
  3DFFFC
  81B8FC
  F491FF
  FB8DFC
  FA69F5
  FA69B9
  FA696E
);

my @colors = qw(
  ffd400
  5a2149
  a8d491
  995ba2
  adbb37
);


#
# my @colors = qw(
#   8f6c48
#   bc9c7a
#   654c33
#   ab8158
#   5a2149
# );

my @frames;

for (my $i = 0; $i < @party; $i++) {
  cp($inFile, "party-frame-$i-0-$inFile");

  for (my $j = 0; $j < @colors; $j++) {
    my $fromColor = $colors[$j];
    my $toColor = $party[($j * 2 + $i) % @party];
    my $k = $j+1;
    my $tempIn = "party-frame-$i-$j-$inFile";
    my $tempOut = "party-frame-$i-$k-$inFile";

    system("magick convert -fill '#$toColor' -fuzz 10 -opaque '#$fromColor' '$tempIn' '$tempOut'");
  }

  push @frames, "party-frame-$i-$#colors-$inFile";
}

my $frames = join(' ', @frames);

system("magick convert -delay 4 -loop 0 -coalesce -layers OptimizeFrame $frames $outFile");




