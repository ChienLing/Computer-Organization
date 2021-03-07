module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
/*pipeline reg*/
reg [64-1:0] IF_ID;
reg [230-1:0] ID_EX;
reg [141-1:0] EX_MEM;
reg [71-1:0] MEM_WB;

/****************************      IF stage       *******************************/
/*PC_Addr_With_Branch 2 to 1 mux*/
wire [32-1:0] PC_Addr_With_Branch;

/*PC_Addr_With_Jump 2 to 1 mux*/
wire [32-1:0] PC_Addr_With_Jump;

/*Point Counter*/
wire [32-1:0] pc_out;

/*PC_Addr_With_Jr 2 to 1 mux*/
wire [32-1:0] pc_final;

/*Adder1*/
wire [32-1:0] pc_add_4;

/*Instruction Memory*/
wire [32-1:0] instr_wire1;
wire [32-1:0] instr_wire2;

/*****************************      ID stage       *******************************/
/*Hazard Detection Unit*/
//input
wire ControlHazard;
//output
wire PC_Write;
wire IF_IDWirte;
wire IF_Flash;
wire ID_Flash;
wire EX_Flash;

/*Decoder*/
wire [3-1:0] ID_ALUOp;
wire ID_RegDst;
wire ID_RegWrite;
wire ID_ALUSrc;
wire ID_Jump;
wire ID_Branch;
wire ID_BranchType;
wire ID_MemRead;
wire ID_MemWrite;
wire ID_MemToReg;

wire [12-1:0]CtrSignal;
assign CtrSignal[0] = ID_MemToReg;
assign CtrSignal[1] = ID_RegWrite;
assign CtrSignal[2] = ID_MemRead;
assign CtrSignal[3] = ID_MemWrite;
assign CtrSignal[4] = ID_Branch;
assign CtrSignal[5] = ID_BranchType;
assign CtrSignal[6] = ID_Jump;
assign CtrSignal[9:7] = ID_ALUOp;
assign CtrSignal[10] = ID_ALUSrc;
assign CtrSignal[11] = ID_RegDst;

/*ID Control Signal 2 to 1 mux*/
wire [12-1:0] ID_CtrSignal;

wire [32-1:0] ID_Addr;
assign ID_Addr = IF_ID[31:0];
/*Jump Address after shifter left 2*/
wire[32-1:0] ID_Jump_Addr;
assign ID_Jump_Addr[31] = ID_Addr[31];
assign ID_Jump_Addr[30] = ID_Addr[30];
assign ID_Jump_Addr[29] = ID_Addr[29];
assign ID_Jump_Addr[28] = ID_Addr[28];

wire [6-1:0] OPcode;
wire [5-1:0] ID_RSnum;
wire [5-1:0] ID_RTnum;
wire [5-1:0] ID_RDnum;
wire [5-1:0] ID_shamt;
wire [6-1:0] ID_FunCode;
assign OPcode[6-1:0]     = IF_ID[63:58];
assign ID_RSnum[5-1:0]   = IF_ID[57:53];
assign ID_RTnum[5-1:0]   = IF_ID[52:48];
assign ID_RDnum[5-1:0]   = IF_ID[47:43];
assign ID_shamt[5-1:0]   = IF_ID[42:38];
assign ID_FunCode[6-1:0] = IF_ID[37:32];

/*Register*/
wire [32-1:0] ID_RS_data;
wire [32-1:0] ID_RT_data;

/*Sign Extended*/
wire [32-1:0] ID_Imme_Extended;

/*Zero Filled*/
wire [32-1:0] ID_Imme_Fill_Zero;

/*****************************      EX stage       *******************************/
/*Control signal*/
wire [3-1:0] EX_ALUOp;
wire EX_RegDst;
wire EX_RegWrite;
wire EX_ALUSrc;
wire EX_Jump;
wire EX_Branch;
wire EX_BranchType;
wire EX_MemRead;
wire EX_MemWrite;
wire EX_MemToReg;

