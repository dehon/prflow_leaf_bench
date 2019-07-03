// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.2
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="projection_even,hls_ip_2018_2,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xczu9eg-ffvb1156-2-i,HLS_INPUT_CLOCK=5.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=3.161000,HLS_SYN_LAT=6,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=48,HLS_SYN_LUT=299,HLS_VERSION=2018_2}" *)

module projection_even (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        Input_1_V_V,
        Input_1_V_V_ap_vld,
        Input_1_V_V_ap_ack,
        Output_1_V_V,
        Output_1_V_V_ap_vld,
        Output_1_V_V_ap_ack
);

parameter    ap_ST_fsm_state1 = 7'd1;
parameter    ap_ST_fsm_state2 = 7'd2;
parameter    ap_ST_fsm_state3 = 7'd4;
parameter    ap_ST_fsm_state4 = 7'd8;
parameter    ap_ST_fsm_state5 = 7'd16;
parameter    ap_ST_fsm_state6 = 7'd32;
parameter    ap_ST_fsm_state7 = 7'd64;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [31:0] Input_1_V_V;
input   Input_1_V_V_ap_vld;
output   Input_1_V_V_ap_ack;
output  [31:0] Output_1_V_V;
output   Output_1_V_V_ap_vld;
input   Output_1_V_V_ap_ack;

reg ap_done;
reg ap_idle;
reg ap_ready;
reg Input_1_V_V_ap_ack;
reg[31:0] Output_1_V_V;
reg Output_1_V_V_ap_vld;

(* fsm_encoding = "none" *) reg   [6:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg    Input_1_V_V_blk_n;
wire    ap_CS_fsm_state4;
wire    ap_CS_fsm_state5;
reg    Output_1_V_V_blk_n;
wire    ap_CS_fsm_state2;
wire    ap_CS_fsm_state3;
wire    ap_CS_fsm_state6;
wire    ap_CS_fsm_state7;
reg   [7:0] reg_87;
reg    ap_block_state1;
reg    ap_sig_ioackin_Output_1_V_V_ap_ack;
reg   [7:0] reg_91;
reg   [7:0] tmp_reg_211;
reg   [7:0] triangle_3d_x2_V_reg_216;
wire   [7:0] triangle_2d_z_V_fu_192_p2;
reg   [7:0] triangle_2d_z_V_reg_221;
wire   [31:0] tmp_V_fu_99_p1;
wire   [31:0] tmp_V_3_fu_104_p1;
wire   [31:0] tmp_V_4_fu_109_p1;
wire   [31:0] tmp_V_5_fu_118_p1;
wire   [31:0] tmp_V_6_fu_198_p1;
wire   [31:0] tmp_V_7_fu_202_p1;
wire   [31:0] tmp_V_8_fu_207_p1;
reg    ap_reg_ioackin_Output_1_V_V_ap_ack;
wire   [7:0] triangle_3d_x0_V_fu_95_p1;
wire   [7:0] triangle_3d_y1_V_fu_114_p1;
wire   [7:0] mul5_fu_126_p1;
wire   [17:0] mul5_fu_126_p2;
wire   [7:0] mul2_fu_146_p1;
wire   [17:0] mul2_fu_146_p2;
wire   [7:0] tmp_2_fu_162_p1;
wire   [7:0] mul_fu_170_p1;
wire   [17:0] mul_fu_170_p2;
wire   [7:0] div2_fu_176_p4;
wire   [7:0] div_fu_132_p4;
wire   [7:0] div1_fu_152_p4;
wire   [7:0] tmp1_fu_186_p2;
reg   [6:0] ap_NS_fsm;
wire   [17:0] mul2_fu_146_p10;
wire   [17:0] mul5_fu_126_p10;
wire   [17:0] mul_fu_170_p10;

// power-on initialization
initial begin
#0 ap_CS_fsm = 7'd1;
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
        if ((((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1) & (1'b1 == ap_CS_fsm_state7)) | ((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1) & (1'b1 == ap_CS_fsm_state6)) | ((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1) & (1'b1 == ap_CS_fsm_state3)) | ((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1) & (1'b1 == ap_CS_fsm_state2)) | (~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state5)) | (~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state4)) | (~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld) | (ap_start == 1'b0)) & (1'b1 == ap_CS_fsm_state1)))) begin
            ap_reg_ioackin_Output_1_V_V_ap_ack <= 1'b0;
        end else if ((((1'b1 == ap_CS_fsm_state7) & (1'b1 == Output_1_V_V_ap_ack)) | ((1'b1 == ap_CS_fsm_state6) & (1'b1 == Output_1_V_V_ap_ack)) | ((1'b1 == ap_CS_fsm_state3) & (1'b1 == Output_1_V_V_ap_ack)) | ((1'b1 == ap_CS_fsm_state2) & (1'b1 == Output_1_V_V_ap_ack)) | ((1'b1 == Input_1_V_V_ap_vld) & (1'b1 == ap_CS_fsm_state5) & (1'b1 == Output_1_V_V_ap_ack)) | ((1'b1 == Input_1_V_V_ap_vld) & (1'b1 == ap_CS_fsm_state4) & (1'b1 == Output_1_V_V_ap_ack)) | (~((1'b0 == Input_1_V_V_ap_vld) | (ap_start == 1'b0)) & (1'b1 == Output_1_V_V_ap_ack) & (1'b1 == ap_CS_fsm_state1)))) begin
            ap_reg_ioackin_Output_1_V_V_ap_ack <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state4)) | (~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld) | (ap_start == 1'b0)) & (1'b1 == ap_CS_fsm_state1)))) begin
        reg_87 <= {{Input_1_V_V[15:8]}};
        reg_91 <= {{Input_1_V_V[31:24]}};
    end
