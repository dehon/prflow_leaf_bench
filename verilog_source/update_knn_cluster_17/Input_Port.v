`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2018 11:23:36 PM
// Design Name: 
// Module Name: Input_Port
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Input_Port#(
    parameter PACKET_BITS = 97,
    parameter NUM_LEAF_BITS = 6,
    parameter NUM_PORT_BITS = 4,
    parameter NUM_ADDR_BITS = 7,
    parameter PAYLOAD_BITS = 64, 
    parameter NUM_IN_PORTS = 1, 
    parameter NUM_OUT_PORTS = 1,
    parameter NUM_BRAM_ADDR_BITS = 7,
    parameter PORT_No = 2,
    parameter SYN_TYPE = "yosys",
    parameter FREESPACE_UPDATE_SIZE = 64,
    localparam BRAM_DEPTH = 2**(NUM_BRAM_ADDR_BITS-1)*(PAYLOAD_BITS+1)
    )(
    input clk_bft,
    input clk_user,
    input reset,
    
    //internal interface
    output freespace_update,
    output [PACKET_BITS-1:0] packet_from_input_port,
    input [PACKET_BITS-1:0] din_leaf_bft2interface,
    input [NUM_LEAF_BITS-1:0] src_leaf,
    input [NUM_PORT_BITS-1:0] src_port,
    
    //user interface
    output [PAYLOAD_BITS-1:0] dout2user,
    output vld2user,
    input ack_user2b_in
    
    );

    wire vldBit;
    wire [NUM_PORT_BITS-1:0] port;
    wire [NUM_ADDR_BITS-1:0] addr;
    wire [PAYLOAD_BITS-1:0] payload;
    
    wire [PACKET_BITS-1-NUM_LEAF_BITS-NUM_PORT_BITS-PAYLOAD_BITS-1:0] red_bits;
    wire [PAYLOAD_BITS-1:0] update_data;
    
    wire [NUM_ADDR_BITS-1:0] addra;
    //wire [NUM_BRAM_ADDR_BITS-1:0] addra_extend;
    wire [PAYLOAD_BITS:0] dina;
    wire wea;
    wire wea_0;
    wire wea_1;
    
    
    wire [NUM_ADDR_BITS-2:0] addrb_0;
    //wire [NUM_BRAM_ADDR_BITS-1:0] addrb_extend_0;
    wire [PAYLOAD_BITS:0] doutb_0;
    wire web_0;
    
        
    wire [NUM_ADDR_BITS-2:0] addrb_1;
    //wire [NUM_BRAM_ADDR_BITS-1:0] addrb_extend_1;
    wire [PAYLOAD_BITS:0] doutb_1;
    wire web_1;
    
    
    assign wea_0 = addra[0] ? 0 : wea;
    assign wea_1 = addra[0] ? wea : 0;
    
    
/*    generate
        if(NUM_BRAM_ADDR_BITS>NUM_ADDR_BITS) begin
            wire [NUM_BRAM_ADDR_BITS-NUM_ADDR_BITS-1:0] redundent_bits;
            assign redundent_bits = 0;
            assign addra_extend = {redundent_bits, addra};
            assign addrb_extend_0 = {redundent_bits, addrb_0};
            assign addrb_extend_1 = {redundent_bits, addrb_1};
        end else begin
            assign addra_extend = addra;
            assign addrb_extend_0 = addrb_0;
            assign addrb_extend_1 = addrb_1;
        end
    endgenerate
    */
    
    assign red_bits = 0;
    assign update_data = 1;
    assign packet_from_input_port = {1'b1, src_leaf, src_port, red_bits, update_data};
    
    
    assign vldBit = din_leaf_bft2interface[PACKET_BITS-1]; // 1 bit
    assign port = din_leaf_bft2interface[PACKET_BITS-2-NUM_LEAF_BITS:PACKET_BITS-2-NUM_LEAF_BITS-NUM_PORT_BITS+1];
    assign addr = din_leaf_bft2interface[PAYLOAD_BITS+NUM_ADDR_BITS-1:PAYLOAD_BITS];
    assign payload = din_leaf_bft2interface[PAYLOAD_BITS-1:0];


    // write bram_in, it manipulates write port of b_in
    
    

    write_b_in #(
        .NUM_PORT_BITS(NUM_PORT_BITS),
        .PAYLOAD_BITS(PAYLOAD_BITS),
        .NUM_ADDR_BITS(NUM_ADDR_BITS),
        .PORT_No(PORT_No)
        )wbi(
        .clk(clk_bft), 
        .reset(reset), 
        .port(port), 
        .addr(addr), 
        .vldBit(vldBit), 
        .payload(payload), 
        .wea(wea), 
        .addra(addra), 
        .dina(dina)
        );



    // bram_in
   
    
    /*
    bram_in b_in(
        .clka(clk_bft), 
        .wea(b_in_wea), 
        .addra(b_in_addra), 
        .dina(b_in_dina), 
        .douta(),
        .clkb(clk_user), 
        .web(b_in_web), 
        .addrb(b_in_addrb), 
        .dinb(65'd0), 
        .doutb(b_in_doutb)
        );

       */ 
wire [PAYLOAD_BITS:0] b_in_dinb;
assign b_in_dinb = 0;

generate
    if(SYN_TYPE == "yosys")
    begin      
        xpm_memory_tdpram_yosys # (
          // Common module parameters
          .MEMORY_SIZE        (BRAM_DEPTH),            //positive integer
          .MEMORY_PRIMITIVE   ("block"),          //string; "auto", "distributed", "block" or "ultra";
          .CLOCKING_MODE      ("independent_clock"),  //string; "common_clock", "independent_clock" 
          .MEMORY_INIT_FILE   ("none"),          //string; "none" or "<filename>.mem" 
          .MEMORY_INIT_PARAM  (""    ),          //string;
          .USE_MEM_INIT       (1),               //integer; 0,1
          .WAKEUP_TIME        ("disable_sleep"), //string; "disable_sleep" or "use_sleep_pin" 
          .MESSAGE_CONTROL    (0),               //integer; 0,1
          .ECC_MODE           ("no_ecc"),        //string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
          .AUTO_SLEEP_TIME    (0),               //Do not Change
        
          // Port A module parameters
          .WRITE_DATA_WIDTH_A (PAYLOAD_BITS+1),              //positive integer
          .READ_DATA_WIDTH_A  (PAYLOAD_BITS+1),              //positive integer
          .BYTE_WRITE_WIDTH_A (PAYLOAD_BITS+1),              //integer; 8, 9, or WRITE_DATA_WIDTH_A value
          .ADDR_WIDTH_A       (NUM_BRAM_ADDR_BITS-1),               //positive integer
          .READ_RESET_VALUE_A ("0"),             //string
          .READ_LATENCY_A     (1),               //non-negative integer
          .WRITE_MODE_A       ("write_first"),     //string; "write_first", "read_first", "no_change" 
        
          // Port B module parameters
          .WRITE_DATA_WIDTH_B (PAYLOAD_BITS+1),              //positive integer
          .READ_DATA_WIDTH_B  (PAYLOAD_BITS+1),              //positive integer
          .BYTE_WRITE_WIDTH_B (PAYLOAD_BITS+1),              //integer; 8, 9, or WRITE_DATA_WIDTH_B value
          .ADDR_WIDTH_B       (NUM_BRAM_ADDR_BITS-1),               //positive integer
          .READ_RESET_VALUE_B ("0"),             //vector of READ_DATA_WIDTH_B bits
          .READ_LATENCY_B     (1),               //non-negative integer
          .WRITE_MODE_B       ("write_first")      //string; "write_first", "read_first", "no_change" 
        
        ) xpm_memory_tdpram_inst_0 (
          // Common module ports
          .sleep          (1'b0),
          // Port A module ports
          .clka           (clk_bft),
          .rsta           (reset),
          .ena            (1'b1),
          .regcea         (1'b1),
          .wea            (wea_0),
          .addra          (addra[NUM_ADDR_BITS-1:1]),
          .dina           (dina),
          .injectsbiterra (1'b0),
          .injectdbiterra (1'b0),
          .douta          (),
          .sbiterra       (),
          .dbiterra       (),
          // Port B module ports
          .clkb           (clk_user),
          .rstb           (reset),
          .enb            (1'b1),
          .regceb         (1'b1),
          .web            (web_0),
          .addrb          (addrb_0),
          .dinb           (0),
          .injectsbiterrb (1'b0),
          .injectdbiterrb (1'b0),
          .doutb          (doutb_0),
          .sbiterrb       (),
          .dbiterrb       ()
        );
        
        
        
        xpm_memory_tdpram_yosys # (
          // Common module parameters
          .MEMORY_SIZE        (BRAM_DEPTH),            //positive integer
          .MEMORY_PRIMITIVE   ("block"),          //string; "auto", "distributed", "block" or "ultra";
          .CLOCKING_MODE      ("independent_clock"),  //string; "common_clock", "independent_clock" 
          .MEMORY_INIT_FILE   ("none"),          //string; "none" or "<filename>.mem" 
          .MEMORY_INIT_PARAM  (""    ),          //string;
          .USE_MEM_INIT       (1),               //integer; 0,1
          .WAKEUP_TIME        ("disable_sleep"), //string; "disable_sleep" or "use_sleep_pin" 
          .MESSAGE_CONTROL    (0),               //integer; 0,1
          .ECC_MODE           ("no_ecc"),        //string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
          .AUTO_SLEEP_TIME    (0),               //Do not Change
        
          // Port A module parameters
          .WRITE_DATA_WIDTH_A (PAYLOAD_BITS+1),              //positive integer
          .READ_DATA_WIDTH_A  (PAYLOAD_BITS+1),              //positive integer
          .BYTE_WRITE_WIDTH_A (PAYLOAD_BITS+1),              //integer; 8, 9, or WRITE_DATA_WIDTH_A value
          .ADDR_WIDTH_A       (NUM_BRAM_ADDR_BITS-1),               //positive integer
          .READ_RESET_VALUE_A ("0"),             //string
          .READ_LATENCY_A     (1),               //non-negative integer
          .WRITE_MODE_A       ("write_first"),     //string; "write_first", "read_first", "no_change" 
        
          // Port B module parameters
          .WRITE_DATA_WIDTH_B (PAYLOAD_BITS+1),              //positive integer
          .READ_DATA_WIDTH_B  (PAYLOAD_BITS+1),              //positive integer
          .BYTE_WRITE_WIDTH_B (PAYLOAD_BITS+1),              //integer; 8, 9, or WRITE_DATA_WIDTH_B value
          .ADDR_WIDTH_B       (NUM_BRAM_ADDR_BITS-1),               //positive integer
          .READ_RESET_VALUE_B ("0"),             //vector of READ_DATA_WIDTH_B bits
          .READ_LATENCY_B     (1),               //non-negative integer
          .WRITE_MODE_B       ("write_first")      //string; "write_first", "read_first", "no_change" 
        
        ) xpm_memory_tdpram_inst_1 (
          // Common module ports
          .sleep          (1'b0),
          // Port A module ports
          .clka           (clk_bft),
          .rsta           (reset),
          .ena            (1'b1),
          .regcea         (1'b1),
          .wea            (wea_1),
          .addra          (addra[NUM_ADDR_BITS-1:1]),
          .dina           (dina),
          .injectsbiterra (1'b0),
          .injectdbiterra (1'b0),
          .douta          (),
          .sbiterra       (),
          .dbiterra       (),
          // Port B module ports
          .clkb           (clk_user),
          .rstb           (reset),
          .enb            (1'b1),
          .regceb         (1'b1),
          .web            (web_1),
          .addrb          (addrb_1),
          .dinb           (0),
          .injectsbiterrb (1'b0),
          .injectdbiterrb (1'b0),
          .doutb          (doutb_1),
          .sbiterrb       (),
          .dbiterrb       ()
        );

    end else begin

        
              
        xpm_memory_tdpram # (
          // Common module parameters
          .MEMORY_SIZE        (BRAM_DEPTH),            //positive integer
          .MEMORY_PRIMITIVE   ("block"),          //string; "auto", "distributed", "block" or "ultra";
          .CLOCKING_MODE      ("independent_clock"),  //string; "common_clock", "independent_clock" 
          .MEMORY_INIT_FILE   ("none"),          //string; "none" or "<filename>.mem" 
          .MEMORY_INIT_PARAM  (""    ),          //string;
          .USE_MEM_INIT       (1),               //integer; 0,1
          .WAKEUP_TIME        ("disable_sleep"), //string; "disable_sleep" or "use_sleep_pin" 
          .MESSAGE_CONTROL    (0),               //integer; 0,1
          .ECC_MODE           ("no_ecc"),        //string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
          .AUTO_SLEEP_TIME    (0),               //Do not Change
        
          // Port A module parameters
          .WRITE_DATA_WIDTH_A (PAYLOAD_BITS+1),              //positive integer
          .READ_DATA_WIDTH_A  (PAYLOAD_BITS+1),              //positive integer
          .BYTE_WRITE_WIDTH_A (PAYLOAD_BITS+1),              //integer; 8, 9, or WRITE_DATA_WIDTH_A value
          .ADDR_WIDTH_A       (NUM_BRAM_ADDR_BITS-1),               //positive integer
          .READ_RESET_VALUE_A ("0"),             //string
          .READ_LATENCY_A     (1),               //non-negative integer
          .WRITE_MODE_A       ("write_first"),     //string; "write_first", "read_first", "no_change" 
        
          // Port B module parameters
          .WRITE_DATA_WIDTH_B (PAYLOAD_BITS+1),              //positive integer
          .READ_DATA_WIDTH_B  (PAYLOAD_BITS+1),              //positive integer
          .BYTE_WRITE_WIDTH_B (PAYLOAD_BITS+1),              //integer; 8, 9, or WRITE_DATA_WIDTH_B value
          .ADDR_WIDTH_B       (NUM_BRAM_ADDR_BITS-1),               //positive integer
          .READ_RESET_VALUE_B ("0"),             //vector of READ_DATA_WIDTH_B bits
          .READ_LATENCY_B     (1),               //non-negative integer
          .WRITE_MODE_B       ("write_first")      //string; "write_first", "read_first", "no_change" 
        
        ) xpm_memory_tdpram_inst_0 (
          // Common module ports
          .sleep          (1'b0),
          // Port A module ports
          .clka           (clk_bft),
          .rsta           (reset),
          .ena            (1'b1),
          .regcea         (1'b1),
          .wea            (wea_0),
          .addra          (addra[NUM_ADDR_BITS-1:1]),
          .dina           (dina),
          .injectsbiterra (1'b0),
          .injectdbiterra (1'b0),
          .douta          (),
          .sbiterra       (),
          .dbiterra       (),
          // Port B module ports
          .clkb           (clk_user),
          .rstb           (reset),
          .enb            (1'b1),
          .regceb         (1'b1),
          .web            (web_0),
          .addrb          (addrb_0),
          .dinb           (0),
          .injectsbiterrb (1'b0),
          .injectdbiterrb (1'b0),
          .doutb          (doutb_0),
          .sbiterrb       (),
          .dbiterrb       ()
        );
        
        
        
        xpm_memory_tdpram # (
          // Common module parameters
          .MEMORY_SIZE        (BRAM_DEPTH),            //positive integer
          .MEMORY_PRIMITIVE   ("block"),          //string; "auto", "distributed", "block" or "ultra";
          .CLOCKING_MODE      ("independent_clock"),  //string; "common_clock", "independent_clock" 
          .MEMORY_INIT_FILE   ("none"),          //string; "none" or "<filename>.mem" 
          .MEMORY_INIT_PARAM  (""    ),          //string;
          .USE_MEM_INIT       (1),               //integer; 0,1
          .WAKEUP_TIME        ("disable_sleep"), //string; "disable_sleep" or "use_sleep_pin" 
          .MESSAGE_CONTROL    (0),               //integer; 0,1
          .ECC_MODE           ("no_ecc"),        //string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
          .AUTO_SLEEP_TIME    (0),               //Do not Change
        
          // Port A module parameters
          .WRITE_DATA_WIDTH_A (PAYLOAD_BITS+1),              //positive integer
          .READ_DATA_WIDTH_A  (PAYLOAD_BITS+1),              //positive integer
          .BYTE_WRITE_WIDTH_A (PAYLOAD_BITS+1),              //integer; 8, 9, or WRITE_DATA_WIDTH_A value
          .ADDR_WIDTH_A       (NUM_BRAM_ADDR_BITS-1),               //positive integer
          .READ_RESET_VALUE_A ("0"),             //string
          .READ_LATENCY_A     (1),               //non-negative integer
          .WRITE_MODE_A       ("write_first"),     //string; "write_first", "read_first", "no_change" 
        
          // Port B module parameters
          .WRITE_DATA_WIDTH_B (PAYLOAD_BITS+1),              //positive integer
          .READ_DATA_WIDTH_B  (PAYLOAD_BITS+1),              //positive integer
          .BYTE_WRITE_WIDTH_B (PAYLOAD_BITS+1),              //integer; 8, 9, or WRITE_DATA_WIDTH_B value
          .ADDR_WIDTH_B       (NUM_BRAM_ADDR_BITS-1),               //positive integer
          .READ_RESET_VALUE_B ("0"),             //vector of READ_DATA_WIDTH_B bits
          .READ_LATENCY_B     (1),               //non-negative integer
          .WRITE_MODE_B       ("write_first")      //string; "write_first", "read_first", "no_change" 
        
        ) xpm_memory_tdpram_inst_1 (
          // Common module ports
          .sleep          (1'b0),
          // Port A module ports
          .clka           (clk_bft),
          .rsta           (reset),
          .ena            (1'b1),
          .regcea         (1'b1),
          .wea            (wea_1),
          .addra          (addra[NUM_ADDR_BITS-1:1]),
          .dina           (dina),
          .injectsbiterra (1'b0),
          .injectdbiterra (1'b0),
          .douta          (),
          .sbiterra       (),
          .dbiterra       (),
          // Port B module ports
          .clkb           (clk_user),
          .rstb           (reset),
          .enb            (1'b1),
          .regceb         (1'b1),
          .web            (web_1),
          .addrb          (addrb_1),
          .dinb           (0),
          .injectsbiterrb (1'b0),
          .injectdbiterrb (1'b0),
          .doutb          (doutb_1),
          .sbiterrb       (),
          .dbiterrb       ()
        );
        
    end
endgenerate

  

    // read bram_in,it manipulates read port
    read_b_in #(
        .FREESPACE_UPDATE_SIZE(FREESPACE_UPDATE_SIZE),
        .PAYLOAD_BITS(PAYLOAD_BITS),
        .NUM_ADDR_BITS(NUM_ADDR_BITS)        
        )rbi(
        .clk(clk_user), 
        .reset(reset), 
        .ack_user2b_in(ack_user2b_in), 
        .doutb_0(doutb_0),
        .doutb_1(doutb_1),
        .addrb_0(addrb_0), 
        .addrb_1(addrb_1), 
        .dout_leaf_interface2user(dout2user), 
        .vld_bram_in2user(vld2user), 
        .freespace_update(freespace_update), 
        .web_0(web_0),
        .web_1(web_1));

    
endmodule
