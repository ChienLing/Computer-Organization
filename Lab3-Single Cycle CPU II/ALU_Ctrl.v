module ALU_Ctrl( funct_i, ALUOp_i, Jr_o, ALU_operation_o, FURslt_o );
/*
    FUNC_ADD = 6'b010010;            0010 A+B
    FUNC_SUB = 6'b010000;            0110 A-B
    FUNC_AND = 6'b010100;            0000 A & B
    FUNC_OR  = 6'b010110;            0001 A | b
    FUNC_SLT = 6'b100000;            0111 slt
    FUNC_SLLV= 6'b000110; shift left 1
    FUNC_SLL = 6'b000000; shift left 1000
    FUNC_SRLV= 6'b000100; shigt right0000
    FUNC_SRL = 6'b000010; shigt right0
    FUNC_NOR = 6'b010101;            1100
*/
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output	   Jr_o;
output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;//00:R 01:shift 10:ori
     
//Internal Signals
wire		Jr_o;
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

reg [4-1:0] ALU_OP;
reg [2-1:0] FURslt_Reg_o;
//Main function
/*your code here*/
parameter [6-1:0] FUNC_ADD = 6'b010010;//18
parameter [6-1:0] FUNC_SUB = 6'b010000;//16
parameter [6-1:0] FUNC_AND = 6'b010100;//20
parameter [6-1:0] FUNC_OR  = 6'b010110;//22
parameter [6-1:0] FUNC_SLT = 6'b100000;//32
parameter [6-1:0] FUNC_NOR = 6'b010101;//21
parameter [6-1:0] FUNC_SLL = 6'b000000;//0 shift left
parameter [6-1:0] FUNC_SRL = 6'b000010;//2 shigt right
parameter [6-1:0] FUNC_SLLV= 6'b000110;//6
parameter [6-1:0] FUNC_SRLV= 6'b000100;//4
parameter [6-1:0] FUNC_JR  = 6'b001000;//8

assign ALU_operation_o = ALU_OP;
assign FURslt_o = FURslt_Reg_o;
assign Jr_o = (funct_i == FUNC_JR && ALUOp_i == 3'b010)?1:0;

always@(*)
begin
  case(ALUOp_i)
  2://R-type
  begin
    //FURslt_Reg_o = 0;
    case(funct_i)
		FUNC_ADD : ALU_OP = 4'b0010;//2
		FUNC_SUB : ALU_OP = 4'b0110;//6
		FUNC_AND : ALU_OP = 4'b0000;//0
		FUNC_OR  : ALU_OP = 4'b0001;//1
		FUNC_SLT : ALU_OP = 4'b0111;//7
		FUNC_NOR : ALU_OP = 4'b1100;//12
		  FUNC_SLLV: ALU_OP = 4'b1011;//11
		  FUNC_SRLV: ALU_OP = 4'b1010;//10
		 FUNC_SLL : ALU_OP = 4'b1111;//14
		 FUNC_SRL : ALU_OP = 4'b1110;//15
		//FUNC_JR  : ALU_OP = 4'b0011;//3
		 
	endcase
  end
  0:ALU_OP = 4'b0010;//LW SW
  1:ALU_OP = 4'b0110;//BEQ
  3:ALU_OP = 4'b0001;//ORI
  4:ALU_OP = 4'b0010;//ADDI
  //5://LUI
  6:ALU_OP = 4'b0110;//BNE Branch
  7:ALU_OP = 4'b0111;//BGEZ BLT
  endcase
  case(ALUOp_i)
    2://R-type
	begin
	//FURslt_Reg_o = 0;
	  case(funct_i)
		FUNC_ADD : FURslt_Reg_o = 2'b00;
		FUNC_SUB : FURslt_Reg_o = 2'b00;
		FUNC_AND : FURslt_Reg_o = 2'b00;
		FUNC_OR  : FURslt_Reg_o = 2'b00;
		FUNC_SLT : FURslt_Reg_o = 2'b00;
		FUNC_NOR : FURslt_Reg_o = 2'b00;
		  FUNC_SLLV: FURslt_Reg_o = 2'b01;
		  FUNC_SRLV: FURslt_Reg_o = 2'b01;
		 FUNC_SLL : FURslt_Reg_o = 2'b01;
		 FUNC_SRL : FURslt_Reg_o = 2'b01;
		 
	  endcase
	end
    0:FURslt_Reg_o = 2'b00;//LW SW
	//1:FURslt_Reg_o = 0110;//BEQ
	4:FURslt_Reg_o = 2'b00;//ADDI
	3:FURslt_Reg_o = 2'b00;//ORI
    5:FURslt_Reg_o = 2'b10;//LUI
  endcase
end
endmodule     
