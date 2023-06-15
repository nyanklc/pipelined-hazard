module controller(
	input 	clk,
	input	reset,

	input [3:0]  ALUFlags,
	input [3:0]  Cond,
	input [5:0]  Funct,
	input [1:0]  Op,
	input [3:0]  Rd,
	input [31:0] inst_bus,

    output reg       PCSrcW = 0,
    output wire      BranchTakenE,
    output reg       RegWriteW = 0,
    output reg [1:0] RegSrcD = 0,
    output reg [1:0] ImmSrcD = 0,
    output reg [3:0] ALUControlE = 0,
    output reg       ALUSrcE = 0,
    output reg       MemWriteM = 0,
    output reg       MemtoRegW = 0,

	output reg		 shift_enable = 0,
	output reg		 rotate_immediate_enable = 0,

	output reg BranchD = 0,
	output reg RegWriteD = 0,
	output reg MemWriteD = 0,
	output reg MemtoRegD = 0,
	output reg ALUSrcD = 0,
	output reg [3:0] ALUControlD = 0,
	output reg PCSrcE = 0,
	output reg BranchE = 0,
	output reg RegWriteE = 0,
	output reg MemWriteE = 0,
	output reg MemtoRegE = 0,
	output reg PCSrcM = 0,
	output reg RegWriteM = 0,
	output reg MemtoRegM = 0,

	output reg PCSrcD = 0,
	output reg CondEx = 0,

	input [3:0]  ra1d,
	input [3:0]  ra2d,
	output reg [3:0] ra1e,
	output reg [3:0] ra2e,

	input FlushE,
	input FlushD
);

reg [3:0] FlagsE;
wire [3:0] Flags; assign Flags = ALUFlags;
reg [3:0] CondE;

reg FlagWriteD;
reg FlagWriteE;

reg prevFlushD = 0;

// carry pipelined signals
always @(posedge clk) begin

	prevFlushD <= FlushD;

	FlagWriteE  <= FlagWriteD;

	PCSrcE 	 	<= PCSrcD & ~FlushE;
	BranchE 	<= BranchD & ~FlushE;
	RegWriteE 	<= RegWriteD & ~FlushE;
	MemWriteE 	<= MemWriteD & ~FlushE;
	MemtoRegE 	<= MemtoRegD & ~FlushE;
	ALUControlE <= ALUControlD & ~FlushE;
	ALUSrcE 	<= ALUSrcD & ~FlushE;

	if (FlagWriteE)
		FlagsE 		<= Flags;

	CondE 		<= Cond;

	PCSrcM 		<= PCSrcE && CondEx;
	RegWriteM 	<= RegWriteE && CondEx;
	MemWriteM 	<= MemWriteE && CondEx;
	MemtoRegM 	<= MemtoRegE;

	PCSrcW	 	<= PCSrcM;
	RegWriteW	<=	RegWriteM;
	MemtoRegW	<=	MemtoRegM;

	if (~FlushE) begin
		ra1e <= ra1d;
		ra2e <= ra2d;
	end
end

assign BranchTakenE = BranchE && CondEx;

wire N, Z, CO, OVF;
assign N 	= FlagsE[3];
assign Z 	= FlagsE[2];
assign CO 	= FlagsE[1];
assign OVF	= FlagsE[0];

always @(*) begin
	FlagWriteD = (Op == 2'b00) && inst_bus[20];

	PCSrcD = (Rd == 15) & RegWriteD;

	// condition check
	case(CondE)
		0:  CondEx = Z;
		1:  CondEx = ~Z;
		2:  CondEx = CO;
		3:  CondEx = ~CO;
		4:  CondEx = N;
		5:  CondEx = ~N;
		6:  CondEx = OVF;
		7:  CondEx = ~OVF;
		8:  CondEx = ~Z & CO;
		9:  CondEx = Z | ~CO;
		10: CondEx = ~(N ^ OVF);
		11: CondEx = (N ^ OVF);
		12: CondEx = ~Z & ~(N ^ OVF);
		13: CondEx = Z | (N ^ OVF);
		14: CondEx = 1;
		default: CondEx = 1;
	endcase

	// same as the single cycle control
	// arrange control signals based on current instruction (if condition is met)
	case (Op)
		// DP
		2'b00: begin
			RegSrcD = 2'b00;
			MemtoRegD = 0;
			RegWriteD = 1;
			MemWriteD = 0;
			ALUSrcD = 0;
			ALUControlD = Funct[4:1];
			BranchD = 0;

			/* new mov instruction */
			if (inst_bus[24:21] == 4'b1101 && inst_bus[25] == 1) begin
				rotate_immediate_enable = 1;
				shift_enable = 0;
			end
			else begin
				rotate_immediate_enable = 0;
				shift_enable = 1;
			end
		end

		// MEM
		2'b01: begin
			ALUControlD = 4'b0100;
			ALUSrcD = 1;
			RegSrcD = 2'b10;
			ImmSrcD = 2'b01;  // second bit needs to be 1 (better extender)
			BranchD = 0;
			MemtoRegD = 0;

			if (Funct[0] == 0) begin  // STORE
				MemWriteD = 1;
				RegWriteD = 0;
				MemtoRegD = 0;
			end else begin  // LOAD
				MemWriteD = 0;
				RegWriteD = 1;
				MemtoRegD = 1;
			end

			shift_enable = 0;
			rotate_immediate_enable = 0;
		end

		// BRANCH
		2'b10: begin // alucontrol ?
			RegSrcD = 2'b01;
			MemtoRegD = 0;
			RegWriteD = 0;
			MemWriteD = 0;
			ALUSrcD = 1;
			BranchD = 1;
			ImmSrcD = 2'b10;
			ALUControlD = 4'b0100;

			shift_enable = 0;
			rotate_immediate_enable = 0;
		end
	endcase

	if (prevFlushD) begin
		PCSrcD = 0;
		BranchD = 0;
		RegWriteD = 0;
		MemWriteD = 0;
		MemtoRegD = 0;
		ALUControlD = 0;
		ALUSrcD = 0;
		FlagWriteD = 0;
		RegSrcD = 0;
		ImmSrcD = 0;
	end
end

endmodule
