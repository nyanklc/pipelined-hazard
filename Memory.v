module Memory#(BYTE_SIZE=4, ADDR_WIDTH=32)(
input clk,WE,
input [ADDR_WIDTH-1:0] ADDR,
input [(BYTE_SIZE*8)-1:0] WD,
output [(BYTE_SIZE*8)-1:0] RD ,

output wire [7:0] mem0,
output wire [7:0] mem1,
output wire [7:0] mem2,
output wire [7:0] mem3
);

// reg [7:0] mem [4095:0];

reg [7:0] mem [15:0];

assign mem0 = mem[0];
assign mem1 = mem[1];
assign mem2 = mem[2];
assign mem3 = mem[3];

initial begin
//mem[0]<=8'h01;
//mem[1]<=8'h02;
//mem[2]<=8'h03;
//mem[3]<=8'h04;
$readmemh("mem_data2.txt",mem);
end
genvar i;
generate
	for (i = 0; i < BYTE_SIZE; i = i + 1) begin: read_generate
		assign RD[8*i+:8] = mem[ADDR+i];
	end
endgenerate	
integer k;

always @(posedge clk) begin
    if(WE == 1'b1) begin	
        for (k = 0; k < BYTE_SIZE; k = k + 1) begin
            mem[ADDR+k] <= WD[8*k+:8];
        end
    end
end

endmodule