`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2019 10:19:45 AM
// Design Name: 
// Module Name: rptr_empty
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

module fifomem (rdata, wdata, waddr, raddr, wclken, wclk);
    parameter DATASIZE = 32;                // Memory data word width
    parameter ADDRSIZE = 8;                 // Number of memory address bits
    parameter RAM_TYPE = "distributed";     // Type of RAM: string; "auto", "block", or "distributed";
    parameter DEPTH = 1<<ADDRSIZE;          // DEPTH = 2**ADDRSIZE
    output [DATASIZE-1:0] rdata;
    input [DATASIZE-1:0] wdata;
    input [ADDRSIZE-1:0] waddr, raddr;
    input wclken, wclk;
    `ifdef VENDORRAM
    // instantiation of a vendor's dual-port RAM
        VENDOR_RAM MEM (
            .dout(rdata), 
            .din(wdata),
            .waddr(waddr), 
            .raddr(raddr),
            .wclken(wclken), 
            .clk(wclk)
        );
    `else
        (* ram_style = RAM_TYPE *) reg [DATASIZE-1:0] MEM[0:DEPTH-1];
        assign rdata = MEM[raddr];
        always @(posedge wclk)
            if (wclken) MEM[waddr] <= wdata;
    `endif
endmodule