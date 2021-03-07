module Zero_Filled( data_i, data_o );

//I/O ports
input	[16-1:0] data_i;
output	[32-1:0] data_o;

//Internal Signals
wire	[32-1:0] data_o;
genvar i;
//Zero_Filled
/*your code here*/
for(i=0; i<16; i=i+1)
begin 
  assign data_o[i+16] = data_i[i];
  assign data_o[i] = 0;
end

endmodule      
