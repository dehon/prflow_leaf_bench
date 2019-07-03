// From Eddie Hung
// extracted from: https://github.com/eddiehung/vtr-with-yosys/blob/vtr7-with-yosys/vtr_flow/misc/yosys_models.v#L220

(* blackbox *)
module M18x25(A, B, OUT);
parameter A_WIDTH = 18;
parameter B_WIDTH = 25;
parameter Y_WIDTH = A_WIDTH+B_WIDTH;
input [A_WIDTH-1:0] A;
input [B_WIDTH-1:0] B;
output [Y_WIDTH-1:0] OUT;

assign OUT = A * B;
/*
*/

endmodule
