module Forwarding(EX_RSnum_i, EX_RTnum_i, MEM_RDnum_i, WB_RDnum_i, MEM_RegWrite_i, WB_RegWite_i, ForwardA_o, ForwardB_o);

//I/O ports 
input [5-1:0] EX_RSnum_i;
input [5-1:0] EX_RTnum_i;
input [5-1:0] MEM_RDnum_i;
input [5-1:0] WB_RDnum_i;
input MEM_RegWrite_i;
input WB_RegWite_i;

output [2-1:0] ForwardA_o;
output [2-1:0] ForwardB_o;
//Internal Signals
reg [2-1:0] ForwardA;
reg [2-1:0] ForwardB;
assign ForwardA_o = ForwardA;
assign ForwardB_o = ForwardB;
//Main function
/*your code here*/
always@(*)
begin
	if(MEM_RDnum_i == EX_RSnum_i && MEM_RDnum_i != 0 && MEM_RegWrite_i == 1)
	begin
		ForwardA = 2'b10;
	end
	else if (WB_RDnum_i == EX_RSnum_i && WB_RDnum_i != 0 && WB_RegWite_i == 1)
	begin
		ForwardA = 2'b01;
	end
	else
	begin
		ForwardA = 2'b00;
	end
		
	if(MEM_RDnum_i == EX_RTnum_i && MEM_RDnum_i != 0 && MEM_RegWrite_i == 1)
	begin
		ForwardB = 2'b10;
	end
	else if (WB_RDnum_i == EX_RTnum_i && WB_RDnum_i != 0 && WB_RegWite_i == 1)
	begin
		ForwardB = 2'b01;
	end
	else
	begin
		ForwardB = 2'b00;
	end
end
endmodule
