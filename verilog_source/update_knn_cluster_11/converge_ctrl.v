`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2018 08:08:05 PM
// Design Name: 
// Module Name: converge_ctrl
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


module  converge_ctrl#(
    parameter PACKET_BITS = 97,
    parameter NUM_PORT_BITS = 4,
    parameter NUM_IN_PORTS = 7, 
    parameter NUM_OUT_PORTS = 7,
    parameter SYN_TYPE = "yosys",
    localparam MAX_NUM_OUT_PORTS = 7,
    localparam MAX_NUM_IN_PORTS = 7,
    localparam FIFO_DEPTH = 16       
    )(
    input clk_bft,
    input clk_user,
    input reset,
    output reg [MAX_NUM_OUT_PORTS-1:0] outport_sel,
    output reg [PACKET_BITS-1:0] stream_out,
    input [NUM_IN_PORTS-1:0] freespace_update,
    input [PACKET_BITS*NUM_IN_PORTS-1:0] packet_from_input_ports,
    input [PACKET_BITS*MAX_NUM_OUT_PORTS-1:0] packet_from_output_ports,
    input [NUM_OUT_PORTS-1:0] empty,
    input resend
    );


    reg wr_update_en;
    reg [PACKET_BITS-1:0] fifo_din;
    reg rd_update_en;
    wire [PACKET_BITS-1:0] fifo_dout;    
    wire FreeUpdateEmpty;    
    reg FreeUpdateValid;
            
    reg [PACKET_BITS-1:0] stream_out_tmp;


    reg [NUM_PORT_BITS-1:0] poll_reg;
    reg [NUM_PORT_BITS-1:0] poll_reg_delay;
    reg resend_delay;
    
    
    reg [NUM_PORT_BITS-1:0] queue_reg;
    reg [PACKET_BITS-1:0] update_packet [MAX_NUM_IN_PORTS-1:0];
    reg [MAX_NUM_IN_PORTS-1:0] update_packet_rd_en;
    wire [NUM_IN_PORTS-1:0] freespace_update_en;  

    //stream_out is the output of converged stream out
    always@(posedge clk_bft) begin
        if(reset)
        begin
            stream_out <= 0;
        end
        else
            if(resend && resend_delay) begin
                stream_out_tmp <= stream_out_tmp;
                stream_out <= stream_out;
            end else if(!resend && resend_delay) begin
                stream_out_tmp <= 0;
                stream_out <= stream_out_tmp;
            end else if(resend && !resend_delay) begin    
                if(FreeUpdateValid) begin
                    stream_out_tmp <= fifo_dout;
                    stream_out <= stream_out;
                end else begin
                    case(poll_reg_delay)
                        4'b0000: begin 
                            stream_out_tmp <= packet_from_output_ports[PACKET_BITS*1-1:PACKET_BITS*0];
                            stream_out <= stream_out;
                        end
                        4'b0001: begin
                            stream_out_tmp <= packet_from_output_ports[PACKET_BITS*2-1:PACKET_BITS*1];
                            stream_out <= stream_out;
                        end
                        4'b0010: begin
                            stream_out_tmp <= packet_from_output_ports[PACKET_BITS*3-1:PACKET_BITS*2];
                            stream_out <= stream_out;
                        end
                        4'b0011: begin
                            stream_out_tmp <= packet_from_output_ports[PACKET_BITS*4-1:PACKET_BITS*3];
                            stream_out <= stream_out;
                        end
                        4'b0100: begin
                            stream_out_tmp <= packet_from_output_ports[PACKET_BITS*5-1:PACKET_BITS*4];
                            stream_out <= stream_out;
                        end
                        4'b0101: begin
                            stream_out_tmp <= packet_from_output_ports[PACKET_BITS*6-1:PACKET_BITS*5];
                            stream_out <= stream_out;
                        end
                        4'b0110: begin
                            stream_out_tmp <= packet_from_output_ports[PACKET_BITS*7-1:PACKET_BITS*6];
                            stream_out <= stream_out;
                        end
                        default: begin
                            stream_out = 0;
                        end
                    endcase
                end
            end else begin 
                if(FreeUpdateValid) begin
                    stream_out_tmp <= 0;
                    stream_out <= fifo_dout;
                end else begin             
                    case(poll_reg_delay)
                        4'b0000: begin 
                            stream_out_tmp <= 0;
                            stream_out <= packet_from_output_ports[PACKET_BITS*1-1:PACKET_BITS*0];
                        end
                        4'b0001: begin
                            stream_out_tmp <= 0;
                            stream_out <= packet_from_output_ports[PACKET_BITS*2-1:PACKET_BITS*1];
                        end
                        4'b0010: begin
                            stream_out_tmp <= 0;
                            stream_out <= packet_from_output_ports[PACKET_BITS*3-1:PACKET_BITS*2];
                        end
                        4'b0011: begin
                            stream_out_tmp <= 0;
                            stream_out <= packet_from_output_ports[PACKET_BITS*4-1:PACKET_BITS*3];
                        end
                        4'b0100: begin
                            stream_out_tmp <= 0;
                            stream_out <= packet_from_output_ports[PACKET_BITS*5-1:PACKET_BITS*4];
                        end
                        4'b0101: begin
                            stream_out_tmp <= 0;
                            stream_out <= packet_from_output_ports[PACKET_BITS*6-1:PACKET_BITS*5];
                        end
                        4'b0110: begin
                            stream_out_tmp <= 0;
                            stream_out <= packet_from_output_ports[PACKET_BITS*7-1:PACKET_BITS*6];
                        end
                        default: begin
                            stream_out = 0;
                        end
                    endcase
                end
            end
    end
    
            
    //poll_reg_delay: this is used to generate the stream_out
    //resend_delay: this is used to determine the input for stream_out
    always@(posedge clk_bft) begin
        if(reset) begin
            FreeUpdateValid <= 0;
            poll_reg_delay <= 0;
            resend_delay <= 0;
            
        end else begin
            FreeUpdateValid <= rd_update_en;
            poll_reg_delay <= poll_reg;
            resend_delay <= resend;
        end
    end
    
    //poll_reg: this is used to determine which outp port provides data for stream_out        
    always@(posedge clk_bft) begin
        if(reset) 
            poll_reg <= 0;
        else
            if(FreeUpdateEmpty && (!resend) && (!resend_delay))
                if(poll_reg == NUM_OUT_PORTS-1)
                    poll_reg <= 0;
                else
                    poll_reg <= poll_reg + 1;
            else
                poll_reg <= poll_reg;
    end
    

    always@(*)begin
        if (resend || resend_delay) begin
            rd_update_en = 0;
            outport_sel = 0;
        end else if(FreeUpdateEmpty) begin
            rd_update_en = 0;
            case(poll_reg)
                4'b0000: begin 
                    outport_sel = 1; 
                end
                4'b0001: begin
                    outport_sel = 2;
                end
                4'b0010: begin
                    outport_sel = 4;
                end
                4'b0011: begin
                    outport_sel = 8;
                end
                4'b0100: begin
                    outport_sel = 16;
                end
                4'b0101: begin
                    outport_sel = 32;
                end
                4'b0110: begin
                    outport_sel = 64;
                end
                default: begin
                    outport_sel = 0;
                end
            endcase
        end else begin
            rd_update_en = 1;
            outport_sel = 0;
        end
    end


//clk_bft clock domain    
/////////////////////////////////////////////////////////////////////////////////    

/*
    FreeUpdateFifo fuf (
      .rst(reset),        // input wire rst
      .wr_clk(clk_user),  // input wire wr_clk
      .rd_clk(clk_bft),  // input wire rd_clk
      .din(fifo_din),        // input wire [96 : 0] fifo_din
      .wr_en(wr_update_en),    // input wire wr_en
      .rd_en(rd_update_en),    // input wire rd_en
      .dout(fifo_dout),      // output wire [96 : 0] fifo_dout
      .full(),      // output wire full
      .empty(FreeUpdateEmpty)
    );
*/      
generate
    if(SYN_TYPE == "yosys") begin
        fifo2 #(
        .DSIZE(PACKET_BITS),
        .ASIZE($clog2(FIFO_DEPTH))
            )fifo1_inst(
            .rdata(fifo_dout), 
            .wfull(), 
            .rempty(FreeUpdateEmpty), 
            .wdata(fifo_din), 
            .winc(wr_update_en), 
            .wclk(clk_user), 
            .wrst_n(~reset), 
            .rinc(rd_update_en), 
            .rclk(clk_bft), 
            .rrst_n(~reset)
    );
    end else begin
        xpm_fifo_async # (
        
          .FIFO_MEMORY_TYPE          ("block"),           //string; "auto", "block", or "distributed";
          .ECC_MODE                  ("no_ecc"),         //string; "no_ecc" or "en_ecc";
          .RELATED_CLOCKS            (0),                //positive integer; 0 or 1
          .FIFO_WRITE_DEPTH          (FIFO_DEPTH),             //positive integer
          .WRITE_DATA_WIDTH          (PACKET_BITS),               //positive integer
          .WR_DATA_COUNT_WIDTH       (5),               //positive integer
          .PROG_FULL_THRESH          (10),               //positive integer
          .FULL_RESET_VALUE          (0),                //positive integer; 0 or 1
          .READ_MODE                 ("std"),            //string; "std" or "fwft";
          .FIFO_READ_LATENCY         (1),                //positive integer;
          .READ_DATA_WIDTH           (PACKET_BITS),               //positive integer
          .RD_DATA_COUNT_WIDTH       (5),               //positive integer
          .PROG_EMPTY_THRESH         (10),               //positive integer
    //      .fifo_dout_RESET_VALUE          ("0"),              //string
          .CDC_SYNC_STAGES           (2),                //positive integer
          .WAKEUP_TIME               (0)                 //positive integer; 0 or 2;
        
        ) xpm_fifo_async_inst (
        
          .rst              (reset),
          .wr_clk           (clk_user),
          .wr_en            (wr_update_en),
          .din              (fifo_din),
          .full             (),
          .overflow         (overflow),
          .wr_rst_busy      (wr_rst_busy),
          .rd_clk           (clk_bft),
          .rd_en            (rd_update_en),
          .dout             (fifo_dout),
          .empty            (FreeUpdateEmpty),
          .underflow        (underflow),
          .rd_rst_busy      (rd_rst_busy),
          .prog_full        (prog_full),
          .wr_data_count    (wr_data_count),
          .prog_empty       (prog_empty),
          .rd_data_count    (rd_data_count),
          .sleep            (1'b0),
          .injectsbiterr    (1'b0),
          .injectdbiterr    (1'b0),
          .sbiterr          (),
          .dbiterr          ()
        
        );    
    
    end
endgenerate
 
/////////////////////////////////////////////////////////////////////////////////    
//clk_user clock domain     

  
    //detect the rising edge of the update signals
    rise_detect #(
        .data_width(NUM_IN_PORTS)
    )rise_detect_u(
        .data_out(freespace_update_en),
        .data_in(freespace_update),
        .clk(clk_user),
        .reset(reset)
    );        
  
    //queue_reg: this reg is used to see whether any update requirements exist
    always@(posedge clk_user) begin
        if(reset) 
            queue_reg <= 0;
        else
            if(queue_reg == NUM_IN_PORTS-1)
                queue_reg <= 4'b0000;
            else
                queue_reg <= queue_reg + 1;
    end

    
    //wr_en
    //update_packet_rd_en is asserted, the corresponded update_packet should be cleared
    always@(*)begin
        case(queue_reg)
            4'b0000: begin
                if(update_packet[0][PACKET_BITS-1]) begin
                    wr_update_en <= 1'b1; 
                    update_packet_rd_en <= 1;
                    fifo_din <= update_packet[0];
                end
                else begin
                    wr_update_en <= 1'b0;
                    update_packet_rd_en <= 0;
                    fifo_din <= 0;
                end                    
            end
            4'b0001: begin
                if(update_packet[1][PACKET_BITS-1]) begin
                    wr_update_en <= 1'b1; 
                    update_packet_rd_en <= 2;
                    fifo_din <= update_packet[1];
                end
                else begin
                    wr_update_en <= 1'b0;
                    update_packet_rd_en <= 0;
                    fifo_din <= 0;
                end                    
            end
            4'b0010: begin
                if(update_packet[2][PACKET_BITS-1]) begin
                    wr_update_en <= 1'b1;
                    update_packet_rd_en <= 4;
                    fifo_din <= update_packet[2];
                end
                else begin
                    wr_update_en <= 1'b0;
                    update_packet_rd_en <= 0;
                    fifo_din <= 0;
                end                    
            end
            4'b0011: begin
                if(update_packet[3][PACKET_BITS-1]) begin
                    wr_update_en <= 1'b1;
                    update_packet_rd_en <= 8;
                    fifo_din <= update_packet[3];
                end
                else begin
                    wr_update_en <= 1'b0;
                    update_packet_rd_en <= 0;
                    fifo_din <= 0;
                end                    
            end
            4'b0100: begin
                if(update_packet[4][PACKET_BITS-1]) begin
                    wr_update_en <= 1'b1;
                    update_packet_rd_en <= 16;
                    fifo_din <= update_packet[4];
                end
                else begin
                    wr_update_en <= 1'b0;
                    update_packet_rd_en <= 0;
                    fifo_din <= 0;
                end                    
            end
            4'b0101: begin
                if(update_packet[5][PACKET_BITS-1]) begin
                    wr_update_en <= 1'b1;
                    update_packet_rd_en <= 32;
                    fifo_din <= update_packet[5];
                end
                else begin
                    wr_update_en <= 1'b0;
                    update_packet_rd_en <= 0;
                    fifo_din <= 0;
                end
            end
            4'b0110: begin
                if(update_packet[6][PACKET_BITS-1]) begin
                    wr_update_en <= 1'b1;
                    update_packet_rd_en <= 64;
                    fifo_din <= update_packet[6];
                end
                else begin
                    wr_update_en <= 1'b0;
                    update_packet_rd_en <= 0;
                    fifo_din <= 0;
                end
            end
            default: begin
                wr_update_en <= 1'b0;
                update_packet_rd_en <= 0;
                fifo_din <= 0;
            end
        endcase
    end   
    
    //prepare the fifo_din for the update fifo
    genvar gv_i;
    generate
    for(gv_i = 0; gv_i < NUM_IN_PORTS; gv_i = gv_i + 1) begin: updata_reg
        always@(posedge clk_user) begin
            if(reset)
                update_packet[gv_i] <= 0;
            else if(freespace_update_en[gv_i])
                update_packet[gv_i] <= packet_from_input_ports[PACKET_BITS*(gv_i+1)-1: PACKET_BITS*gv_i];
            else if(update_packet_rd_en[gv_i])
                update_packet[gv_i] <= 0;
            else
                update_packet[gv_i] <= update_packet[gv_i];
        end
    end
    endgenerate
    
             

        
endmodule
