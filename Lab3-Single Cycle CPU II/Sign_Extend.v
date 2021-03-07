module Sign_Extend( data_i, data_o );

parameter size = 0;		
//I/O ports

input	[size-1:0] data_i;//input	[16-1:0] data_i;
output	[32-1:0] data_o;

//Internal Signals
wire	[32-1:0] data_o;

//Sign extended
/*your code here*/
genvar idx;
for (idx=0; idx<size; idx=idx+1)//for (idx=0; idx<16; idx=idx+1)
begin
  assign data_o[idx] = data_i[idx];
end
for (idx=size; idx<32; idx=idx+1)//for (idx=16; idx<32; idx=idx+1)
begin
  assign data_o[idx] = data_i[size-1];//assign data_o[idx] = data_i[15];
end 
endmodule      
