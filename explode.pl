#!/usr/bin/perl

use strict;

sub usage {
  print <<EOU;
Usage: $0 [inputFile] [outputFile]

Adds an explosion animation to a static image.
EOU

  exit 0;
}

my $inFile = shift @ARGV;
my $outFile = shift @ARGV;

print "in=$inFile out=$outFile";
if (!$inFile || !$outFile) {
  usage();
}

if (!-f $inFile) {
  die "No such input file: $inFile";
}

if (!-f "explosion.gif") {
  die "Missing explosion.gif";
}

system("
  convert -dispose Previous $inFile -resize 128x128 -background transparent -gravity center -extent 128x128 -set page +0+0 -set delay 100 explosion.gif -loop 0 $outFile
");
