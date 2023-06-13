module better_extender(
	input [23:0] inp,
	input [1:0] ImmSrc,
	output reg [31:0] ExtImm
);

wire [31:0] worse_extender_out;
Extender worse_extender(.A(inp[11:0]), .select(ImmSrc[0]), .Q(worse_extender_out));

always @(*) begin
	case (ImmSrc)
		2'b10: ExtImm = {inp[23], inp[23], inp[23], inp[23], inp[23], inp[23], inp[23:0], 2'b00};
		default: ExtImm = worse_extender_out;
	endcase
end

endmodule