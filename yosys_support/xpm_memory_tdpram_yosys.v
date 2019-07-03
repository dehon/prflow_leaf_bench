// ==============================================================
// 
// 
// wrapper to directly instantiate a BRAM
// 
// ==============================================================

`timescale 1 ns / 1 ps
module xpm_memory_tdpram_yosys (sleep,
			  clka, rsta, 
			  ena,            
			  regcea,         
			  wea,            
			  addra,          
			  dina,           
			  injectsbiterra,
			  injectdbiterra, 
			  douta,
			  sbiterra,       
			  dbiterra,       
			  clkb,           
			  rstb,           
			  enb,            
			  regceb,         
			  web,            
			  addrb,          
			  dinb,           
			  injectsbiterrb, 
			  injectdbiterrb, 
			  doutb,          
			  sbiterrb,       
			  dbiterrb);       
// OLD
parameter DWIDTH = 8;
parameter AWIDTH = 9;
parameter MEM_SIZE = 500;

  // Common module parameters
parameter MEMORY_SIZE=512;
parameter MEMORY_PRIMITIVE="block";
parameter CLOCKING_MODE="independent_clock";
parameter MEMORY_INIT_FILE="none";
parameter MEMORY_INIT_PARAM  =""    ;
parameter USE_MEM_INIT       =1;
parameter WAKEUP_TIME        ="disable_sleep";
parameter MESSAGE_CONTROL    =0;
parameter ECC_MODE           ="no_ecc";
parameter AUTO_SLEEP_TIME    =0;

  // Port A module parameters
parameter WRITE_DATA_WIDTH_A =64;
parameter READ_DATA_WIDTH_A  =64;
parameter BYTE_WRITE_WIDTH_A =64;
parameter ADDR_WIDTH_A       =10;
parameter READ_RESET_VALUE_A ="0";
parameter READ_LATENCY_A     =1;
parameter WRITE_MODE_A       ="write_first";

  // Port B module parameters
parameter WRITE_DATA_WIDTH_B =64;
parameter READ_DATA_WIDTH_B  =64;
parameter BYTE_WRITE_WIDTH_B =64;
parameter ADDR_WIDTH_B       =10;
parameter READ_RESET_VALUE_B ="0";
parameter READ_LATENCY_B     =1;
parameter WRITE_MODE_B       ="write_first";


// new
// common
input sleep;
  // Port A module ports
input clka;
input rsta;
input ena;
input regcea;
input wea;
input [ADDR_WIDTH_A-1:0] addra;
input [WRITE_DATA_WIDTH_A-1:0] dina;
input injectsbiterra;
input injectdbiterra;
output [READ_DATA_WIDTH_A-1:0] douta; // reg?
input sbiterra; // not sure input
input dbiterra; // not sure input
  // Port B module ports
input clkb;
input rstb;
input enb; 
input regceb; 
input web;
input [ADDR_WIDTH_B-1:0] addrb;
input [WRITE_DATA_WIDTH_B-1:0] dinb;
input injectsbiterrb;
input injectdbiterrb;
output [READ_DATA_WIDTH_B-1:0] doutb; // reg?
input sbiterrb; // maybe output?
input dbiterrb; // maybe output?

wire [2:0] tmpa;
wire [2:0] tmpb;

RAMB36E1 # (
	    // weren't parameters, so guessing at default
	    .IS_CLKARDCLK_INVERTED(0), // guess
	    .IS_CLKBWRCLK_INVERTED(0), // guess
	    .IS_ENARDEN_INVERTED(0), // guess
	    .IS_ENBWREN_INVERTED(0), // guess
	    .IS_RSTRAMARSTRAM_INVERTED(0), // guess
	    .IS_RSTRAMB_INVERTED(0), // guess
	    .IS_RSTREGARSTREG_INVERTED(0), // guess
	    .IS_RSTREGB_INVERTED(0), // guess
	    .DOA_REG(0),  // guess
	    .DOB_REG(0),  // guess
	    .RAM_MODE("TDP"),
	    // meaningful values...
	    // to make Yosys happy, these need to be a standard value
	    //  like 1, 2, 4, 9, 18, 36, 72
	    //  so cannot just be PAYLOAD_WIDTH+1 (which is how used).
	    //  Ideally, would condition based on the *_DATA_WIDTH_? given.
	    //.READ_WIDTH_A (READ_DATA_WIDTH_A),
	    //.READ_WIDTH_B (READ_DATA_WIDTH_B),
	    //.WRITE_WIDTH_A (WRITE_DATA_WIDTH_A),
	    //.WRITE_WIDTH_B (WRITE_DATA_WIDTH_B)
	    //  For now, this needs to change if we move to 64b PAYLOAD.
	    //  Maybe there's a way to write a Verilog generate if?
	    .READ_WIDTH_A (36),
	    .READ_WIDTH_B (36),
	    .WRITE_WIDTH_A (36),
	    .WRITE_WIDTH_B (36)
	    )
RAMB36E1_inst0 (
		.CLKARDCLK(clka),
		.CLKBWRCLK(clkb),
		.ENARDEN(ena), 
		.ENBWREN(enb), 
		.REGCEAREGCE(regcea),
		.REGCEB(regceb),
		.RSTRAMARSTRAM (rsta),
		.RSTRAMB (rstb),
		.RSTREGARSTREG (rsta), // try using 
	        .RSTREGB(rstb), // try using
		.ADDRARDADDR (addra),
		.ADDRBWRADDR (addrb),
		.DIADI (dina[WRITE_DATA_WIDTH_A-2:0]),
		.DIBDI (dinb[WRITE_DATA_WIDTH_B-2:0]),
		.DIPADIP ({3'b000,dina[WRITE_DATA_WIDTH_A-1]}), // parity bits 
		.DIPBDIP ({3'b000,dinb[WRITE_DATA_WIDTH_B-1]}),
		.WEA ({wea,wea,wea,wea}),
		.WEBWE ({web,web,web,web,web,web,web,web}),
		.DOADO (douta[READ_DATA_WIDTH_A-2:0]),
		.DOBDO (doutb[READ_DATA_WIDTH_B-2:0]),
		.DOPADOP ({tmpa[2:0],douta[READ_DATA_WIDTH_A-1]}), // parity bits 
		.DOPBDOP ({tmpb[2:0],doutb[READ_DATA_WIDTH_B-1]})
		);

endmodule
