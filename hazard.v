module hazard(
	input clk,
	input reset,
	input wire [3:0] reg_out_select,
	output wire [3:0] reg_out_out,
	output wire [31:0] register0,
	output wire [31:0] register1,
	output wire [7:0] mem0,
	output wire [7:0] mem1,
	output wire [7:0] mem2,
	output wire [7:0] mem3,

	output wire [31:0] pc_out,
	output wire StallF,
	output wire StallD,
	output wire FlushD,
	output wire FlushE,
	output wire [1:0] ForwardAE,
	output wire [1:0] ForwardBE
);

// Controller inputs
wire       PCSrcW;
wire       BranchTakenE;
wire       RegWriteW;
wire [1:0] RegSrcD;
wire [1:0] ImmSrcD;
wire [3:0] ALUControlE;
wire       ALUSrcE;
wire       MemWriteM;
wire       MemtoRegW;

wire 		shift_enable;
wire 		rotate_immediate_enable;

// Outputs
wire [1:0] Op;
wire [5:0] Funct;
wire [3:0] Rd;
wire [3:0] Cond;
wire [3:0] ALUFlags;
wire [31:0] rd1_execute;
wire [31:0] rd2_execute;
wire [31:0] rd1;
wire [31:0] rd2;
wire [3:0] wa3e;
wire [3:0] wa3m;
wire [3:0] wa3w;

// (for demonstration)
wire [31:0] inst_bus;
wire [31:0] result_wire;
wire [31:0] register2;
wire [31:0] register3;
wire [31:0] register4;
wire [31:0] register5;
wire [31:0] register6;
wire [31:0] register7;
wire [31:0] register8;
wire [31:0] register9;
wire [31:0] register10;
wire [31:0] register11;
wire [31:0] register12;
wire [31:0] register13;
wire [31:0] register14;
wire [31:0] register15;

wire BranchD;
wire RegWriteD;
wire MemWriteD;
wire MemtoRegD;
wire ALUSrcD;
wire [3:0] ALUControlD;
wire PCSrcE;
wire BranchE;
wire RegWriteE;
wire MemWriteE;
wire MemtoRegE;
wire PCSrcM;
wire RegWriteM;
wire MemtoRegM;

wire PCSrcD;
wire CondEx;

wire [3:0] ra1d, ra2d, ra1e, ra2e;

dpath dp(
	// Misc
	clk,
	reset,
	
   // Controller inputs
   PCSrcW,
   BranchTakenE,
   RegWriteW,
   RegSrcD,
   ImmSrcD,
   ALUControlE,
   ALUSrcE,
   MemWriteM,
   MemtoRegW,
	
	shift_enable,
	rotate_immediate_enable,

   // Hazard unit inputs
   StallF,
   StallD,
   FlushD,
   FlushE,
   ForwardAE,
   ForwardBE,

	// Outputs
   Op,
   Funct,
   Rd,
   Cond,
   ALUFlags,
	rd1_execute,
	rd2_execute,
	rd1,
	rd2,
	wa3e,
	wa3m,
	wa3w,
	
	// (for demonstration)
	inst_bus,
	result_wire,
	register0,
	register1,
	register2,
	register3,
	register4,
	register5,
	register6,
	register7,
	register8,
	register9,
	register10,
	register11,
	register12,
	register13,
	register14,
	register15,

	ra1d,
	ra2d,

	mem0,
	mem1,
	mem2,
	mem3,

	reg_out_select,
	reg_out_out,

	pc_out
);

controller cont(
	clk,
	reset,

	ALUFlags,
	Cond,
	Funct,
	Op,
	Rd,
	inst_bus,
	
	PCSrcW,
   BranchTakenE,
   RegWriteW,
   RegSrcD,
   ImmSrcD,
   ALUControlE,
   ALUSrcE,
   MemWriteM,
   MemtoRegW,
	
	shift_enable,
	rotate_immediate_enable,
	BranchD,
	RegWriteD,
	MemWriteD,
	MemtoRegD,
	ALUSrcD,
	ALUControlD,
	PCSrcE,
	BranchE,
	RegWriteE,
	MemWriteE,
	MemtoRegE,
	PCSrcM,
	RegWriteM,
	MemtoRegM,
	
	PCSrcD,
	CondEx,

	ra1d,
	ra2d,
	ra1e,
	ra2e,

	FlushE,
	FlushD
);

HazardUnit hu(
	ra1e,
	ra2e,
	ra1d,
	ra2d,
	wa3e,
	wa3m,
	wa3w,
	RegWriteM,
	RegWriteW,
	MemtoRegE,
	CondEx,
	BranchE,
	PCSrcD,
	PCSrcE,
	PCSrcM,
	PCSrcW,

	StallF,
	StallD,
	FlushD,
	FlushE,
	ForwardAE,
   	ForwardBE
);

endmodule