assign EX_MemToReg = ID_EX[0];
assign EX_RegWrite = ID_EX[1];
assign EX_MemRead = ID_EX[2];
assign EX_MemWrite = ID_EX[3];
assign EX_Branch = ID_EX[4];
assign EX_BranchType = ID_EX[5];
assign EX_Jump = ID_EX[6];
assign EX_ALUOp = ID_EX[9:7];
assign EX_ALUSrc = ID_EX[10];
assign EX_RegDst = ID_EX[11];

wire [2-1:0]EX_WBCtrSignal1;
/*EX flash mux*/
wire [2-1:0]EX_WBCtrSignal2;

wire [5-1:0]EX_MEMCtrSignal1;
/*EX flash mux*/
wire [5-1:0]EX_MEMCtrSignal2;

assign EX_WBCtrSignal1[0] = EX_MemToReg;
assign EX_WBCtrSignal1[1] = EX_RegWrite;

assign EX_MEMCtrSignal1[0] = EX_MemRead;
assign EX_MEMCtrSignal1[1] = EX_MemWrite;
assign EX_MEMCtrSignal1[2] = EX_Branch;
assign EX_MEMCtrSignal1[3] = EX_BranchType;
assign EX_MEMCtrSignal1[4] = EX_Jump;

/*Jump Address*/
wire [32-1:0] EX_Jump_Addr;
assign EX_Jump_Addr = ID_EX[43:12];

/*Address before Branch*/
wire [32-1:0] Branch_Addr_Before;
assign Branch_Addr_Before = ID_EX[75:44];
/*branch address for after Adder2*/
wire [32-1:0] EX_Branch_addr;

/*Branch Offset*/
wire [32-1:0] Branch_Offset;

/*ALU Control*/
wire [4-1:0] EX_aluop;
wire [2-1:0] EX_FURslt;

/*ALU*/
wire [32-1:0] EX_RS_data;
wire [32-1:0] MEM_RS_data;
wire [32-1:0] WB_RS_data;

assign EX_RS_data = ID_EX[107:76];
assign MEM_RS_data = EX_MEM[103:72];
assign WB_RS_data = MEM_WB[33:2];

wire [32-1:0] EX_RT_data;
wire [32-1:0] MEM_RT_data;
wire [32-1:0] WB_RT_data;

assign EX_RT_data = ID_EX[139:108];
assign MEM_RT_data = EX_MEM[103:72];
assign WB_RT_data = MEM_WB[33:2];

wire [32-1:0] EX_ALU_RS_data;
wire [32-1:0] EX_ALU_RT_data1;
wire [32-1:0] EX_ALU_RT_data2;


wire EX_Zero;
wire EX_Overflow;
wire [32-1:0] EX_ALU_Result;

wire [32-1:0] EX_Imme_Fill_Zero;
wire [32-1:0] EX_Imme_Extended;

assign EX_Imme_Fill_Zero = ID_EX[171:140];
assign EX_Imme_Extended = ID_EX[203:172];

/*Shifter*/
wire [32-1:0] EX_Shifter_Result;

wire [5-1:0] EX_RSnum;
wire [5-1:0] EX_RTnum;
wire [5-1:0] EX_RDnum;
wire [5-1:0] EX_Shamt;
wire [6-1:0] EX_Func;
assign EX_RSnum = ID_EX[208:204];
assign EX_RTnum = ID_EX[213:209];
assign EX_RDnum = ID_EX[218:214];
assign EX_Shamt = ID_EX[223:219];
assign EX_Func = ID_EX[229:224];

wire [5-1:0] EX_Final_RDnum;

/*FURslt result*/
wire [32-1:0] EX_FURslt_Result;

/*Forwarding*/
wire [2-1:0] ForwardA;
wire [2-1:0] ForwardB;

/*****************************      MEM stage       *******************************/
wire MEM_RegWrite;
wire MEM_Jump;
wire MEM_Branch;
wire MEM_BranchType;
wire MEM_MemRead;
wire MEM_MemWrite;
wire MEM_MemToReg;

assign MEM_MemToReg = EX_MEM[0];
assign MEM_RegWrite = EX_MEM[1];
assign MEM_MemRead = EX_MEM[2];
assign MEM_MemWrite = EX_MEM[3];
assign MEM_Branch = EX_MEM[4];
assign MEM_BranchType = EX_MEM[5];
assign MEM_Jump = EX_MEM[6];

