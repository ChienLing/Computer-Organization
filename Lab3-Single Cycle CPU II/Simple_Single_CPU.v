module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles

/*Point Counter*/
wire [32-1:0] pc_out;
/*PC_Addr_With_Branch 2 to 1 mux*/
wire [32-1:0] pc_in_2;
/*PC_Addr_With_Jump 2 to 1 mux*/
wire [32-1:0] pc_in_3;
/*PC_Addr_With_Jr 2 to 1 mux*/
wire [32-1:0] pc_in_final;

/*Adder1*/
wire [32-1:0] pc_in_i;

/*Adder2*/
wire[32-1:0] Branch_addr_shift;

/*Jump Address after shifter left 2*/
wire[32-1:0] Jump_Addr;

/*Zero inverse choose*/
wire IfBranch;

/*ALU_result[0] inverse choose*/
wire sltRD_0or1;

/*branch address for after Adder2*/
wire[32-1:0] Branch_addr;

/*Instruction Memory*/
wire [32-1:0] instr_wire;
wire [32-1:0] RT_num;
/*Register*/
wire [32-1:0] ALU_RS_data;
wire [32-1:0] RT_data;

/*Decoder*/
wire [3-1:0] ALUOp;
wire [2-1:0] RegDst;
wire RegWrite;
wire ALUSrc;
wire Jump;
wire Jal;
wire Branch;
wire BranchType;
wire BLT;
wire BGEZ;
wire MemRead;
wire MemWrite;
wire MemToReg;

/*AND gate*/
wire Branch_wire;
wire CMBranch;
/*OR gate*/
wire BLTorBGEZ;
wire select_Branch;

/*AND gate*/
and and1(Branch_wire,Branch,IfBranch);
and and2(CMBranch,sltRD_0or1,BLTorBGEZ);
/*OR gate*/
or or1(BLTorBGEZ,BLT,BGEZ);
or or2(select_Branch,Branch_wire,CMBranch);

/*ALU Control*/
wire [4-1:0] aluop;
wire [2-1:0] FURslt;
wire Jr;

/*Shifter*/
wire [32-1:0] shifter_result;

/*Sign Extended*/
wire [32-1:0] Imme_Extended;


/*Zero Filled*/
wire [32-1:0] Imme_Fill_Zero;

 
/*RD 3 to 1 mux*/
wire [5-1:0] Ra_Reg;
wire [5-1:0] Write_Reg;
assign Ra_Reg = 5'b11111;

/*ALU Src 2 to 1 mux1*/
wire [32-1:0] RT_data2;

/*ALU Src 2 to 1 mux2*/
wire [32-1:0] ALU_RT_data;

/*ALU*/
wire [32-1:0] ALU_result;
wire ALU_zero;
wire ALU_overflow;
wire ALU_result_0_inverse;
assign ALU_result_0_inverse = ~ALU_result[0];

/*shifter_src2Src 2 to 0 mux*/
wire[4:0] shifter_Shamt;

/*Result 3 to 1 mux*/
wire [32-1:0] FURslt_result;

/*Data Memory result*/
wire[32-1:0] DM_result;

/*Final Result1 2 to 1 mux*/
wire[32-1:0] MemOrFUR;

/*Final Result1 2 to 1 mux*/
wire[32-1:0] Final_result;

assign Jump_Addr[31] = pc_in_i[31];
assign Jump_Addr[30] = pc_in_i[30];
assign Jump_Addr[29] = pc_in_i[29];
assign Jump_Addr[28] = pc_in_i[28];
//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_in_final) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(4),
	    .sum_o(pc_in_i)    
	    );
	

/*slt result choose 2 to 1 mux*/
Mux2to1 #(.size(1)) SLTresult_mux(
        .data0_i(ALU_result[0]),
        .data1_i(ALU_result_0_inverse),
        .select_i(BGEZ),//blt:0 bgez:1
        .data_o(sltRD_0or1)
        );	

Shifter jump_shifter_left2(
		.result(Jump_Addr), 
		.leftRight(1'b1),//left
		.shamt(5'd2),////////////////////////////////
		.sftSrc(instr_wire[26-1:0]) 
		);
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr_wire)    //reg
	    );

/*Mux2to1 #(.size(5)) Mux_Write_Reg(//5 bit mux
        .data0_i(instr_wire[20:16]),//rt
        .data1_i(instr_wire[15:11]),//rd
        .select_i(RegDst),
        .data_o(Write_Reg)
        );	*/
		
