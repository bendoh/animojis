#!/usr/bin/perl

use strict;
use File::Copy qw(cp);
use File::Basename qw(basename);

my $inFile = shift @ARGV;
my $outFile = shift @ARGV;

my %colorSets = (
  'wayfairColors' => [
    qw(
      ffd400
      5a2149
      a8d491
      995ba2
      adbb37
    )
  ],
  'brownBox' => [
    qw(
       8f6c48
       bc9c7a
       654c33
       ab8158
       5a2149
     )
   ],
   'purpleBox' => [
     qw(
       752e7b
       aa43b5
       c576c9
     )
   ],
   'blackAndWhite' => [
     qw(
      000000
      ffffff
      )
    ],
    'thankYou' => [
      qw(
        6699cc
      )
    ]
);

sub usage {
  my $colorsets = join(', ', keys %colorSets);

  print <<EOU;
Usage: $0 [inputFile] [outputFile] [color1|colorset] [color2...]

Replaces color1, color2, ... colorN with rotating party colors in inputFile
and writes the resulting animated gif to outputFile.

May specify a colorset instead of a list of colors.

Valid colorsets: $colorsets
EOU

  exit 0;
}

usage() unless $inFile && $outFile;

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

my @inputColors = @ARGV;


my @colors;

if ($colorSets{$inputColors[0]}) {
  @colors = @{$colorSets{$inputColors[0]}};
} else {
  @colors = grep { /^[0-9a-f]{6}$/i } @inputColors;

  if ($#colors != $#inputColors) {
    die "Invalid color(s) given. I expect 6-digit hex numbers like 123abc or baddad";
  }
}

if (@colors > 5) {
  die "Sorry, that's too many colors (" . @colors . ")";
}

print "Throwing a party for $inFile for colors [" . join(' ', @colors)  . "]... ";

my @frames;

my $baseName = basename($inFile);
my $numColors = scalar(@colors);

for (my $i = 0; $i < @party; $i++) {
  cp($inFile, "party-frame-$i-0-$baseName");

  for (my $j = 0; $j < @colors; $j++) {
    my $fromColor = $colors[$j];
    my $toColor = $party[($j * 2 + $i) % @party];
    my $k = $j+1;
    my $tempIn = "party-frame-$i-$j-$baseName";
    my $tempOut = "party-frame-$i-$k-$baseName";

    system("magick convert -fill '#$toColor' -fuzz 50 -opaque '#$fromColor' '$tempIn' '$tempOut'");
  }

  push @frames, "party-frame-$i-$numColors-$baseName";
}

my $frames = join(' ', @frames);

if (system("magick convert -delay 4 -loop 0 -coalesce -layers OptimizeFrame $frames $outFile") == 0) {
  print " done! -> $outFile\n";
}
