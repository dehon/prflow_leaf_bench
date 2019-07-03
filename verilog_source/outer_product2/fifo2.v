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

module fifo2 (
    rdata, wfull, rempty, 
    wdata, winc, wclk, wrst_n, 
    rinc, rclk, rrst_n
);
    parameter DSIZE = 32;
    parameter ASIZE = 8;
    parameter RAM_TYPE = "distributed";     // Type of RAM: string; "auto", "block", or "distributed";
    output reg [DSIZE-1:0] rdata;
    output wfull;
    output rempty;
    input [DSIZE-1:0] wdata;
    input winc, wclk, wrst_n;
    input rinc, rclk, rrst_n;
    
    wire [ASIZE-1:0] wptr, rptr;
    wire [ASIZE-1:0] waddr, raddr;
    wire aempty_n, afull_n;
    wire  [DSIZE-1:0] rdata_tmp;
    
    async_cmp #(ASIZE) async_cmp
    (
        .aempty_n(aempty_n), 
        .afull_n(afull_n),
        .wptr(wptr), 
        .rptr(rptr), 
        .wrst_n(wrst_n)
    );
    
    fifomem #(DSIZE, ASIZE, RAM_TYPE) fifomem
    (
        .rdata(rdata_tmp), 
        .wdata(wdata),
        .waddr(wptr), 
        .raddr(rptr),
        .wclken(winc), 
        .wclk(wclk)
    );
    
    rptr_empty #(ASIZE) rptr_empty
    (
        .rempty(rempty), 
        .rptr(rptr),
        .aempty_n(aempty_n), 
        .rinc(rinc),
        .rclk(rclk), 
        .rrst_n(rrst_n)
    );
    
    wptr_full #(ASIZE) wptr_full
    (
        .wfull(wfull), 
        .wptr(wptr),
        .afull_n(afull_n), 
        .winc(winc),
        .wclk(wclk), 
        .wrst_n(wrst_n)
    );
    
    always@(posedge rclk)
        if(!rrst_n) rdata <= 0;
        else        rdata <= rdata_tmp;

endmodule