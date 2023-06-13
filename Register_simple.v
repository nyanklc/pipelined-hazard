module Register_simple #(
     parameter WIDTH=32)
    (
	  input  clk, reset,
	  input	[WIDTH-1:0] DATA,
	  output reg [WIDTH-1:0] OUT = 0
    );
	 
always@(posedge clk) begin
	if(reset == 1'b0)
		OUT<=DATA;
	else	
		OUT<={WIDTH{1'b0}};
end
	 
endmodule	 