module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 overflow;
wire	[32-1:0] result;

reg overflow_reg;
reg [32-1:0] Result;
//Main function
/*your code here*/
assign result = Result;
assign overflow = overflow_reg;
assign zero = (result == 0)?1:0;
always @(ALU_operation_i, aluSrc1, aluSrc2)
begin
  case (ALU_operation_i)
    4'b0000:Result <= aluSrc1 & aluSrc2;
	4'b0001:Result <= aluSrc1 | aluSrc2;
	4'b0111:Result <= (signed'(aluSrc1) < signed'(aluSrc2))? 1 : 0;
	4'b1100:Result <= ~(aluSrc1 | aluSrc2);
	4'b0010:Result <= aluSrc1 + aluSrc2;
	4'b0110:Result <= aluSrc1 - aluSrc2;
	default: Result<=0;
  endcase
  
  case (ALU_operation_i)
    4'b0010:
	begin 
	  if (aluSrc1[31] ==aluSrc2[31] && aluSrc1[31] != result[31])
	    overflow_reg <= 1'b1;
	end
	4'b0110:
	begin
	  if (aluSrc1[31] !=aluSrc2[31] && aluSrc1[31] != result[31])
	    overflow_reg <= 1'b1;
	end
	default: overflow_reg <= 1'b0;
  endcase
end
endmodule
