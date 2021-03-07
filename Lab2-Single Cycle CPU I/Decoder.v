module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o );
   //                          ok         ok        ok        ok      
//I/O ports
input	[6-1:0] instr_op_i;

output	[3-1:0] ALUOp_o;//3-bit decided by instr_op_i!!
output			ALUSrc_o;
output			RegWrite_o;
output			RegDst_o;
 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;
//Main function
/*your code here*/
assign RegWrite_o = instr_op_i[0];
assign RegDst_o = (instr_op_i[5] == 0 || instr_op_i[3] == 0)?0:1;
assign ALUSrc_o = (instr_op_i == 6'b110111 || instr_op_i == 6'b001101)?1:0;
                    //OP_ADDI  = 6'b110111       OP_ORI   = 6'b001101;
assign ALUOp_o[2] = instr_op_i[4];
assign ALUOp_o[1] = instr_op_i[3];
assign ALUOp_o[0] = instr_op_i[1];

endmodule
   