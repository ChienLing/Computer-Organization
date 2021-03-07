module ALU_1bit( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ); 


  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  reg TemReg;
  /*your code here*/ 
  wire Oand, Oor, Oadd;
  wire A, B;
  assign A = (invertA == 1'b0)?a:~a;
  assign B = (invertB == 1'b0)?b:~b;
  and and1(Oand, A, B);
  or or1(Oor, A, B);
  Full_adder FA(Oadd, carryOut, carryIn, A ,B);//Full_adder(sum, carryOut, carryIn, input1, input2);
  always@(*)
  begin
    case (operation)
      2'd0: TemReg <= Oand;
      2'd1: TemReg <= Oor;
      2'd2: TemReg <= Oadd;
      2'd3: TemReg <= less;
      default;
    endcase
  end
  assign result = TemReg;
endmodule