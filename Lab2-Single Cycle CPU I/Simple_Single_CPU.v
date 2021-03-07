module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles

/*Point Counter*/
wire [32-1:0] pc_in_i;
//wire [32-1:0] pc_addr;
//reg  [32-1:0] pc_out;
wire [32-1:0] pc_out;

/*Instruction Memory*/
//reg  [32-1:0] instr;
wire [32-1:0] instr_wire;

/*Register*/
wire [32-1:0] ALU_RS_data;
wire [32-1:0] RT_data;

/*Decoder*/
wire [3-1:0] ALUOp;
wire RegWrite;
wire RegDst;
wire ALUSrc;

/*ALU Control*/
wire [4-1:0] aluop;
wire [2-1:0] TO_Reg;

/*Shifter*/
wire [32-1:0] shifter_result;

/*Sign Extended*/
wire [32-1:0] Imme_Extended;

/*Zero Filled*/
wire [32-1:0] Imme_Fill_Zero;

/*RD 2 to 1 mux*/
wire [5-1:0] Write_Reg;

/*ALU Src 2 to 1 mux*/
wire [32-1:0] ALU_RT_Data;

/*ALU*/
wire [32-1:0] ALU_result;
wire ALU_zero;
wire ALU_overflow;

/*shifter_src2Src 2 to 0 mux*/
wire[4:0] shifter_Src;

/*Result 3 to 1 mux*/
wire [32-1:0] Final_result;


//assign pc_addr = pc_out;
//assign instr_wire = instr;

//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_in_i) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(4),
	    .sum_o(pc_in_i)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr_wire)    //reg
	    );

Mux2to1 #(.size(5)) Mux_Write_Reg(//5 bit mux
        .data0_i(instr_wire[20:16]),//rt
        .data1_i(instr_wire[15:11]),//rd
        .select_i(RegDst),
        .data_o(Write_Reg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr_wire[25:21]) ,  
        .RTaddr_i(instr_wire[20:16]) ,  
        .RDaddr_i(Write_Reg) ,  
        .RDdata_i(Final_result)  , //3 to 0 mux ans
        .RegWrite_i(instr_wire[30]),
        .RSdata_o(ALU_RS_data) ,  
        .RTdata_o(RT_data)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_wire[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst)   
		);

ALU_Ctrl AC(
        .funct_i(instr_wire[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALU_operation_o(aluop),
		.FURslt_o(TO_Reg)
        );
	
Sign_Extend SE(
        .data_i(instr_wire[15:0]),
        .data_o(Imme_Extended)
        );

Zero_Filled ZF(
        .data_i(instr_wire[15:0]),
        .data_o(Imme_Fill_Zero)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(RT_data),
        .data1_i(Imme_Extended),
        .select_i(ALUSrc),
        .data_o(ALU_RT_Data)
        );	
		
ALU ALU(
		.aluSrc1(ALU_RS_data),
	    .aluSrc2(ALU_RT_Data),
	    .ALU_operation_i(aluop),
		.result(ALU_result),
		.zero(ALU_zero),
		.overflow(ALU_overflow)
	    );
		
Mux2to1 #(.size(5)) shifter_src2Src(
        .data0_i(instr_wire[10:6]),
        .data1_i(ALU_RS_data[4:0]),
        .select_i(instr_wire[2]),
        .data_o(shifter_Src)
		);
		
Shifter shifter(
		.result(shifter_result), 
		.leftRight(aluop[0]),//aluop[0]
		.shamt(shifter_Src),////////////////////////////////
		.sftSrc(ALU_RT_Data) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(ALU_result),
        .data1_i(shifter_result),
		.data2_i(Imme_Fill_Zero),
        .select_i(TO_Reg),
        .data_o(Final_result)
        );			

endmodule



