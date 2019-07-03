#!/usr/bin/perl
#
# This exists to address:
#  https://github.com/m-labs/nmigen/issues/12
#  "Yosys doesn't support true dual port inference, port A is always write and port B is always read.”
# https://github.com/YosysHQ/yosys/issues/504
#
# extended to also address:
#   $_DFFSR_PPP_ not being mapped
#
#   remapping the yosys mapped RAMB36E1 ...both cell name and its signals
#

use strict;
use warnings;
use List::Util qw[min max];
use Data::Dumper; # debug

my $filename = $ARGV[0];
my $output = $ARGV[1];

# use these to control if adding port modifier to signals
#  still need this with latest symbiflow-arch-def since still handling mixed r/w ports here
my $use_port_modifier=1;
#  don't need this since latest symbiflow-arch-def (cell mapping in yosys, actually)
#    takes care of U/L ports for the one that yosys can map
my $translate_ramb36e1=0;



sub connect_port {
  my $modifier=$_[0]; # do we need to connect U and L ports?
  my $basename=$_[1]; # root subckt port name
  my $signal=$_[2]; # signal to attach
	if ($modifier)
	  {
	    return($basename."L=$signal ".$basename."U=$signal ");
	  }
	else
	  {
	    return($basename."=$signal ");
	  }
  
}

sub connect_indexed_port {
  my $modifier=$_[0]; # do we need to connect U and L ports?
  my $basename=$_[1]; # root sbckt port name
  my $index=$_[2]; # index number
  my $signal=$_[3]; # signal to attach
	if ($modifier)
	  {
	    return($basename."L[$index]=$signal ".$basename."U[$index]=$signal ");
	  }
	else
	  {
	    return($basename."[$index]=$signal ");
	  }
  
}
my %port_enable;

