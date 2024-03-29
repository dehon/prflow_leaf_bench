// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.2
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="data_2_1,hls_ip_2018_2,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xczu9eg-ffvb1156-2-i,HLS_INPUT_CLOCK=5.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=1.588000,HLS_SYN_LAT=2054,HLS_SYN_TPT=none,HLS_SYN_MEM=2,HLS_SYN_DSP=0,HLS_SYN_FF=42,HLS_SYN_LUT=284,HLS_VERSION=2018_2}" *)

module data_2_1 (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        Input_1_V_V,
        Input_1_V_V_ap_vld,
        Input_1_V_V_ap_ack,
        Input_2_V_V,
        Input_2_V_V_ap_vld,
        Input_2_V_V_ap_ack,
        Output_1_V_V,
        Output_1_V_V_ap_vld,
        Output_1_V_V_ap_ack
);

parameter    ap_ST_fsm_state1 = 7'd1;
parameter    ap_ST_fsm_state2 = 7'd2;
parameter    ap_ST_fsm_state3 = 7'd4;
parameter    ap_ST_fsm_state4 = 7'd8;
parameter    ap_ST_fsm_state5 = 7'd16;
parameter    ap_ST_fsm_pp2_stage0 = 7'd32;
parameter    ap_ST_fsm_state8 = 7'd64;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [31:0] Input_1_V_V;
input   Input_1_V_V_ap_vld;
output   Input_1_V_V_ap_ack;
input  [31:0] Input_2_V_V;
input   Input_2_V_V_ap_vld;
output   Input_2_V_V_ap_ack;
output  [31:0] Output_1_V_V;
output   Output_1_V_V_ap_vld;
input   Output_1_V_V_ap_ack;

reg ap_done;
reg ap_idle;
reg ap_ready;
reg Input_1_V_V_ap_ack;
reg Input_2_V_V_ap_ack;
reg[31:0] Output_1_V_V;
reg Output_1_V_V_ap_vld;

(* fsm_encoding = "none" *) reg   [6:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg   [9:0] theta_address0;
reg    theta_ce0;
reg    theta_we0;
reg   [31:0] theta_d0;
wire   [31:0] theta_q0;
reg    Input_1_V_V_blk_n;
wire    ap_CS_fsm_state2;
wire   [0:0] tmp_fu_149_p2;
reg    Input_2_V_V_blk_n;
wire    ap_CS_fsm_state4;
wire   [0:0] tmp_4_fu_166_p2;
reg    Output_1_V_V_blk_n;
wire    ap_CS_fsm_state5;
wire    ap_CS_fsm_pp2_stage0;
reg    ap_enable_reg_pp2_iter1;
wire    ap_block_pp2_stage0;
reg   [0:0] tmp_s_reg_222;
reg   [10:0] i2_reg_138;
wire   [9:0] i_1_fu_155_p2;
reg    ap_block_state2;
wire   [9:0] i_2_fu_172_p2;
reg    ap_block_state4;
wire   [0:0] tmp_s_fu_189_p2;
wire    ap_block_state6_pp2_stage0_iter0;
wire    ap_block_state7_pp2_stage0_iter1;
reg    ap_sig_ioackin_Output_1_V_V_ap_ack;
reg    ap_block_state7_io;
reg    ap_block_pp2_stage0_11001;
wire   [10:0] i_3_fu_195_p2;
reg    ap_enable_reg_pp2_iter0;
reg    ap_block_pp2_stage0_subdone;
reg    ap_condition_pp2_exit_iter0_state6;
reg   [9:0] i_reg_116;
reg   [9:0] i1_reg_127;
wire    ap_CS_fsm_state3;
wire   [63:0] tmp_2_fu_161_p1;
wire   [63:0] tmp_8_cast_fu_184_p1;
wire   [63:0] tmp_1_fu_201_p1;
wire    ap_block_pp2_stage0_01001;
reg    ap_reg_ioackin_Output_1_V_V_ap_ack;
wire   [9:0] tmp_8_fu_178_p2;
wire    ap_CS_fsm_state8;
reg   [6:0] ap_NS_fsm;
reg    ap_idle_pp2;
wire    ap_enable_pp2;

// power-on initialization
initial begin
#0 ap_CS_fsm = 7'd1;
#0 ap_enable_reg_pp2_iter1 = 1'b0;
#0 ap_enable_reg_pp2_iter0 = 1'b0;
#0 ap_reg_ioackin_Output_1_V_V_ap_ack = 1'b0;
end

data_2_1_theta #(
    .DataWidth( 32 ),
    .AddressRange( 1024 ),
    .AddressWidth( 10 ))
