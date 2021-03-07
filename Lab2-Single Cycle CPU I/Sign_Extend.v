module Sign_Extend( data_i, data_o );

//I/O ports
input	[16-1:0] data_i;
output	[32-1:0] data_o;

//Internal Signals
wire	[32-1:0] data_o;

//Sign extended
/*your code here*/
genvar idx;
for (idx=0; idx<16; idx=idx+1)
begin
  assign data_o[idx] = data_i[idx];
end
for (idx=16; idx<32; idx=idx+1)
begin
  assign data_o[idx] = data_i[15];
end 
endmodule      
