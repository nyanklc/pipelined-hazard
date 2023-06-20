//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module DE1_SOC(

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);

wire [31:0] reg_out, PC;
hexto7seg hex_0 (.hexn(HEX0), .hex(reg_out[3:0]));
hexto7seg hex_1 (.hexn(HEX1), .hex(reg_out[7:4]));

assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;

hexto7seg hex_4 (.hexn(HEX4), .hex(PC[3:0]));
hexto7seg hex_5 (.hexn(HEX5), .hex(PC[7:4]));

wire [31:0] dummy1;
wire [31:0] dummy2;
wire [7:0] dummy3;
wire [7:0] dummy4;
wire [7:0] dummy5;
wire [7:0] dummy6;

wire [1:0] forae;
wire [1:0] forbe;

hazard my_computer (
	KEY[0],  // clk
	KEY[1],  // reset
	SW[3:0],  // reg_out_select
	reg_out,  // reg_out
	dummy1,
	dummy2,
	dummy3,
	dummy4,
	dummy5,
	dummy6,
	PC,  // pc fetch
	LEDR[3],  // stallf
	LEDR[2],  // stalld
	LEDR[1],  // flushd
	LEDR[0],  // flushe
	forae,  // forward ae
	forbe  // forward be
);

assign LEDR[4] = 1'b0;
assign LEDR[5] = 1'b0;  // previously branch pred. hit
assign LEDR[7:6] = 3'b000;

endmodule