theta_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .address0(theta_address0),
    .ce0(theta_ce0),
    .we0(theta_we0),
    .d0(theta_d0),
    .q0(theta_q0)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp2_iter0 <= 1'b0;
    end else begin
        if (((1'b1 == ap_CS_fsm_pp2_stage0) & (1'b1 == ap_condition_pp2_exit_iter0_state6) & (1'b0 == ap_block_pp2_stage0_subdone))) begin
            ap_enable_reg_pp2_iter0 <= 1'b0;
        end else if (((1'b1 == ap_CS_fsm_state5) & (ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1))) begin
            ap_enable_reg_pp2_iter0 <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp2_iter1 <= 1'b0;
    end else begin
        if (((1'b1 == ap_condition_pp2_exit_iter0_state6) & (1'b0 == ap_block_pp2_stage0_subdone))) begin
            ap_enable_reg_pp2_iter1 <= (1'b1 ^ ap_condition_pp2_exit_iter0_state6);
        end else if ((1'b0 == ap_block_pp2_stage0_subdone)) begin
            ap_enable_reg_pp2_iter1 <= ap_enable_reg_pp2_iter0;
        end else if (((1'b1 == ap_CS_fsm_state5) & (ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1))) begin
            ap_enable_reg_pp2_iter1 <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_reg_ioackin_Output_1_V_V_ap_ack <= 1'b0;
    end else begin
        if ((((tmp_s_reg_222 == 1'd0) & (ap_enable_reg_pp2_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp2_stage0) & (1'b0 == ap_block_pp2_stage0_11001)) | ((1'b1 == ap_CS_fsm_state5) & (ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1)))) begin
            ap_reg_ioackin_Output_1_V_V_ap_ack <= 1'b0;
        end else if ((((tmp_s_reg_222 == 1'd0) & (ap_enable_reg_pp2_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp2_stage0) & (1'b1 == Output_1_V_V_ap_ack) & (1'b0 == ap_block_pp2_stage0_01001)) | ((1'b1 == ap_CS_fsm_state5) & (1'b1 == Output_1_V_V_ap_ack)))) begin
            ap_reg_ioackin_Output_1_V_V_ap_ack <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        i1_reg_127 <= 10'd0;
    end else if ((~((tmp_4_fu_166_p2 == 1'd0) & (1'b0 == Input_2_V_V_ap_vld)) & (tmp_4_fu_166_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        i1_reg_127 <= i_2_fu_172_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((tmp_s_fu_189_p2 == 1'd0) & (1'b1 == ap_CS_fsm_pp2_stage0) & (ap_enable_reg_pp2_iter0 == 1'b1) & (1'b0 == ap_block_pp2_stage0_11001))) begin
        i2_reg_138 <= i_3_fu_195_p2;
    end else if (((1'b1 == ap_CS_fsm_state5) & (ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1))) begin
        i2_reg_138 <= 11'd0;
    end
end

always @ (posedge ap_clk) begin
    if ((~((tmp_fu_149_p2 == 1'd0) & (1'b0 == Input_1_V_V_ap_vld)) & (tmp_fu_149_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        i_reg_116 <= i_1_fu_155_p2;
    end else if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1))) begin
        i_reg_116 <= 10'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_pp2_stage0) & (1'b0 == ap_block_pp2_stage0_11001))) begin
        tmp_s_reg_222 <= tmp_s_fu_189_p2;
    end
end

always @ (*) begin
    if ((~((tmp_fu_149_p2 == 1'd0) & (1'b0 == Input_1_V_V_ap_vld)) & (tmp_fu_149_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        Input_1_V_V_ap_ack = 1'b1;
    end else begin
        Input_1_V_V_ap_ack = 1'b0;
    end
end

always @ (*) begin
    if (((tmp_fu_149_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        Input_1_V_V_blk_n = Input_1_V_V_ap_vld;
    end else begin
        Input_1_V_V_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((tmp_4_fu_166_p2 == 1'd0) & (1'b0 == Input_2_V_V_ap_vld)) & (tmp_4_fu_166_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        Input_2_V_V_ap_ack = 1'b1;
    end else begin
        Input_2_V_V_ap_ack = 1'b0;
    end
end

always @ (*) begin
    if (((tmp_4_fu_166_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        Input_2_V_V_blk_n = Input_2_V_V_ap_vld;
    end else begin
        Input_2_V_V_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((tmp_s_reg_222 == 1'd0) & (ap_enable_reg_pp2_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp2_stage0) & (1'b0 == ap_block_pp2_stage0_01001))) begin
        Output_1_V_V = theta_q0;
    end else if ((1'b1 == ap_CS_fsm_state5)) begin
        Output_1_V_V = 32'd1025;
    end else begin
        Output_1_V_V = 'bx;
    end
end

always @ (*) begin
    if ((((tmp_s_reg_222 == 1'd0) & (ap_reg_ioackin_Output_1_V_V_ap_ack == 1'b0) & (ap_enable_reg_pp2_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp2_stage0) & (1'b0 == ap_block_pp2_stage0_01001)) | ((ap_reg_ioackin_Output_1_V_V_ap_ack == 1'b0) & (1'b1 == ap_CS_fsm_state5)))) begin
        Output_1_V_V_ap_vld = 1'b1;
    end else begin
        Output_1_V_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state5) | ((1'b0 == ap_block_pp2_stage0) & (tmp_s_reg_222 == 1'd0) & (ap_enable_reg_pp2_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp2_stage0)))) begin
        Output_1_V_V_blk_n = Output_1_V_V_ap_ack;
    end else begin
        Output_1_V_V_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((tmp_s_fu_189_p2 == 1'd1)) begin
        ap_condition_pp2_exit_iter0_state6 = 1'b1;
    end else begin
        ap_condition_pp2_exit_iter0_state6 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state8)) begin
        ap_done = 1'b1;
    end else begin
        ap_done = 1'b0;
    end
end

always @ (*) begin
    if (((ap_start == 1'b0) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp2_iter1 == 1'b0) & (ap_enable_reg_pp2_iter0 == 1'b0))) begin
        ap_idle_pp2 = 1'b1;
    end else begin
        ap_idle_pp2 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state8)) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if ((ap_reg_ioackin_Output_1_V_V_ap_ack == 1'b0)) begin
        ap_sig_ioackin_Output_1_V_V_ap_ack = Output_1_V_V_ap_ack;
    end else begin
        ap_sig_ioackin_Output_1_V_V_ap_ack = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp2_stage0) & (1'b1 == ap_CS_fsm_pp2_stage0) & (ap_enable_reg_pp2_iter0 == 1'b1))) begin
        theta_address0 = tmp_1_fu_201_p1;
    end else if ((1'b1 == ap_CS_fsm_state4)) begin
        theta_address0 = tmp_8_cast_fu_184_p1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        theta_address0 = tmp_2_fu_161_p1;
    end else begin
        theta_address0 = 'bx;
    end
end

always @ (*) begin
    if ((((1'b1 == ap_CS_fsm_pp2_stage0) & (ap_enable_reg_pp2_iter0 == 1'b1) & (1'b0 == ap_block_pp2_stage0_11001)) | (~((tmp_4_fu_166_p2 == 1'd0) & (1'b0 == Input_2_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state4)) | (~((tmp_fu_149_p2 == 1'd0) & (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state2)))) begin
        theta_ce0 = 1'b1;
    end else begin
        theta_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        theta_d0 = Input_2_V_V;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        theta_d0 = Input_1_V_V;
    end else begin
        theta_d0 = 'bx;
    end
end

always @ (*) begin
    if (((~((tmp_4_fu_166_p2 == 1'd0) & (1'b0 == Input_2_V_V_ap_vld)) & (tmp_4_fu_166_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4)) | (~((tmp_fu_149_p2 == 1'd0) & (1'b0 == Input_1_V_V_ap_vld)) & (tmp_fu_149_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2)))) begin
        theta_we0 = 1'b1;
    end else begin
        theta_we0 = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            if ((~((tmp_fu_149_p2 == 1'd0) & (1'b0 == Input_1_V_V_ap_vld)) & (tmp_fu_149_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else if ((~((tmp_fu_149_p2 == 1'd0) & (1'b0 == Input_1_V_V_ap_vld)) & (tmp_fu_149_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_state4;
        end
        ap_ST_fsm_state4 : begin
            if ((~((tmp_4_fu_166_p2 == 1'd0) & (1'b0 == Input_2_V_V_ap_vld)) & (tmp_4_fu_166_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end else if ((~((tmp_4_fu_166_p2 == 1'd0) & (1'b0 == Input_2_V_V_ap_vld)) & (tmp_4_fu_166_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state4))) begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end
        end
        ap_ST_fsm_state5 : begin
            if (((1'b1 == ap_CS_fsm_state5) & (ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_pp2_stage0;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end
        end
        ap_ST_fsm_pp2_stage0 : begin
            if (~((ap_enable_reg_pp2_iter0 == 1'b1) & (1'b0 == ap_block_pp2_stage0_subdone) & (tmp_s_fu_189_p2 == 1'd1))) begin
                ap_NS_fsm = ap_ST_fsm_pp2_stage0;
            end else if (((ap_enable_reg_pp2_iter0 == 1'b1) & (1'b0 == ap_block_pp2_stage0_subdone) & (tmp_s_fu_189_p2 == 1'd1))) begin
                ap_NS_fsm = ap_ST_fsm_state8;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp2_stage0;
            end
        end
        ap_ST_fsm_state8 : begin
            ap_NS_fsm = ap_ST_fsm_state1;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_pp2_stage0 = ap_CS_fsm[32'd5];

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

assign ap_CS_fsm_state8 = ap_CS_fsm[32'd6];

assign ap_block_pp2_stage0 = ~(1'b1 == 1'b1);

assign ap_block_pp2_stage0_01001 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp2_stage0_11001 = ((1'b1 == ap_block_state7_io) & (ap_enable_reg_pp2_iter1 == 1'b1));
end

always @ (*) begin
    ap_block_pp2_stage0_subdone = ((1'b1 == ap_block_state7_io) & (ap_enable_reg_pp2_iter1 == 1'b1));
end

always @ (*) begin
    ap_block_state2 = ((tmp_fu_149_p2 == 1'd0) & (1'b0 == Input_1_V_V_ap_vld));
end

always @ (*) begin
    ap_block_state4 = ((tmp_4_fu_166_p2 == 1'd0) & (1'b0 == Input_2_V_V_ap_vld));
end

assign ap_block_state6_pp2_stage0_iter0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_state7_io = ((tmp_s_reg_222 == 1'd0) & (ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0));
end

assign ap_block_state7_pp2_stage0_iter1 = ~(1'b1 == 1'b1);

assign ap_enable_pp2 = (ap_idle_pp2 ^ 1'b1);

assign i_1_fu_155_p2 = (i_reg_116 + 10'd1);

assign i_2_fu_172_p2 = (i1_reg_127 + 10'd1);

assign i_3_fu_195_p2 = (i2_reg_138 + 11'd1);

assign tmp_1_fu_201_p1 = i2_reg_138;

assign tmp_2_fu_161_p1 = i_reg_116;

assign tmp_4_fu_166_p2 = ((i1_reg_127 == 10'd512) ? 1'b1 : 1'b0);

assign tmp_8_cast_fu_184_p1 = tmp_8_fu_178_p2;

assign tmp_8_fu_178_p2 = (i1_reg_127 ^ 10'd512);

assign tmp_fu_149_p2 = ((i_reg_116 == 10'd512) ? 1'b1 : 1'b0);

assign tmp_s_fu_189_p2 = ((i2_reg_138 == 11'd1024) ? 1'b1 : 1'b0);

endmodule //data_2_1
