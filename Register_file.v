module Register_file #(parameter WIDTH=32)
    (
	  input clk, write_enable, reset,
	  input [3:0] Source_select_0, Source_select_1, Destination_select,
	  input	[WIDTH-1:0] DATA, Reg_15,
	  output [WIDTH-1:0] out_0, out_1,
	  output wire [WIDTH-1:0] register0,
	  output wire [WIDTH-1:0] register1,
	  output wire [WIDTH-1:0] register2,
	  output wire [WIDTH-1:0] register3,
	  output wire [WIDTH-1:0] register4,
	  output wire [WIDTH-1:0] register5,
	  output wire [WIDTH-1:0] register6,
	  output wire [WIDTH-1:0] register7,
	  output wire [WIDTH-1:0] register8,
	  output wire [WIDTH-1:0] register9,
	  output wire [WIDTH-1:0] register10,
	  output wire [WIDTH-1:0] register11,
	  output wire [WIDTH-1:0] register12,
	  output wire [WIDTH-1:0] register13,
	  output wire [WIDTH-1:0] register14,
	  output wire [WIDTH-1:0] register15,

		input wire [3:0] reg_out_select,
		output [31:0] reg_out_out
    );

wire [14:0] Reg_enable;

wire [WIDTH-1:0] Reg_Out[15:0];
assign register0 = Reg_Out[0];
assign register1 = Reg_Out[1];
assign register2 = Reg_Out[2];
assign register3 = Reg_Out[3];
assign register4 = Reg_Out[4];
assign register5 = Reg_Out[5];
assign register6 = Reg_Out[6];
assign register7 = Reg_Out[7];
assign register8 = Reg_Out[8];
assign register9 = Reg_Out[9];
assign register10 = Reg_Out[10];
assign register11 = Reg_Out[11];
assign register12 = Reg_Out[12];
assign register13 = Reg_Out[13];
assign register14 = Reg_Out[14];
assign register15 = Reg_Out[15];

genvar i;
generate
    for (i = 0 ; i < 15 ; i = i + 1) begin : registers
        Register_sync_rw #(WIDTH) Reg (.clk(~clk),.reset(reset),.we(Reg_enable[i]& write_enable),.DATA(DATA),.OUT(Reg_Out[i]));
    end
endgenerate

Decoder_4to16 dec (.IN(Destination_select),.OUT(Reg_enable));

Mux_16to1 #(WIDTH) mux_0 (.select(Source_select_0),
	.input_0 (Reg_Out[0]),
	.input_1 (Reg_Out[1]),
	.input_2 (Reg_Out[2]),
	.input_3 (Reg_Out[3]),
	.input_4 (Reg_Out[4]),
	.input_5 (Reg_Out[5]),
	.input_6 (Reg_Out[6]),
	.input_7 (Reg_Out[7]),
	.input_8 (Reg_Out[8]),
	.input_9 (Reg_Out[9]),
	.input_10(Reg_Out[10]),
	.input_11(Reg_Out[11]),
	.input_12(Reg_Out[12]),
	.input_13(Reg_Out[13]),
	.input_14(Reg_Out[14]),
	.input_15(Reg_15),
	.output_value(out_0)
    );
	
Mux_16to1 #(WIDTH) mux_1 (.select(Source_select_1),
	.input_0 (Reg_Out[0]),
	.input_1 (Reg_Out[1]),
	.input_2 (Reg_Out[2]),
	.input_3 (Reg_Out[3]),
	.input_4 (Reg_Out[4]),
	.input_5 (Reg_Out[5]),
	.input_6 (Reg_Out[6]),
	.input_7 (Reg_Out[7]),
	.input_8 (Reg_Out[8]),
	.input_9 (Reg_Out[9]),
	.input_10(Reg_Out[10]),
	.input_11(Reg_Out[11]),
	.input_12(Reg_Out[12]),
	.input_13(Reg_Out[13]),
	.input_14(Reg_Out[14]),
	.input_15(Reg_15),
	.output_value(out_1)
    );

Mux_16to1 #(WIDTH) mux_reg_out(
	.select(reg_out_select),
	.input_0 (Reg_Out[0]),
	.input_1 (Reg_Out[1]),
	.input_2 (Reg_Out[2]),
	.input_3 (Reg_Out[3]),
	.input_4 (Reg_Out[4]),
	.input_5 (Reg_Out[5]),
	.input_6 (Reg_Out[6]),
	.input_7 (Reg_Out[7]),
	.input_8 (Reg_Out[8]),
	.input_9 (Reg_Out[9]),
	.input_10(Reg_Out[10]),
	.input_11(Reg_Out[11]),
	.input_12(Reg_Out[12]),
	.input_13(Reg_Out[13]),
	.input_14(Reg_Out[14]),
	.input_15(Reg_15),
	.output_value(reg_out_out)
);

endmodule
