module Shifter( result, leftRight, shamt, sftSrc );

	//I/O ports 
	output	[32-1:0] result;

	input	leftRight;
	input	[5-1:0] shamt;
	input	[32-1:0] sftSrc ;

	//Internal Signals
	wire	[32-1:0] result;
	reg [32-1:0] TemR;
	//Main function
	/*your code here*/
	assign result = TemR;
	//assign result = (leftRight == 1'b1)? sftSrc << shamt:sftSrc >> shamt;
	always@(*)
	begin
	if (leftRight == 1'b1)
	  TemR = sftSrc << shamt;
	else
	  TemR = sftSrc >> shamt;
	end/**/

endmodule