Mux3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_wire[20:16]),
        .data1_i(instr_wire[15:11]),
		.data2_i(Ra_Reg),
        .select_i(RegDst),
        .data_o(Write_Reg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr_wire[25:21]) ,  
        .RTaddr_i(instr_wire[20:16]) ,  
        .RDaddr_i(Write_Reg) ,  
        .RDdata_i(Final_result)  , //3 to 0 mux ans/////////////////////rectify
        .RegWrite_i(RegWrite),
        .RSdata_o(ALU_RS_data) ,  
        .RTdata_o(RT_data)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_wire[31:26]), 
		.instr_func_i(instr_wire[5:0]),
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),
	    .RegDst_o(RegDst),
		.Jump_o(Jump),
		.Jal_o(Jal),
		.Branch_o(Branch),
		.BranchType_o(BranchType),
		.BLT_o(BLT),
		.BGEZ_o(BGEZ),
		.MemRead_o(MemRead),
		.MemWrite_o(MemWrite),
		.MemToReg_o(MemToReg)
		);

ALU_Ctrl AC(
        .funct_i(instr_wire[5:0]),   
        .ALUOp_i(ALUOp),   
		.Jr_o(Jr),
        .ALU_operation_o(aluop),
		.FURslt_o(FURslt)
        );
	
Sign_Extend #(.size(16))SE(
        .data_i(instr_wire[15:0]),
        .data_o(Imme_Extended)
        );

Shifter Branch_Shift2(
		.result(Branch_addr_shift), 
		.leftRight(1'b1),//aluop[0]
		.shamt(5'd2),
		.sftSrc(Imme_Extended) 
		);
		
Adder Adder2(
        .src1_i(pc_in_i),     
	    .src2_i(Branch_addr_shift),
	    .sum_o(Branch_addr)    
	    );
	
Zero_Filled ZF(
        .data_i(instr_wire[15:0]),
        .data_o(Imme_Fill_Zero)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src1(
        .data0_i(RT_data),
        .data1_i(Imme_Extended),
        .select_i(ALUSrc),
        .data_o(RT_data2)
        );	
		
Mux2to1 #(.size(32)) ALU_src2Src2(
        .data0_i(RT_data2),
        .data1_i(32'd0),//RT_num
        .select_i(BGEZ),
        .data_o(ALU_RT_data)
        );	
		
ALU ALU(
		.aluSrc1(ALU_RS_data),
	    .aluSrc2(ALU_RT_data),
	    .ALU_operation_i(aluop),
		.result(ALU_result),
		.zero(ALU_zero),
		.overflow(ALU_overflow)
	    );
		
Mux2to1 #(.size(1)) ALU_Zero(
        .data0_i(ALU_zero),
        .data1_i(~ALU_zero),
        .select_i(BranchType),
        .data_o(IfBranch)
        );	
		
Mux2to1 #(.size(32)) PC_Addr_With_Branch(//W/O:Without
        .data0_i(pc_in_i),
        .data1_i(Branch_addr),
        .select_i(select_Branch),
        .data_o(pc_in_2)
        );	
		
Mux2to1 #(.size(32)) PC_Addr_with_Jump(//W/O:Without
        .data0_i(pc_in_2),
        .data1_i(Jump_Addr),
        .select_i(Jump),
        .data_o(pc_in_3)
        );	
		
Mux2to1 #(.size(32)) PC_Addr_with_Jr(//W/O:Without
        .data0_i(pc_in_3),
        .data1_i(ALU_RS_data),
        .select_i(Jr),
        .data_o(pc_in_final)
        );	
	
Mux2to1 #(.size(5)) shifter_src2Src(
        .data0_i(instr_wire[10:6]),
        .data1_i(ALU_RS_data[4:0]),
        .select_i(instr_wire[2]),
        .data_o(shifter_Shamt)
		);
		
Shifter shifter(
		.result(shifter_result), 
		.leftRight(aluop[0]),//aluop[0]
		.shamt(shifter_Shamt),////////////////////////////////
		.sftSrc(ALU_RT_data) 
		);
		
Mux3to1 #(.size(32)) MemAddr_Or_ALUResult(
        .data0_i(ALU_result),
        .data1_i(shifter_result),
		.data2_i(Imme_Fill_Zero),
        .select_i(FURslt),
        .data_o(FURslt_result)
        );			

Data_Memory DM(
		.clk_i(clk_i),
		.addr_i(FURslt_result),
		.data_i(RT_data),
		.MemRead_i(MemRead),
		.MemWrite_i(MemWrite),
		.data_o(DM_result)
		);
		
Mux2to1 #(.size(32)) RDdata_Src1(
        .data0_i(FURslt_result),
        .data1_i(DM_result),
        .select_i(MemToReg),
        .data_o(MemOrFUR)
		);

Mux2to1 #(.size(32)) RDdata_Src2(//W/O:Without
        .data0_i(MemOrFUR),
        .data1_i(pc_in_i),////////////
        .select_i(Jal),
        .data_o(Final_result)/////////////
        );		
endmodule