wire [2-1:0] MEM_CtrSignal;
assign MEM_CtrSignal[0] = MEM_MemToReg;
assign MEM_CtrSignal[1] = MEM_RegWrite;

/*Branch*/
wire [32-1:0] MEM_Branch_Addr;
assign MEM_Branch_Addr = EX_MEM[70:39];
/*Jump Addr*/
wire [32-1:0] MEM_Jump_Addr;
assign MEM_Jump_Addr = EX_MEM[38:7];

wire MEM_Zero;
wire MEM_Zero_Inverse;

assign MEM_Zero = EX_MEM[71];
assign MEM_Zero_Inverse = ~MEM_Zero;

/*AND gate*/
wire MEM_BranchTest;

/*anwser for choose zero  mux*/
wire MEM_IfBranch;

/*MEM FURslt_Result*/
wire [32-1:0] MEM_FURslt_Result;
assign MEM_FURslt_Result = EX_MEM[103:72];

wire [32-1:0] MEM_RT_data_LW;
assign MEM_RT_data_LW = EX_MEM[135:104];

wire [5-1:0] MEM_RDnum;
assign MEM_RDnum = EX_MEM[140:136];

/*Data Memory result*/
wire [32-1:0] MEM_DM_Result;

/******************************      WB stage       ******************************/
/*WB signal*/
wire WB_MemToReg;
wire WB_RegWrite;

assign WB_MemToReg = MEM_WB[0];
assign WB_RegWrite = MEM_WB[1];

wire [32-1:0] WB_Mem_data;
wire [32-1:0] WB_FURSlt_data;

assign WB_Mem_data = MEM_WB[33:2];
assign WB_FURSlt_data = MEM_WB[65:34];

/*Memory To Register Final Result1 2 to 1 mux*/
wire [5-1:0] WB_RDnum;
wire[32-1:0] WB_RD_data;
assign WB_RDnum = MEM_WB[70:66];
/******************************  Pipeline Register  ********************************/
always @(negedge rst_n or posedge clk_i )//or LoadUse or ControlHazard
begin
	if (rst_n == 0 || IF_Flash == 1)
		IF_ID[63:0] <= 64'd0;
	else
	begin
		IF_ID[31:0] = pc_add_4[31:0];
		IF_ID[63:32] = instr_wire2[31:0];
	end
	
	if (rst_n == 0)
	begin
		ID_EX[229:0] <= 230'd0;
		EX_MEM[140:0] <= 141'd0;
		MEM_WB[70:0] <= 71'd0;
	end
	else
	begin
		ID_EX[11:0] <= ID_CtrSignal;
		ID_EX[43:12] <= ID_Jump_Addr;
		ID_EX[75:44] <= ID_Addr;
		ID_EX[107:76] <= ID_RS_data;
		ID_EX[139:108] <= ID_RT_data;
		ID_EX[171:140] <= ID_Imme_Fill_Zero;
		ID_EX[203:172] <= ID_Imme_Extended;
		ID_EX[208:204] <= ID_RSnum;
		ID_EX[213:209] <= ID_RTnum;
		ID_EX[218:214] <= ID_RDnum;
		ID_EX[223:219] <= ID_shamt;
		ID_EX[229:224] <= ID_FunCode;
		
		EX_MEM[1:0] <= EX_WBCtrSignal2;
		EX_MEM[6:2] <= EX_MEMCtrSignal2;
		EX_MEM[38:7] <= EX_Jump_Addr;
		EX_MEM[70:39] <= EX_Branch_addr;
		EX_MEM[71] <= EX_Zero;
		EX_MEM[103:72] <= EX_FURslt_Result;
		EX_MEM[135:104] <= EX_ALU_RT_data1;
		EX_MEM[140:136] <= EX_Final_RDnum;
		
		MEM_WB[1:0] = MEM_CtrSignal;
		MEM_WB[33:2] = MEM_DM_Result;
		MEM_WB[65:34] = MEM_FURslt_Result;
		MEM_WB[70:66] = MEM_RDnum;
	end
end

