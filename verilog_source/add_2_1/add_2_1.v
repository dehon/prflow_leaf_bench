// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.2
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="add_2_1,hls_ip_2018_2,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xczu9eg-ffvb1156-2-i,HLS_INPUT_CLOCK=5.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=1.016000,HLS_SYN_LAT=0,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=2,HLS_SYN_LUT=79,HLS_VERSION=2018_2}" *)

module add_2_1 (
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

parameter    ap_ST_fsm_state1 = 1'd1;

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
reg Output_1_V_V_ap_vld;

(* fsm_encoding = "none" *) reg   [0:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg    Input_1_V_V_blk_n;
reg    Input_2_V_V_blk_n;
reg    Output_1_V_V_blk_n;
reg    ap_block_state1;
reg    ap_sig_ioackin_Output_1_V_V_ap_ack;
reg    ap_reg_ioackin_Output_1_V_V_ap_ack;
reg   [0:0] ap_NS_fsm;
reg    ap_condition_65;
reg    ap_condition_42;

// power-on initialization
initial begin
#0 ap_CS_fsm = 1'd1;
#0 ap_reg_ioackin_Output_1_V_V_ap_ack = 1'b0;
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_reg_ioackin_Output_1_V_V_ap_ack <= 1'b0;
    end else begin
        if ((1'b1 == ap_CS_fsm_state1)) begin
            if ((1'b1 == ap_condition_42)) begin
                ap_reg_ioackin_Output_1_V_V_ap_ack <= 1'b0;
            end else if ((1'b1 == ap_condition_65)) begin
                ap_reg_ioackin_Output_1_V_V_ap_ack <= 1'b1;
            end
        end
    end
end

always @ (*) begin
    if ((~((ap_start == 1'b0) | (ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_2_V_V_ap_vld) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state1))) begin
        Input_1_V_V_ap_ack = 1'b1;
    end else begin
        Input_1_V_V_ap_ack = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state1)) begin
        Input_1_V_V_blk_n = Input_1_V_V_ap_vld;
    end else begin
        Input_1_V_V_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((ap_start == 1'b0) | (ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_2_V_V_ap_vld) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state1))) begin
        Input_2_V_V_ap_ack = 1'b1;
    end else begin
        Input_2_V_V_ap_ack = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state1)) begin
        Input_2_V_V_blk_n = Input_2_V_V_ap_vld;
    end else begin
        Input_2_V_V_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((ap_start == 1'b0) | (1'b0 == Input_2_V_V_ap_vld) | (1'b0 == Input_1_V_V_ap_vld)) & (ap_reg_ioackin_Output_1_V_V_ap_ack == 1'b0) & (1'b1 == ap_CS_fsm_state1))) begin
        Output_1_V_V_ap_vld = 1'b1;
    end else begin
        Output_1_V_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state1)) begin
        Output_1_V_V_blk_n = Output_1_V_V_ap_ack;
    end else begin
        Output_1_V_V_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((ap_start == 1'b0) | (ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_2_V_V_ap_vld) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state1))) begin
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
    if ((~((ap_start == 1'b0) | (ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_2_V_V_ap_vld) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state1))) begin
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
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_state1;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign Output_1_V_V = (Input_2_V_V + Input_1_V_V);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

always @ (*) begin
    ap_block_state1 = ((ap_start == 1'b0) | (1'b0 == Input_2_V_V_ap_vld) | (1'b0 == Input_1_V_V_ap_vld));
end

always @ (*) begin
    ap_condition_42 = ~((ap_start == 1'b0) | (ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_2_V_V_ap_vld) | (1'b0 == Input_1_V_V_ap_vld));
end

always @ (*) begin
    ap_condition_65 = (~((ap_start == 1'b0) | (1'b0 == Input_2_V_V_ap_vld) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == Output_1_V_V_ap_ack));
end

endmodule //add_2_1