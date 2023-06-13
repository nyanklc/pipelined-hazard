module HazardUnit(
	input [3:0] ra1e,
	input [3:0] ra2e,
	input [3:0] ra1d,
	input [3:0] ra2d,
	input [3:0] wa3e,
	input [3:0] wa3m,
	input [3:0] wa3w,
	input 		RegWriteM,
	input 		RegWriteW,
	input 		MemtoRegE,
	input 		CondEx,
	input 		BranchE,
	input 		PCSrcD,
	input			PCSrcE,
	input 		PCSrcM,
	input 		PCSrcW,

	output  		 StallF,
	output  		 StallD,
	output  		 FlushD,
	output  		 FlushE,
	output reg [1:0] ForwardAE = 2'b00,
   output reg [1:0] ForwardBE = 2'b00
);

wire Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E, LDRstall, BranchTakenE, PCWrPendingF;

assign Match_1E_M = (ra1e == wa3m);
assign Match_1E_W = (ra1e == wa3w);

assign Match_2E_M = (ra2e == wa3m);
assign Match_2E_W = (ra2e == wa3w);

assign Match_12D_E = (ra1d == wa3e) || (ra2d == wa3e);
assign LDRstall = Match_12D_E && MemtoRegE;
assign BranchTakenE = BranchE && CondEx;

assign PCWrPendingF = PCSrcD || PCSrcE || PCSrcM;
assign StallF = LDRstall || PCWrPendingF;
assign StallD = LDRstall;
assign FlushD = PCWrPendingF || PCSrcW || BranchTakenE;
assign FlushE = LDRstall || BranchTakenE;

always @(*) begin
	if (Match_1E_M && RegWriteM)
		ForwardAE = 2'b10;
	else if (Match_1E_W && RegWriteW)
		ForwardAE = 2'b01;
	else
		ForwardAE = 2'b00;

	if (Match_2E_M && RegWriteM)
		ForwardBE = 2'b10;
	else if (Match_2E_W && RegWriteW)
		ForwardBE = 2'b01;
	else
		ForwardBE = 2'b00;
end

endmodule
