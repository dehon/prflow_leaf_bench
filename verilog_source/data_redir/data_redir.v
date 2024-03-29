// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.2
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="data_redir,hls_ip_2018_2,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xczu9eg-ffvb1156-2-i,HLS_INPUT_CLOCK=5.000000,HLS_INPUT_ARCH=dataflow,HLS_SYN_CLOCK=0.000000,HLS_SYN_LAT=5,HLS_SYN_TPT=6,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=9,HLS_SYN_LUT=94,HLS_VERSION=2018_2}" *)

module data_redir (
        Input_1_V_V,
        Output_1_V_V,
        Output_2_V_V,
        ap_clk,
        ap_rst,
        Input_1_V_V_ap_vld,
        Input_1_V_V_ap_ack,
        Output_1_V_V_ap_vld,
        Output_1_V_V_ap_ack,
        Output_2_V_V_ap_vld,
        Output_2_V_V_ap_ack,
        ap_done,
        ap_start,
        ap_ready,
        ap_idle
);


input  [31:0] Input_1_V_V;
output  [31:0] Output_1_V_V;
output  [31:0] Output_2_V_V;
input   ap_clk;
input   ap_rst;
input   Input_1_V_V_ap_vld;
output   Input_1_V_V_ap_ack;
output   Output_1_V_V_ap_vld;
input   Output_1_V_V_ap_ack;
output   Output_2_V_V_ap_vld;
input   Output_2_V_V_ap_ack;
output   ap_done;
input   ap_start;
output   ap_ready;
output   ap_idle;

wire    Block_proc13_U0_ap_start;
wire    Block_proc13_U0_ap_done;
wire    Block_proc13_U0_ap_continue;
wire    Block_proc13_U0_ap_idle;
wire    Block_proc13_U0_ap_ready;
wire    Block_proc13_U0_Input_1_V_V_ap_ack;
wire   [31:0] Block_proc13_U0_Output_1_V_V;
wire    Block_proc13_U0_Output_1_V_V_ap_vld;
wire   [31:0] Block_proc13_U0_Output_2_V_V;
wire    Block_proc13_U0_Output_2_V_V_ap_vld;
wire    ap_sync_continue;
wire    ap_sync_done;
wire    ap_sync_ready;
wire    Block_proc13_U0_start_full_n;
wire    Block_proc13_U0_start_write;

Block_proc13 Block_proc13_U0(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(Block_proc13_U0_ap_start),
    .ap_done(Block_proc13_U0_ap_done),
    .ap_continue(Block_proc13_U0_ap_continue),
    .ap_idle(Block_proc13_U0_ap_idle),
    .ap_ready(Block_proc13_U0_ap_ready),
    .Input_1_V_V(Input_1_V_V),
    .Input_1_V_V_ap_vld(Input_1_V_V_ap_vld),
    .Input_1_V_V_ap_ack(Block_proc13_U0_Input_1_V_V_ap_ack),
    .Output_1_V_V(Block_proc13_U0_Output_1_V_V),
    .Output_1_V_V_ap_vld(Block_proc13_U0_Output_1_V_V_ap_vld),
    .Output_1_V_V_ap_ack(Output_1_V_V_ap_ack),
    .Output_2_V_V(Block_proc13_U0_Output_2_V_V),
    .Output_2_V_V_ap_vld(Block_proc13_U0_Output_2_V_V_ap_vld),
    .Output_2_V_V_ap_ack(Output_2_V_V_ap_ack)
);

assign Block_proc13_U0_ap_continue = 1'b1;

assign Block_proc13_U0_ap_start = ap_start;

assign Block_proc13_U0_start_full_n = 1'b1;

assign Block_proc13_U0_start_write = 1'b0;

assign Input_1_V_V_ap_ack = Block_proc13_U0_Input_1_V_V_ap_ack;

assign Output_1_V_V = Block_proc13_U0_Output_1_V_V;

assign Output_1_V_V_ap_vld = Block_proc13_U0_Output_1_V_V_ap_vld;

assign Output_2_V_V = Block_proc13_U0_Output_2_V_V;

assign Output_2_V_V_ap_vld = Block_proc13_U0_Output_2_V_V_ap_vld;

assign ap_done = Block_proc13_U0_ap_done;

assign ap_idle = Block_proc13_U0_ap_idle;

assign ap_ready = Block_proc13_U0_ap_ready;

assign ap_sync_continue = 1'b1;

assign ap_sync_done = Block_proc13_U0_ap_done;

assign ap_sync_ready = Block_proc13_U0_ap_ready;

endmodule //data_redir
