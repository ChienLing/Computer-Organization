module HazardDetectionUnit(ID_RSnum_i, ID_RTnum_i, EX_RTnum_i, EX_MemWrite_i, ControlHazard_i, PC_Write_o, ,IF_IDWrite_o, IF_Flash_o, ID_Flash_o, EX_Flash_o);

//I/O ports 
input [5-1:0] ID_RSnum_i;
input [5-1:0] ID_RTnum_i;
input [5-1:0] EX_RTnum_i;
input EX_MemWrite_i;
input ControlHazard_i;

output PC_Write_o;
output IF_IDWrite_o;
output IF_Flash_o;
output ID_Flash_o;
output EX_Flash_o;
//Internal Signals

//Main function
/*your code here*/
assign PC_Write_o = ((ID_RSnum_i == EX_RTnum_i || ID_RTnum_i == EX_RTnum_i) && EX_MemWrite_i)?0:1;
assign IF_IDWrite_o = ((ID_RSnum_i == EX_RTnum_i || ID_RTnum_i == EX_RTnum_i) && EX_MemWrite_i)?0:1;
assign IF_Flash_o = (ControlHazard_i == 1)?1:0;
assign ID_Flash_o = (ControlHazard_i == 1)?1:0;
assign EX_Flash_o = (ControlHazard_i == 1)?1:0;

endmodule