//modules
/****************************      IF stage       *******************************/
Mux2to1 #(.size(32)) Mux_PC_Addr_With_Branch(//W/O:Without
        .data0_i(pc_add_4),
        .data1_i(MEM_Branch_Addr),
        .select_i(MEM_BranchTest),//select_Branch
        .data_o(PC_Addr_With_Branch)
        );	
		
Mux2to1 #(.size(32)) Mux_PC_Addr_with_Jump(//W/O:Without
        .data0_i(PC_Addr_With_Branch),
        .data1_i(MEM_Jump_Addr),
        .select_i(MEM_Jump),//select_Jump
        .data_o(PC_Addr_With_Jump)
        );	
		
Mux2to1 #(.size(32)) Mux_PC_write(//  W/O:Without
        .data0_i(pc_out),
        .data1_i(PC_Addr_With_Jump),
        .select_i(PC_Write),
        .data_o(pc_final)
        );	
		
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_final) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(4),
	    .sum_o(pc_add_4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr_wire1)    //reg
	    );
		
Mux2to1 #(.size(32)) Mux_instr_wire(//5 bit mux/////////////////
        .data0_i(instr_wire1),//rt
        .data1_i(32'd0),//rd
        .select_i(IF_Flash),
        .data_o(instr_wire2)
        );	
		
/****************************      ID stage       *******************************/
HazardDetectionUnit HDU(
		.ID_RSnum_i(ID_RSnum) ,
		.ID_RTnum_i(ID_RTnum) , 
		.EX_RTnum_i(EX_RTnum) ,
		.EX_MemWrite_i(EX_MemWrite) ,
		.ControlHazard_i(ControlHazard) ,
		.PC_Write_o(PC_Write) ,
		.IF_IDWrite_o(IF_IDWirte) ,
		.IF_Flash_o(IF_Flash) ,
		.ID_Flash_o(ID_Flash) ,
		.EX_Flash_o(EX_Flash)
		);
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(ID_RSnum) ,  
        .RTaddr_i(ID_RTnum) ,  
        .Wrtaddr_i(WB_RDnum) ,  
        .Wrtdata_i(WB_RD_data) , 
        .RegWrite_i(WB_RegWrite) ,
        .RSdata_o(ID_RS_data) ,  
        .RTdata_o(ID_RT_data)   
        );
		
Decoder Decoder(
        .instr_op_i(OPcode), 
		.instr_func_i(ID_FunCode),
	    .RegWrite_o(ID_RegWrite), 
	    .ALUOp_o(ID_ALUOp),   
	    .ALUSrc_o(ID_ALUSrc),
	    .RegDst_o(ID_RegDst),
		.Jump_o(ID_Jump),
		.Branch_o(ID_Branch),
		.BranchType_o(ID_BranchType),
		.MemRead_o(ID_MemRead),
		.MemWrite_o(ID_MemWrite),
		.MemToReg_o(ID_MemToReg)
		);
		
Mux2to1 #(.size(12)) Mux_CtrSignal(//5 bit mux/////////////////
        .data0_i(CtrSignal),//rt
        .data1_i(12'd0),//rd
        .select_i(ID_Flash),
        .data_o(ID_CtrSignal)
        );	
		
