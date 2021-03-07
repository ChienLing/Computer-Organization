module Decoder( instr_op_i, instr_func_i, RegWrite_o, ALUOp_o, ALUSrc_o, RegDst_o, Jump_o, Jal_o, Branch_o, BranchType_o, BLT_o, BGEZ_o, MemRead_o, MemWrite_o, MemToReg_o );
   //                          ok         ok        ok        ok       ok      ok           ok          ok           ok          ok      
//I/O ports
input	[6-1:0] instr_op_i;
input	[6-1:0] instr_func_i;

output	[3-1:0] ALUOp_o;//3-bit decided by instr_op_i!!
output			ALUSrc_o;
output			RegWrite_o;
output  [2-1:0] RegDst_o;
///New
output			Jump_o;
output			Jal_o;
output			Branch_o;
output			BranchType_o;
output			BLT_o;
output			BGEZ_o;
output			MemWrite_o;
output			MemRead_o;
output			MemToReg_o;
 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire    [2-1:0] RegDst_o;

wire			Jump_o;
wire			Jal_o;
wire			Branch_o;
wire			BranchType_o;
wire			BLT_o;
wire			BGEZ_o;
wire			MemWrite_o;
wire			MemRead_o;
wire			MemToReg_o;

reg		[3-1:0] ALUOp_reg_o;
reg     [2-1:0] RegDst_reg_o;
//Main function
/*your code here*/
parameter [6-1:0] OP_RTYPE = 6'b111111;
parameter [6-1:0] OP_ADDI  = 6'b110111;
parameter [6-1:0] OP_BEQ   = 6'b111011;
parameter [6-1:0] OP_LUI   = 6'b110000;
parameter [6-1:0] OP_ORI   = 6'b001101;//
parameter [6-1:0] OP_LW	   = 6'b100001;
parameter [6-1:0] OP_SW    = 6'b100011;
parameter [6-1:0] OP_JUMP  = 6'b100010;
parameter [6-1:0] OP_BNE   = 6'b100101;
parameter [6-1:0] OP_BNEZ  = 6'b101101;
parameter [6-1:0] OP_JAL   = 6'b100111;
parameter [6-1:0] OP_BLT   = 6'b100110;
parameter [6-1:0] OP_BGEZ  = 6'b110001;
always @(*)
begin
	case(instr_op_i)
		OP_RTYPE : ALUOp_reg_o = 3'b010;//2
		OP_ADDI  : ALUOp_reg_o = 3'b100;//4
		OP_LUI   : ALUOp_reg_o = 3'b101;//5
		OP_ORI   : ALUOp_reg_o = 3'b011;//3
		OP_LW    : ALUOp_reg_o = 3'b000;//0
		OP_SW    : ALUOp_reg_o = 3'b000;//0
		OP_BEQ   : ALUOp_reg_o = 3'b001;//1
		OP_BNE   : ALUOp_reg_o = 3'b110;//6
		OP_BNEZ  : ALUOp_reg_o = 3'b110;//6
		OP_BLT   : ALUOp_reg_o = 3'b111;//7//slt rd rs rt if rs<rt rd=1(ALU_result[0]=1) branch
		OP_BGEZ  : ALUOp_reg_o = 3'b111;//7//slt rd rs rt(0) if rs>=0 rd=0(ALU_result[0]=0) branch
	endcase
	
	case(instr_op_i)
	OP_RTYPE :RegDst_reg_o = 2'b01;
	OP_ADDI  :RegDst_reg_o = 2'b00;
	//OP_BEQ   :RegDst_reg_o = 2'b00;
	OP_LUI   :RegDst_reg_o = 2'b00;
	OP_ORI   :RegDst_reg_o = 2'b00;//
	OP_LW	 :RegDst_reg_o = 2'b00;
	OP_SW    :RegDst_reg_o = 2'b00;
	//OP_JUMP  :RegDst_reg_o = 2'b00;
	//OP_BNE   :RegDst_reg_o = 2'b00;
	OP_JAL   :RegDst_reg_o = 2'b10;
	//OP_BLT   :RegDst_reg_o = 2'b00;
	//OP_BNEZ  :RegDst_reg_o = 2'b00;
	//OP_BGEZ  :RegDst_reg_o = 2'b00;
	endcase
	
end
assign ALUOp_o = ALUOp_reg_o;
assign RegDst_o = RegDst_reg_o;

assign ALUSrc_o = (instr_op_i == OP_ADDI || instr_op_i == OP_ORI || instr_op_i == OP_LW || instr_op_i == OP_SW)?1:0;
assign RegWrite_o = ((instr_op_i == OP_RTYPE && instr_func_i != 6'b001000) || instr_op_i == OP_ADDI || instr_op_i == OP_LUI || instr_op_i == OP_ORI || instr_op_i == OP_LW || instr_op_i == OP_JAL)?1:0;
//assign RegDst_o = (instr_op_i[5] == 0 || instr_op_i[3] == 0)?0:1;
assign Jump_o = (instr_op_i == OP_JUMP || instr_op_i == OP_JAL )?1:0;//NOT consider jr $ra
assign Jal_o = (instr_op_i == OP_JAL)?1:0;
assign Branch_o = (instr_op_i == OP_BEQ || instr_op_i == OP_BNE)?1:0;
assign BranchType_o = (instr_op_i == OP_BEQ)?0:1;
assign BLT_o = (instr_op_i == OP_BLT)?1:0;
assign BGEZ_o = (instr_op_i == OP_BGEZ)?1:0;
assign MemWrite_o = (instr_op_i == OP_SW)?1:0;
assign MemRead_o = (instr_op_i == OP_LW)?1:0;
assign MemToReg_o = (instr_op_i == OP_LW)?1:0;

endmodule
   