end

always @ (posedge ap_clk) begin
    if ((~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld) | (ap_start == 1'b0)) & (1'b1 == ap_CS_fsm_state1))) begin
        tmp_reg_211 <= {{Input_1_V_V[23:16]}};
    end
end

always @ (posedge ap_clk) begin
    if ((~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state5))) begin
        triangle_2d_z_V_reg_221 <= triangle_2d_z_V_fu_192_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state4))) begin
        triangle_3d_x2_V_reg_216 <= {{Input_1_V_V[23:16]}};
    end
end

always @ (*) begin
    if (((~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state5)) | (~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state4)) | (~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld) | (ap_start == 1'b0)) & (1'b1 == ap_CS_fsm_state1)))) begin
        Input_1_V_V_ap_ack = 1'b1;
    end else begin
        Input_1_V_V_ap_ack = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state5) | (1'b1 == ap_CS_fsm_state4) | ((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1)))) begin
        Input_1_V_V_blk_n = Input_1_V_V_ap_vld;
    end else begin
        Input_1_V_V_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state7)) begin
        Output_1_V_V = tmp_V_8_fu_207_p1;
    end else if ((1'b1 == ap_CS_fsm_state6)) begin
        Output_1_V_V = tmp_V_7_fu_202_p1;
    end else if (((1'b1 == Input_1_V_V_ap_vld) & (1'b1 == ap_CS_fsm_state5))) begin
        Output_1_V_V = tmp_V_6_fu_198_p1;
    end else if (((1'b1 == Input_1_V_V_ap_vld) & (1'b1 == ap_CS_fsm_state4))) begin
        Output_1_V_V = tmp_V_5_fu_118_p1;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        Output_1_V_V = tmp_V_4_fu_109_p1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        Output_1_V_V = tmp_V_3_fu_104_p1;
    end else if ((~((1'b0 == Input_1_V_V_ap_vld) | (ap_start == 1'b0)) & (1'b1 == ap_CS_fsm_state1))) begin
        Output_1_V_V = tmp_V_fu_99_p1;
    end else begin
        Output_1_V_V = 'bx;
    end
end

always @ (*) begin
    if ((((ap_reg_ioackin_Output_1_V_V_ap_ack == 1'b0) & (1'b1 == ap_CS_fsm_state7)) | ((ap_reg_ioackin_Output_1_V_V_ap_ack == 1'b0) & (1'b1 == ap_CS_fsm_state6)) | ((ap_reg_ioackin_Output_1_V_V_ap_ack == 1'b0) & (1'b1 == ap_CS_fsm_state3)) | ((ap_reg_ioackin_Output_1_V_V_ap_ack == 1'b0) & (1'b1 == ap_CS_fsm_state2)) | ((ap_reg_ioackin_Output_1_V_V_ap_ack == 1'b0) & (1'b1 == Input_1_V_V_ap_vld) & (1'b1 == ap_CS_fsm_state5)) | ((ap_reg_ioackin_Output_1_V_V_ap_ack == 1'b0) & (1'b1 == Input_1_V_V_ap_vld) & (1'b1 == ap_CS_fsm_state4)) | (~((1'b0 == Input_1_V_V_ap_vld) | (ap_start == 1'b0)) & (ap_reg_ioackin_Output_1_V_V_ap_ack == 1'b0) & (1'b1 == ap_CS_fsm_state1)))) begin
        Output_1_V_V_ap_vld = 1'b1;
    end else begin
        Output_1_V_V_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state7) | (1'b1 == ap_CS_fsm_state6) | (1'b1 == ap_CS_fsm_state3) | (1'b1 == ap_CS_fsm_state2) | (1'b1 == ap_CS_fsm_state5) | (1'b1 == ap_CS_fsm_state4) | ((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1)))) begin
        Output_1_V_V_blk_n = Output_1_V_V_ap_ack;
    end else begin
        Output_1_V_V_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1) & (1'b1 == ap_CS_fsm_state7))) begin
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
    if (((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1) & (1'b1 == ap_CS_fsm_state7))) begin
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
            if ((~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld) | (ap_start == 1'b0)) & (1'b1 == ap_CS_fsm_state1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            if (((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end
        end
        ap_ST_fsm_state3 : begin
            if (((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1) & (1'b1 == ap_CS_fsm_state3))) begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        ap_ST_fsm_state4 : begin
            if ((~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state4))) begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end
        end
        ap_ST_fsm_state5 : begin
            if ((~((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b0) | (1'b0 == Input_1_V_V_ap_vld)) & (1'b1 == ap_CS_fsm_state5))) begin
                ap_NS_fsm = ap_ST_fsm_state6;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end
        end
        ap_ST_fsm_state6 : begin
            if (((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1) & (1'b1 == ap_CS_fsm_state6))) begin
                ap_NS_fsm = ap_ST_fsm_state7;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state6;
            end
        end
        ap_ST_fsm_state7 : begin
            if (((ap_sig_ioackin_Output_1_V_V_ap_ack == 1'b1) & (1'b1 == ap_CS_fsm_state7))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state7;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

assign ap_CS_fsm_state6 = ap_CS_fsm[32'd5];

assign ap_CS_fsm_state7 = ap_CS_fsm[32'd6];

always @ (*) begin
    ap_block_state1 = ((1'b0 == Input_1_V_V_ap_vld) | (ap_start == 1'b0));
end

assign div1_fu_152_p4 = {{mul2_fu_146_p2[17:10]}};

assign div2_fu_176_p4 = {{mul_fu_170_p2[17:10]}};

assign div_fu_132_p4 = {{mul5_fu_126_p2[17:10]}};

assign mul2_fu_146_p1 = mul2_fu_146_p10;

assign mul2_fu_146_p10 = reg_87;

assign mul2_fu_146_p2 = (18'd342 * mul2_fu_146_p1);

assign mul5_fu_126_p1 = mul5_fu_126_p10;

assign mul5_fu_126_p10 = tmp_reg_211;

assign mul5_fu_126_p2 = (18'd342 * mul5_fu_126_p1);

assign mul_fu_170_p1 = mul_fu_170_p10;

assign mul_fu_170_p10 = tmp_2_fu_162_p1;

assign mul_fu_170_p2 = (18'd342 * mul_fu_170_p1);

assign tmp1_fu_186_p2 = (div2_fu_176_p4 + div_fu_132_p4);

assign tmp_2_fu_162_p1 = Input_1_V_V[7:0];

assign tmp_V_3_fu_104_p1 = reg_87;

assign tmp_V_4_fu_109_p1 = reg_91;

assign tmp_V_5_fu_118_p1 = triangle_3d_y1_V_fu_114_p1;

assign tmp_V_6_fu_198_p1 = triangle_3d_x2_V_reg_216;

assign tmp_V_7_fu_202_p1 = reg_91;

assign tmp_V_8_fu_207_p1 = triangle_2d_z_V_reg_221;

assign tmp_V_fu_99_p1 = triangle_3d_x0_V_fu_95_p1;

assign triangle_2d_z_V_fu_192_p2 = (div1_fu_152_p4 + tmp1_fu_186_p2);

assign triangle_3d_x0_V_fu_95_p1 = Input_1_V_V[7:0];

assign triangle_3d_y1_V_fu_114_p1 = Input_1_V_V[7:0];

endmodule //projection_even