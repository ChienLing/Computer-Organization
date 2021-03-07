module Shifter( result, leftRight, shamt, sftSrc  );
    
  output wire[31:0] result;

  input wire leftRight;
  input wire[4:0] shamt;
  input wire[31:0] sftSrc ;
  
  /*your code here*/ 
  reg[31:0] TemR;
  always@(*)
  begin
    if (leftRight == 1'b1)
	begin
	  /*for(idx=31; idx>=shamt; idx=idx-1)
	    result[idx] = sftSrc[idx-shamt];
	  for(idx=shamt-1; idx>=0; idx=idx-1)
	    result[idx] = 0*/
          TemR <= sftSrc << shamt;
	end
    else
      TemR <= sftSrc >> shamt;
  end
  assign result = TemR;
endmodule