Shifter jump_shifter_left2(
		.result(ID_Jump_Addr), 
		.leftRight(1'b1),//left
		.shamt(5'd2),
		.sftSrc(IF_ID[57:32]) 
		);

Zero_Filled ZF(
        .data_i(IF_ID[47:32]),
        .data_o(ID_Imme_Fill_Zero)
        );

Sign_Extend #(.size(16))SE(
        .data_i(IF_ID[47:32]),
        .data_o(ID_Imme_Extended)
        );

		
/*****************************      EX stage       *******************************/
Mux2to1 #(.size(2)) Mux_EX_Flash1(
        .data0_i(EX_WBCtrSignal1[1:0]),
        .data1_i(2'b00),
        .select_i(EX_Flash),
        .data_o(EX_WBCtrSignal2)
        );

Mux2to1 #(.size(5)) Mux_EX_Flash2(
        .data0_i(EX_MEMCtrSignal1[4:0]),
        .data1_i(5'b00000),
        .select_i(EX_Flash),
        .data_o(EX_MEMCtrSignal2)
        );

Shifter Branch_Shift2(
		.result(Branch_Offset), 
		.leftRight(1'b1),//aluop[0]
		.shamt(5'd2),
		.sftSrc(EX_Imme_Extended) 
		);
		
Adder Adder2(
        .src1_i(Branch_Addr_Before),     
	    .src2_i(Branch_Offset),
	    .sum_o(EX_Branch_addr)    
	    );

Mux3to1 #(.size(32)) Mux_Forward1(
        .data0_i(EX_RS_data),
        .data1_i(MEM_RS_data),
		.data2_i(WB_RS_data),
        .select_i(ForwardA),
        .data_o(EX_ALU_RS_data)
        );			
		
Mux3to1 #(.size(32)) Mux_Forward2(
        .data0_i(EX_RT_data),
        .data1_i(MEM_RT_data),
		.data2_i(WB_RT_data),
        .select_i(ForwardB),
        .data_o(EX_ALU_RT_data1)
        );
	
Mux2to1 #(.size(32)) ALU_src2Src1(
        .data0_i(EX_ALU_RT_data1),
        .data1_i(EX_Imme_Extended),
        .select_i(EX_ALUSrc),
        .data_o(EX_ALU_RT_data2)
        );		
		
ALU_Ctrl AC(
        .funct_i(EX_Func),
        .ALUOp_i(EX_ALUOp),
        .ALU_operation_o(EX_aluop),
		.FURslt_o(EX_FURslt)
        );

ALU ALU(
		.aluSrc1(EX_ALU_RS_data),
	    .aluSrc2(EX_ALU_RT_data2),
	    .ALU_operation_i(EX_aluop),
		.result(EX_ALU_Result),
		.zero(EX_Zero),
		.overflow(EX_Overflow)
	    );	

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(EX_RTnum) ,//rt
        .data1_i(EX_RDnum) ,//rd
        .select_i(EX_RegDst) ,
        .data_o(EX_Final_RDnum) 
        );		

Shifter shifter(
		.result(EX_Shifter_Result), 
		.leftRight(EX_aluop[0]),
		.shamt(EX_Shamt),
		.sftSrc(EX_ALU_RT_data1) 
		);
		
Mux3to1 #(.size(32)) Mux_FURslt(
        .data0_i(EX_ALU_Result),
        .data1_i(EX_Shifter_Result),
		.data2_i(EX_Imme_Fill_Zero),
        .select_i(EX_FURslt),
        .data_o(EX_FURslt_Result)
        );		

Forwarding Forwarding(
		.EX_RSnum_i(EX_RSnum), 
		.EX_RTnum_i(EX_RTnum), 
		.MEM_RDnum_i(MEM_RDnum), 
		.WB_RDnum_i(WB_RDnum), 
		.MEM_RegWrite_i(MEM_RegWrite), 
		.WB_RegWite_i(WB_RegWrite), 
		.ForwardA_o(ForwardA), 
		.ForwardB_o(ForwardB)
		);
/*****************************      MEM stage       *******************************/
/*AND gate*/
and and1(MEM_BranchTest,MEM_Branch,MEM_IfBranch);
/*OR gate*/
or or1(ControlHazard, MEM_BranchTest, EX_Jump);	

Mux2to1 #(.size(1)) ALU_Zero(
        .data0_i(MEM_Zero),
        .data1_i(MEM_Zero_Inverse),
        .select_i(MEM_BranchType),
        .data_o(MEM_IfBranch)
        );	
		
Data_Memory DM(
		.clk_i(clk_i),
		.addr_i(MEM_FURslt_Result),
		.data_i(MEM_RT_data_LW),
		.MemRead_i(MEM_MemRead),
		.MemWrite_i(MEM_MemWrite),
		.data_o(MEM_DM_Result)
		);
		
/*****************************      WB stage       *******************************/
Mux2to1 #(.size(32)) Mux_MEMtoReg(//W/O:Without
        .data0_i(WB_FURSlt_data),
        .data1_i(WB_Mem_data),
        .select_i(WB_MemToReg),
        .data_o(WB_RD_data)
        );	

endmodule



