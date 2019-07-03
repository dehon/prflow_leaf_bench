#!/usr/bin/perl
#
use strict;
use warnings;

my $name = $ARGV[0];
use Scalar::Util qw(looks_like_number);

my $cells="none";
my $luts="none";
my $ramb18=0;
my $ramb18m=0;
my $ramb36d=0;
my $ramb36m=0;
my $m18x25=0;
my $yosys="none";
my $slicel="none";
my $slicem="none";
my $bram_l="none";
my $dsp_r="none";
my $pack="none";
my $place="none";
my $route="none";

my $outf;
if (not(open($outf, '>', "$name/summary.csv")))
  {
    print "cannot open $name/summary.csv\n";
    exit();
  }

if (open(my $fh, '<:encoding(UTF-8)', "$name/num_cells")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /\s*Number of cells:\s*(.*)/)
      {
	$cells=$1;
	chomp $cells;
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/yosys_runtime")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /.*CPU:\s*user\s*([0-9]*).*/)
      {
	$yosys=$1;
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/num_m18x25")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /\s*M18x25\s*(.*)/)
      {
	my $tmp=$1;
	chomp $tmp;
	if (looks_like_number($tmp))
	  {
	    $m18x25=$tmp;
	  }
	else
	  {
	    $m18x25=0;
	  }
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/num_luts")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /\s*\$lut\s*(.*)/)
      {
	$luts=$1;
	chomp $luts;
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/num_ramb18")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /\s*RAMB18E1_VPR\s*(.*)/)
      {
	my $tmp=$1;
	chomp $tmp;
	if (looks_like_number($tmp))
	  {
	    $ramb18=$tmp;
	  }
	else
	  {
	    $ramb18=0;
	  }
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/num_ramb36dedicated_ports")) {
  $ramb36d=0;
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /\s*RAMB36E1_PRIM\s*(.*)/)
      {
	my $tmp=$1;
	chomp $tmp;
	if (looks_like_number($tmp))
	  {
	    $ramb36d=$tmp;
	  }
      }
    else
      {
	if ($row =~ /\s*RAMB36E1\s*(.*)/)
	  {
	    my $tmp=$1;
	    chomp $tmp;
	    if (looks_like_number($tmp))
	      {
		$ramb36d=$tmp;
	      }
	  }
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/num_ramb36merge_ports")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /\s*\$__XILINX_RAMB36_TDP_RW\s*(.*)/)
      {
	my $tmp=$1;
	chomp $tmp;
	if (looks_like_number($tmp))
	  {
	    $ramb36m=$tmp;
	  }
	else
	  {
	    $ramb36m=0;
	  }
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/num_ramb18merge_ports")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /\s*\$__XILINX_RAMB18_TDP_RW\s*(.*)/)
      {
	my $tmp=$1;
	chomp $tmp;
	if (looks_like_number($tmp))
	  {
	    $ramb18m=$tmp;
	  }
	else
	  {
	    $ramb18m=0;
	  }
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/packed_slicem_stats")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /\s*BLK-TL-SLICEM\s*:\s#\sblocks:\s*([0-9]*),.*/)
      {
	$slicem=$1;
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/packed_slicel_stats")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /\s*BLK-TL-SLICEL\s*:\s#\sblocks:\s*([0-9]*),.*/)
      {
	$slicel=$1;
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/packed_bram_l_stats")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /\s*BLK-TL-BRAM_L\s*:\s#\sblocks:\s*([0-9]*),.*/)
      {
	$bram_l=$1;
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/packed_dsp_r_stats")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /\s*BLK-TL-DSP_R\s*:\s#\sblocks:\s*([0-9]*),.*/)
      {
	$dsp_r=$1;
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/packing_time")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /#\sPacking\stook\s*([0-9]*).*/)
      {
	$pack=$1;
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/out.place.time")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /([0-9]*)inputs.*/)
      {
	# skip
      }
    elsif ($row =~ /([0-9]*)\..*/)
      {
	$place=$1;
      }
  }
  close $fh;
}

if (open(my $fh, '<:encoding(UTF-8)', "$name/out.route.time")) {
  while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ /([0-9]*)inputs.*/)
      {
	# skip
      }
    elsif ($row =~ /([0-9]*)\..*/)
      {
	$route=$1;
      }
  }
  close $fh;
}

if (not (open(my $fh, '<:encoding(UTF-8)', "$name/out.route")))
  {
    $route="noroute";
  }

if (not (open(my $fh, '<:encoding(UTF-8)', "$name/out.place")))
  {
    $place="noplace";
  }

print $outf "$name,$yosys,$cells,$luts,$ramb18,$ramb18m,$ramb36d,$ramb36m,$m18x25,$slicel,$slicem,$bram_l,$dsp_r,$pack,$place,$route\n";


close $outf;