open(my $outf, '>', $output);
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    my $consume_row=0;
 
    if ($row =~ /.subckt\s+\$_DFFSR_PPP_\s+(.*)/)
      {
	$consume_row=1;
	my $dff_signals=$1;
	my %sigmap = split /\s+|=/,$dff_signals;
	my $clear_input=$sigmap{"D"} . "and" . $sigmap{"R"};
	if ($sigmap{"D"} eq "\$false")
	  {
	    $clear_input=$sigmap{"R"};
	  }
	else
	  {
	    # share same name map as port_enable
	    if (not (exists $port_enable{$clear_input}))
	      {
		print $outf ".names $sigmap{'D'}  $sigmap{'R'} $clear_input\n";
		print $outf "10 1\n";
	      }
	  }
	# assuming ok to no reset when CE not asserted
	#  if need to force reset when CE not asserted
	#   ...may also need OR gate on CE and the R signal to create the CE to use
	print $outf ".subckt FDSE_ZINI ";
	print $outf "C=$sigmap{'C'} ";
	if (exists $sigmap{'CE'})
	  {
	    print $outf "CE=$sigmap{'CE'} ";
	  }
	else
	  {
	    print $outf "CE=\$true ";
	  }
	print $outf "S=$sigmap{'S'} ";
	print $outf "D=$clear_input ";
	print $outf "Q=$sigmap{'Q'} ";
	print $outf "\n";
      }

    # rename...since yosys seems to use different name
    if (($row =~ /.subckt\s+RAMB36E1\s+(.*)/) and ($translate_ramb36e1>0))
      {
	my $ram_signals=$1;
	print $outf ".subckt RAMB36E1_PRIM ";
	my %sigmap = split /\s+|=/,$ram_signals;
	my $port_name;
	foreach $port_name (keys %sigmap)
	{
	  
	  my $signal = $sigmap{$port_name};
	  if (($port_name =~ /DI/)
	      or ($port_name =~ /DO/)
	      or ($port_name =~ /CASCADE/)
	     )
	    {
	      print $outf "$port_name=$signal ";
	    }
	  elsif ($port_name eq "RSTRAMARSTRAM")
	    {
	      print $outf "RSTRAMARSTRAMLRST=$signal ";
	    }
	  else
	    {
	      if ($port_name =~ /(.+)\[(.+)\]/)
		{
		  # print "$port_name has brackets with prefix $1 and index $2\n";
		  print $outf "$1" . "L\[$2\]=$signal ";
		}
	      else {
		print $outf "$port_name" . "L=$signal ";
	      }
	    }
	}
	print $outf "\n";
	$consume_row=1;

      }
    elsif (($row =~ /.subckt\s+\$__XILINX_RAMB36_TDP_RW\s+(.*)/)
	   or ($row =~ /.subckt\s+\$__XILINX_RAMB36_TDP_RW\s+(.*)/))
      {
	my $ram_signals;
	my $ram_type;
	my $ramb18=0;
	my $add_port_modifiers=0;
	if ($use_port_modifier>0)
	  {
	    $add_port_modifiers=1;
	  }
	if ($row =~ /.subckt\s+\$__XILINX_RAMB36_TDP_RW\s+(.*)/)
	  {
	    $ram_type="RAMB36E1_PRIM";
	    $ram_signals=$1;
	  }
	elsif ($row =~ /.subckt\s+\$__XILINX_RAMB18_TDP_RW\s+(.*)/)
	  {
	    $ramb18=1;
	    $add_port_modifiers=0; # no L/U for RAMB18
	    $ram_type="RAMB18E1_VPR";
	    $ram_signals=$1;
	  }
	my $port0_read_prefix="";
	my $port0_write_prefix="";
	my $port1_read_prefix="";
	my $port1_write_prefix="";
	my $port0_enable_name="";
	my $port1_enable_name="";

	# print $ram_signals;
	
	my %sigmap = split /\s+|=/,$ram_signals;
	
	my $unmapped_A1=((exists $sigmap{'A1ADDR[1]'}) and ($sigmap{'A1ADDR[1]'} ne "\$false"));
	my $unmapped_A2=((exists $sigmap{'A2ADDR[1]'}) and ($sigmap{'A2ADDR[1]'} ne "\$false"));
	my $unmapped_B1=((exists $sigmap{'B1ADDR[1]'}) and ($sigmap{'B1ADDR[1]'} ne "\$false"));
	my $unmapped_B2=((exists $sigmap{'B2ADDR[1]'}) and ($sigmap{'B2ADDR[1]'} ne "\$false"));


	if ($unmapped_A1)
	  {
	    if (($sigmap{'A1ADDR[1]'} eq $sigmap{'B1ADDR[1]'})
		and ($sigmap{'A1ADDR[1]'} ne $sigmap{'B2ADDR[1]'}))
	      {
		$port0_read_prefix='B1';
		$unmapped_A1=0;
		$port0_write_prefix='A1';
		$unmapped_B1=0;
	      }
	    elsif (($sigmap{'A1ADDR[1]'} ne $sigmap{'B1ADDR[1]'})
		   and ($sigmap{'A1ADDR[1]'} eq $sigmap{'B2ADDR[1]'}))
	      {
		$port0_read_prefix='B2';
		$unmapped_A1=0;
		$port0_write_prefix='A1';
		$unmapped_B2=0;
	      }
	    elsif (($sigmap{'A1ADDR[1]'} eq $sigmap{'B1ADDR[1]'})
		   and ($sigmap{'A1ADDR[1]'} eq $sigmap{'B2ADDR[1]'}))
	      {
		die("A1 address could match B1 or B2 for $row");
	      }
	    elsif (exists $sigmap{'A1ADDR[1]'})
	      {
		$port0_write_prefix='A1';
		$port0_read_prefix='';
		$unmapped_A1=0;
	      }
	  }

	if ($unmapped_A2)
	  {
	     
	    if (($sigmap{'A2ADDR[1]'} eq $sigmap{'B1ADDR[1]'})
		and ($sigmap{'A2ADDR[1]'} ne $sigmap{'B2ADDR[1]'}))
	      {
		$port1_read_prefix='B1';
		$unmapped_A2=0;
		$port1_write_prefix='A2';
		$unmapped_B1=0;
	      }
	    elsif (($sigmap{'A2ADDR[1]'} ne $sigmap{'B1ADDR[1]'})
		   and ($sigmap{'A2ADDR[1]'} eq $sigmap{'B2ADDR[1]'}))
	      {
		$port1_read_prefix='B2';
		$unmapped_A2=0;
		$port1_write_prefix='A2';
		$unmapped_B2=0;
	      }
	    elsif (($sigmap{'A2ADDR[1]'} eq $sigmap{'B1ADDR[1]'})
		   and ($sigmap{'A2ADDR[1]'} eq $sigmap{'B2ADDR[1]'}))
	      {
		die("A2 address could match B1 or B2 for $row");
	      }
	    elsif (exists $sigmap{'A2ADDR[1]'})
	      {
		$port1_read_prefix='';
		$port1_write_prefix='A2';
		$unmapped_A2=0;
	      }
	  }

	# singleton ports
	if (($port0_write_prefix ne 'A1') and $unmapped_B1)
	  {
	    $port0_read_prefix='B1';
	    $port0_write_prefix='';
	    $unmapped_B1=0;
	  }
	elsif (($port0_write_prefix ne 'A1') and $unmapped_B2)
	  {
	    $port0_read_prefix='B2';
	    $port0_write_prefix='';
	    $unmapped_B2=0;
	  }
	if (($port1_write_prefix ne 'A2') and $unmapped_B1)
	  {
	    $port1_read_prefix='B1';
	    $port1_write_prefix='';
	    $unmapped_B1=0;
	  }
	elsif (($port0_write_prefix ne 'A2') and $unmapped_B2)
	  {
	    $port1_read_prefix='B2';
	    $port1_write_prefix='';
	    $unmapped_B2=0;
	  }

	# check and die if any unmapped...
	if ($unmapped_A1 or $unmapped_A2 or $unmapped_B1 or $unmapped_B2)
	  {
	    print "port 0: read=$port0_read_prefix write=$port0_write_prefix\n";
	    print "port 1: read=$port1_read_prefix write=$port1_write_prefix\n";

	    if ($unmapped_A1) {print "A1 unmapped\n"};
	    if ($unmapped_A2) {print "A2 unmapped\n"};
	    if ($unmapped_B1) {print "B1 unmapped\n"};
	    if ($unmapped_B2) {print "B2 unmapped\n"};

	    die("Not all ports were mapped on $row");
	  }


	print "port 0: read=$port0_read_prefix write=$port0_write_prefix; ";
	print "port 1: read=$port1_read_prefix write=$port1_write_prefix\n";

	# Probably not necessary... with revision...
	#  ...but may need to extract bit about defininging port#_prefix's if remove
	my $port0_prefix=$port0_read_prefix;
	my $port1_prefix=$port1_read_prefix;
	if (($port0_read_prefix ne "") and  ($port0_write_prefix ne ""))
	  {
	    #print "port0 prefixes $sigmap{$port0_read_prefix . 'ADDR[1]'} $sigmap{$port0_write_prefix . 'ADDR[1]'}\n";
	    # note -- only checking one address
	    #   ...more robust would be to check full set
	    if ($sigmap{$port0_read_prefix . 'ADDR[1]'} ne $sigmap{$port0_write_prefix . 'ADDR[1]'})
	      {die("Mismatched addresses will prevent merging");}
	  }
	elsif ($port0_write_prefix ne "")
	  {
	    $port0_prefix=$port0_write_prefix;
	  }
	if (($port1_read_prefix ne "") and  ($port1_write_prefix ne ""))
	  {
	   # print "port1 prefixes $sigmap{$port1_read_prefix . 'ADDR[1]'} $sigmap{$port1_write_prefix . 'ADDR[1]'}\n";
	    # note -- only checking one address
	    #   ...more robust would be to check full set
	    if ($sigmap{$port1_read_prefix . 'ADDR[1]'} ne $sigmap{$port1_write_prefix . 'ADDR[1]'})
	      {die("Mismatched addresses will prevent merging");}
	  }
	elsif ($port1_write_prefix ne "")
	  {
	    $port1_prefix=$port1_write_prefix;
	  }

	# if did not die, we have a consistent set of ports for mapping
	# now we write out the actual mapping...

	
	#add OR gate for CE
	my $port0_read_signal="";
	my $port0_write_signal="";
	if ($port0_read_prefix ne "")
	  {
	    # ... create name
	    if (exists $sigmap{$port0_read_prefix . 'EN'})
	      {
		$port0_read_signal=$sigmap{$port0_read_prefix . 'EN'};
	      }
	    elsif (exists $sigmap{$port0_read_prefix . 'EN[0]'})
	      {
		$port0_read_signal=$sigmap{$port0_read_prefix . 'EN[0]'};
	      }
	    else
	      {
		die("No enable signal for port $port0_read_prefix in $row");
	      }
	  }
	if ($port0_write_prefix ne "")
	  {
	    if (exists $sigmap{$port0_write_prefix . 'EN'})
	      {
		$port0_write_signal=$sigmap{$port0_write_prefix . 'EN'};
	      }
	    elsif (exists $sigmap{$port0_write_prefix . 'EN[0]'})
	      {
		$port0_write_signal=$sigmap{$port0_write_prefix . 'EN[0]'};
	      }
	    else
	      {
		die("No enable signal for port $port0_write_prefix in $row");
	      }
	  }
	
	if (($port0_read_prefix ne "") and ($port0_write_prefix ne ""))
	  {

	    # FUTURE -- this matches the current assumption that the enables
	    #   aren't really controlled independently....so one bit from
	    #   each is sufficient.
	    #  In the future, this might should be an OR of all the enables bits.
	    
	    $port0_enable_name= $port0_read_signal . "or" . $port0_write_signal;
	    
	    # ... see if already have this OR
	    if (not (exists $port_enable{$port0_enable_name}))
	      {
		# ...  create new OR and stick in map
		print $outf ".names $port0_read_signal $port0_write_signal $port0_enable_name\n";
		print $outf "10 1\n";
		print $outf "01 1\n";
		print $outf "11 1\n";
		$port_enable{$port0_enable_name}=1;
	      }

	    # ... use that name for CE
	  }
	elsif ($port0_read_prefix ne "")
	  {
	    $port0_enable_name=$port0_read_signal;
	  }
	elsif ($port0_write_prefix ne "")
	  {
	    $port0_enable_name=$port0_write_signal;
	  }
	else
	  {
	    $port0_enable_name="\$false";
	  }

	#add OR gate for CE
	my $port1_read_signal="";
	my $port1_write_signal="";
	if ($port1_read_prefix ne "")
	  {
	    # ... create name
	    if (exists $sigmap{$port1_read_prefix . 'EN'})
	      {
		$port1_read_signal=$sigmap{$port1_read_prefix . 'EN'};
	      }
	    elsif (exists $sigmap{$port1_read_prefix . 'EN[0]'})
	      {
		$port1_read_signal=$sigmap{$port1_read_prefix . 'EN[0]'};
	      }
	    else
	      {
		die("No enable signal for port $port1_read_prefix in $row");
	      }
	  }
	if ($port1_write_prefix ne "")
	  {
	    if (exists $sigmap{$port1_write_prefix . 'EN'})
	      {
		$port1_write_signal=$sigmap{$port1_write_prefix . 'EN'};
	      }
	    elsif (exists $sigmap{$port1_write_prefix . 'EN[0]'})
	      {
		$port1_write_signal=$sigmap{$port1_write_prefix . 'EN[0]'};
	      }
	    else
	      {
		die("No enable signal for port $port1_write_prefix in $row");
	      }
	  }
	
	if (($port1_read_prefix ne "") and ($port1_write_prefix ne ""))
	  {


	    # FUTURE -- this matches the current assumption that the enables
	    #   aren't really controlled independently....so one bit from
	    #   each is sufficient.
	    #  In the future, this might should be an OR of all the enables bits.
	    
	    $port1_enable_name= $port1_read_signal . "or" . $port1_write_signal;
	    
	    # ... see if already have this OR
	    if (not (exists $port_enable{$port1_enable_name}))
	      {
		# ...  create new OR and stick in map
		print $outf ".names $port1_read_signal $port1_write_signal $port1_enable_name\n";
		print $outf "10 1\n";
		print $outf "01 1\n";
		print $outf "11 1\n";
		$port_enable{$port1_enable_name}=1;
	      }

	    # ... use that name for CE
	  }
	elsif ($port1_read_prefix ne "")
	  {
	    $port1_enable_name=$port1_read_signal;
	  }
	elsif ($port1_write_prefix ne "")
	  {
	    $port1_enable_name=$port1_write_signal;
	  }
	else
	  {
	    $port1_enable_name="\$false";
	  }
	

	my $cfg_abits=10;
	my $cfg_dbits=36;
	my $clk_pol2=1;
	my $clk_pol3=1;
	my $cfg_enable_b=4;
	my $cfg_enable_a=4;
	my $cname="";

	my $nline = <$fh>;
	chomp $nline;
	$consume_row=1;
	
	#read cname	
	#ead CFG_ABITS, CFG_DBITS, CLK_POL2, CLK_POL3, CFG_ENABLE_B, CFG_ENABLE_A ?
	# try stop when hit INIT
	#  ...and put that in row and not set  / unset thing that prevents printing row
	while ($nline and (not (($nline =~ /.param INIT/)
				or ($nline =~ /.end/)
				or ($nline =~ /.param TRANSP/)
				or ($nline =~ /.subckt/)
				or ($nline =~ /.names/))))
	  {
	    if ($nline =~ /.cname/)
	      { $cname=$nline; }
	    elsif ($nline =~ /.param\s+CFG_ABITS\s+(.*)/)
	      {
		eval "\$cfg_abits=0b$1;";
	      }
	    elsif ($nline =~ /.param\s+CFG_DBITS\s+(.*)/)
	      {
		eval "\$cfg_dbits=0b$1;";
	      }
	    elsif ($nline =~ /.param\s+CFG_ENABLE_B\s+(.*)/)
	      {
		eval "\$cfg_enable_b=0b$1;";
	      }
	    elsif ($nline =~ /.param\s+CFG_ENABLE_A\s+(.*)/)
	      {
		eval "\$cfg_enable_a=0b$1;";
	      }
	    elsif ($nline =~ /.param\s+CLKPOL2\s+(.*)/)
	      {
		eval "\$clk_pol2=0b$1;";
	      }

	    elsif ($nline =~ /.param\s+CLKPOL3\s+(.*)/)
	      {
		eval "\$clk_pol3=0b$1;";
	      }
	    else
	      {
		die("Unknown line: $nline\n for row $row");
	      }

	    $nline = <$fh>;
	    chomp $nline;
	  }

	if (($nline =~ /.param INIT/)
	    or ($nline =~ /.end/)
	    or ($nline =~ /.names/)
	    or ($nline =~ /.param TRANSP/)	    
	    or ($nline =~ /.subckt/))
	  {

	    # put it back, and allow it to be written to the file
	    $row=$nline;
	    $consume_row=0;
	  }

	# debug read
	#print "Abits=$cfg_abits Dbits=$cfg_dbits aenbits=$cfg_enable_a benbits=$cfg_enable_b clkpol2=$clk_pol2 clkpol3=$clk_pol3\n";
	
	#print $outf ".subckt RAMBFIFO36E1 ";
	print $outf ".subckt $ram_type ";
	#enables
	# These are the new or'ed chip enables
	#print "enables :$port0_enable_name:$port1_enable_name:";
	# Do we need to connect to both L and U variants? -- yes, we do
	print $outf connect_port($add_port_modifiers,"ENARDEN",$port0_enable_name);
	print $outf connect_port($add_port_modifiers,"ENBWREN",$port1_enable_name);
	# these are existing Write enable names
	for (my $i=0; $i<$cfg_enable_a; $i++)
	  {
	    # Q: should only be defining subset of enables based on configuration?
	    #  ...CFG_ENABLE_B  (really should be two?) ... CFG_ENABLE_A
	    #   ...but, what do they correspond to?
	    # ...not sure this is right mapping...
	    # Q: should be something else that says some of the bytes aren't enabled?
	    if ($port0_write_prefix ne "")
	      {
		# if ($cfg_enable_a>1)
		if (exists $sigmap{$port0_write_prefix . 'EN[$i]'})
		  {
		    print $outf connect_indexed_port($add_port_modifiers,"WEA",$i,$sigmap{$port0_write_prefix . 'EN[$i]'});
		  }
		else
		  {
		    print $outf connect_indexed_port($add_port_modifiers,"WEA",$i,$port0_write_signal);
		  }
	      }
	    else
	      {
		print $outf connect_indexed_port($add_port_modifiers,"WEA",$i,"\$false");
	      }
	  }
	for (my $i=0; $i<$cfg_enable_b; $i++)
	  {
	    if ($port1_write_prefix ne "")
	      {
		#if ($cfg_enable_b > 1)
		if (exists $sigmap{$port1_write_prefix . 'EN[$i]'})
		  {
		    print $outf connect_indexed_port($add_port_modifiers,"WEBWE",$i,$sigmap{$port1_write_prefix . 'EN[$i]'});

		  }
		else
		  {
		    print $outf connect_indexed_port($add_port_modifiers,"WEBWE",$i,$port1_write_signal);
		  }
	      }
	    else
	      {
		print $outf connect_indexed_port($add_port_modifiers,"WEBWE",$i,"\$false");
	      }
	  }
	#address
	for (my $i=0; $i<(15-$ramb18-$cfg_abits); $i++)
	  {
	    print $outf connect_indexed_port($add_port_modifiers,"ADDRARDADDR",$i,"\$false");
	    print $outf connect_indexed_port($add_port_modifiers,"ADDRBWRADDR",$i,"\$false");
	  }
	for (my $i=0; $i<$cfg_abits; $i++)
	  {
	    my $ri=$i+(15-$ramb18-$cfg_abits);
	    my $p0name=$port0_prefix . "ADDR[$i]" ;
	    my $p1name=$port1_prefix . "ADDR[$i]" ;


	    if ($port0_prefix ne "")
	      {
		print $outf connect_indexed_port($add_port_modifiers,"ADDRARDADDR",$i,$sigmap{$p0name});
	      }
	    else
	      {
		print $outf connect_indexed_port($add_port_modifiers,"ADDRARDADDR",$i,"\$false");
	      }
	      
	    if ($port1_prefix ne "")
	      {
		print $outf connect_indexed_port($add_port_modifiers,"ADDRBWRDADDR",$i,$sigmap{$p1name});
	      }
	    else
	      {
		print $outf connect_indexed_port($add_port_modifiers,"ADDRBWRDADDR",$i,"\$false");
	      }
	  }
        # print Dumper(\%sigmap);
	#data in
	if ($port0_write_prefix ne "")
	  {
	    #print "port0 write prefix $port0_write_prefix\n";
	    for (my $i=0; $i<min($cfg_dbits,32); $i++)
	      {
		my $p0name=$port0_write_prefix . "DATA[$i]" ;
		if ($cfg_dbits==1)
		  {
		    $p0name=$port0_write_prefix . "DATA" ;
		  }
		print $outf "DIADI[$i]=$sigmap{$p0name} ";
	      }
	    for (my $i=32; $i<$cfg_dbits; $i++)
	      {
		my $ploc=$i-32;
		my $p0name=$port0_write_prefix . "DATA[$i]" ;
		print $outf "DIPADIP[$ploc]=$sigmap{$p0name} ";
	      }
	  }
	if ($port1_write_prefix ne "")
	  {
	    #print "port1 write prefix $port1_write_prefix\n";
	    for (my $i=0; $i<min($cfg_dbits,32); $i++)
	      {
		my $p1name=$port1_write_prefix . "DATA[$i]" ;
		if ($cfg_dbits==1)
		  {
		    $p1name=$port1_write_prefix . "DATA" ;
		  }
		print $outf "DIBDI[$i]=$sigmap{$p1name} ";
	      }
	    for (my $i=32; $i<$cfg_dbits; $i++)
	      {
		my $ploc=$i-32;
		my $p1name=$port1_write_prefix . "DATA[$i]" ;
		print $outf "DIPBDIP[$ploc]=$sigmap{$p1name} ";
	      }
	  }
	
	#data out
	if ($port0_read_prefix ne "")
	  {
	    for (my $i=0; $i<min($cfg_dbits,32); $i++)
	      {
		my $p0name=$port0_read_prefix . "DATA[$i]" ;
		if ($cfg_dbits==1)
		  {
		    $p0name=$port0_read_prefix . "DATA" ;
		  }
		print $outf "DOADO[$i]=$sigmap{$p0name} ";
	      }
	    for (my $i=32; $i<$cfg_dbits; $i++)
	      {
		my $ploc=$i-32;
		my $p0name=$port0_read_prefix . "DATA[$i]" ;
		print $outf "DOPADOP[$ploc]=$sigmap{$p0name} ";
	      }
	  }
	if ($port1_read_prefix ne "")
	  {
	    for (my $i=0; $i<min($cfg_dbits,32); $i++)
	      {
		my $p1name=$port1_read_prefix . "DATA[$i]" ;
		if ($cfg_dbits==1)
		  {
		    $p1name=$port1_read_prefix . "DATA" ;
		  }
		print $outf "DOBDO[$i]=$sigmap{$p1name} ";
	      }
	    for (my $i=32; $i<$cfg_dbits; $i++)
	      {
		my $ploc=$i-32;
		my $p1name=$port1_read_prefix . "DATA[$i]" ;
		print $outf "DOPBDOP[$ploc]=$sigmap{$p1name} ";
	      }
	  }
	
	#clocks
	print $outf connect_port($add_port_modifiers,"CLKARDCLK",$sigmap{'CLK2'});
	print $outf connect_port($add_port_modifiers,"CLKBWRCLK",$sigmap{'CLK3'});
	# reset
	if ($ramb18 or ($use_port_modifier==0)) # special case because modification is LRST not L
	  {
	    print $outf "RSTRAMARSTRAM=\$false ";
	  }
	else
	  {
	    print $outf "RSTRAMARSTRAMLRST=\$false ";
	    print $outf "RSTRAMARSTRAMU=\$false ";   
	  }
	print $outf connect_port($add_port_modifiers,"RSTREGARSTREG","\$false");
	print $outf connect_port($add_port_modifiers,"RSTRAMB","\$false");
	print $outf connect_port($add_port_modifiers,"RSTREGB","\$false");
	#? reg
	print $outf connect_port($add_port_modifiers,"REGCEAREGCE","\$false");
	print $outf connect_port($add_port_modifiers,"REGCEB","\$false");
	print $outf "\n";
	if ($cname ne "")
	  {	print $outf "$cname\n"; }
	# ... parameters ...
	print $outf ".param DOA_REG 0\n";
	print $outf ".param DOB_REG 0\n";
	print $outf ".param IN_USE 1\n";
	# Note: Xilinx allows port widths (and read/write on same port)
	#     to all be different, but we're only getting one width from yosys.
	#  Hopefully HLS is only using the same widthds as well...
	if ($cfg_dbits==1)
	  {  print $outf ".param READ_WIDTH_A_1 1\n";}
	else
	  {  print $outf ".param READ_WIDTH_A_1 0\n";}
	if ($cfg_dbits==18)
	  { print $outf ".param READ_WIDTH_A_18 1\n";}
	else
	  { print $outf ".param READ_WIDTH_A_18 0\n";}
	if ($cfg_dbits==2)
	  { print $outf ".param READ_WIDTH_A_2 1\n";}
	else
	  { print $outf ".param READ_WIDTH_A_2 0\n";}
	if ($cfg_dbits==4)
	  { print $outf ".param READ_WIDTH_A_4 1\n";}
	else
	  { print $outf ".param READ_WIDTH_A_4 0\n";}
	if ($cfg_dbits==9)
	  { print $outf ".param READ_WIDTH_A_9 1\n";}
	else
	  { print $outf ".param READ_WIDTH_A_9 0\n";}
	if ($cfg_dbits==36)
	  { print $outf ".param READ_WIDTH_A_36 1\n";}
	else
	  { print $outf ".param READ_WIDTH_A_36 0\n";}
	#Q: is there a 32, 16, 8?
	if ($cfg_dbits==1)
	  {  print $outf ".param READ_WIDTH_B_1 1\n";}
	else
	  {  print $outf ".param READ_WIDTH_B_1 0\n";}
	if ($cfg_dbits==18)
	  { print $outf ".param READ_WIDTH_B_18 1\n";}
	else
	  { print $outf ".param READ_WIDTH_B_18 0\n";}
	if ($cfg_dbits==2)
	  { print $outf ".param READ_WIDTH_B_2 1\n";}
	else
	  { print $outf ".param READ_WIDTH_B_2 0\n";}
	if ($cfg_dbits==4)
	  { print $outf ".param READ_WIDTH_B_4 1\n";}
	else
	  { print $outf ".param READ_WIDTH_B_4 0\n";}
	if ($cfg_dbits==9)
	  { print $outf ".param READ_WIDTH_B_9 1\n";}
	else
	  { print $outf ".param READ_WIDTH_B_9 0\n";}
	if ($cfg_dbits==36)
	  { print $outf ".param READ_WIDTH_B_36 1\n";}
	else
	  { print $outf ".param READ_WIDTH_B_36 0\n";}
	# This is TDB, so maybe not need these?...
	print $outf ".param SDP_READ_WIDTH_36 0\n";
	print $outf ".param SDP_WRITE_WIDTH_36 0\n";
	print $outf ".param WRITE_MODE_A_NO_CHANGE 0\n";
	print $outf ".param WRITE_MODE_A_READ_FIRST 1\n";
	print $outf ".param WRITE_MODE_B_NO_CHANGE 0\n";
	print $outf ".param WRITE_MODE_B_READ_FIRST 1\n";
	if ($cfg_dbits==1)
	  {  print $outf ".param WRITE_WIDTH_A_1 1\n";}
	else
	  {  print $outf ".param WRITE_WIDTH_A_1 0\n";}
	if ($cfg_dbits==18)
	  { print $outf ".param WRITE_WIDTH_A_18 1\n";}
	else
	  { print $outf ".param WRITE_WIDTH_A_18 0\n";}
	if ($cfg_dbits==2)
	  { print $outf ".param WRITE_WIDTH_A_2 1\n";}
	else
	  { print $outf ".param WRITE_WIDTH_A_2 0\n";}
	if ($cfg_dbits==4)
	  { print $outf ".param WRITE_WIDTH_A_4 1\n";}
	else
	  { print $outf ".param WRITE_WIDTH_A_4 0\n";}
	if ($cfg_dbits==9)
	  { print $outf ".param WRITE_WIDTH_A_9 1\n";}
	else
	  { print $outf ".param WRITE_WIDTH_A_9 0\n";}
	if ($cfg_dbits==36)
	  { print $outf ".param WRITE_WIDTH_A_36 1\n";}
	else
	  { print $outf ".param WRITE_WIDTH_A_36 0\n";}
	#Q: is there a 32, 16, 8?
	if ($cfg_dbits==1)
	  {  print $outf ".param WRITE_WIDTH_B_1 1\n";}
	else
	  {  print $outf ".param WRITE_WIDTH_B_1 0\n";}
	if ($cfg_dbits==18)
	  { print $outf ".param WRITE_WIDTH_B_18 1\n";}
	else
	  { print $outf ".param WRITE_WIDTH_B_18 0\n";}
	if ($cfg_dbits==2)
	  { print $outf ".param WRITE_WIDTH_B_2 1\n";}
	else
	  { print $outf ".param WRITE_WIDTH_B_2 0\n";}
	if ($cfg_dbits==4)
	  { print $outf ".param WRITE_WIDTH_B_4 1\n";}
	else
	  { print $outf ".param WRITE_WIDTH_B_4 0\n";}
	if ($cfg_dbits==9)
	  { print $outf ".param WRITE_WIDTH_B_9 1\n";}
	else
	  { print $outf ".param WRITE_WIDTH_B_9 0\n";}
	if ($cfg_dbits==36)
	  { print $outf ".param WRITE_WIDTH_B_36 1\n";}
	else
	  { print $outf ".param WRITE_WIDTH_B_36 0\n";}
	
	print $outf ".param WRITE_WIDTH_A_1 0\n";
	print $outf ".param WRITE_WIDTH_A_18 0\n";
	print $outf ".param WRITE_WIDTH_A_2 0\n";
	print $outf ".param WRITE_WIDTH_A_4 0\n";
	print $outf ".param WRITE_WIDTH_A_9 1\n";
	print $outf ".param WRITE_WIDTH_B_1 0\n";
	print $outf ".param WRITE_WIDTH_B_18 0\n";
	print $outf ".param WRITE_WIDTH_B_2 0\n";
	print $outf ".param WRITE_WIDTH_B_4 0\n";
	print $outf ".param WRITE_WIDTH_B_9 1\n";
        my $notclkpol2= 1-$clk_pol2;
	print $outf ".param IS_CLKARDCLK_INVERTED  $notclkpol2\n";
        my $notclkpol3=1-$clk_pol3;
	print $outf ".param IS_CLKBWRCLK_INVERTED  $notclkpol3\n";
	

      }

    if ($consume_row==0) # skip the ones read a port enables
      { print $outf "$row\n"; }
    
  }
} else {
  warn "Could not open file '$filename' $!";
  close $outf;
}
 
