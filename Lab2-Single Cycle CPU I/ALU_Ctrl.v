module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );
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

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;//00:R 01:shift 10:ori
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;
reg [4-1:0] ALU_OP;
reg [2-1:0] To_Reg;
//Main function
/*your code here*/
assign ALU_operation_o = ALU_OP;
assign FURslt_o = To_Reg;
parameter [6-1:0] FUNC_ADD = 6'b010010;
parameter [6-1:0] FUNC_SUB = 6'b010000;
parameter [6-1:0] FUNC_AND = 6'b010100;
parameter [6-1:0] FUNC_OR  = 6'b010110;
parameter [6-1:0] FUNC_SLT = 6'b100000;
parameter [6-1:0] FUNC_NOR = 6'b010101;
parameter [6-1:0] FUNC_SLL = 6'b000000;//shift left
parameter [6-1:0] FUNC_SRL = 6'b000010;//shigt right
parameter [6-1:0] FUNC_SLLV= 6'b000110;
parameter [6-1:0] FUNC_SRLV= 6'b000100;
always@(*)
begin
  case(ALUOp_i)
  7://R-type
  begin
    //To_Reg = 0;
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
		 
	endcase
  end
  
  5:ALU_OP = 4'b0010;//ADDI
  0:ALU_OP = 0110;//BEQ
  2:ALU_OP = 0001;//ORI
  //3://LUI
  endcase
  case(ALUOp_i)
    7://R-type
	begin
	//To_Reg = 0;
	  case(funct_i)
		FUNC_ADD : To_Reg = 2'b00;
		FUNC_SUB : To_Reg = 2'b00;
		FUNC_AND : To_Reg = 2'b00;
		FUNC_OR  : To_Reg = 2'b00;
		FUNC_SLT : To_Reg = 2'b00;
		FUNC_NOR : To_Reg = 2'b00;
		  FUNC_SLLV: To_Reg = 2'b01;
		  FUNC_SRLV: To_Reg = 2'b01;
		 FUNC_SLL : To_Reg = 2'b01;
		 FUNC_SRL : To_Reg = 2'b01;
		 
	  endcase
	end
	5:To_Reg = 2'b00;//ADDI
	//0:To_Reg = 0110;//BEQ
	2:To_Reg = 2'b00;//ORI
    3:To_Reg = 2'b10;//LUI
  endcase
end
endmodule     
