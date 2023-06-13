module dpath(
	// Misc
	input clk,
	input reset,

   // Controller inputs
   input       PCSrcW,
   input       BranchTakenE,
   input       RegWriteW,
   input [1:0] RegSrcD,
   input [1:0] ImmSrcD,
   input [3:0] ALUControlE,
   input       ALUSrcE,
   input       MemWriteM,
   input       MemtoRegW,

	input 		shift_enable,
	input 		rotate_immediate_enable,

   // Hazard unit inputs
   input 		StallF,
   input 		StallD,
   input 		FlushD,
   input 		FlushE,
   input [1:0] ForwardAE,
   input [1:0] ForwardBE,

	// Outputs
   output [1:0] Op,
   output [5:0] Funct,
   output [3:0] Rd,
   output [3:0] Cond,
   output [3:0] ALUFlags,
	output [31:0] rd1_execute,
	output [31:0] rd2_execute,
	output [31:0] rd1,
	output [31:0] rd2,
	output [3:0] wa3e,
	output [3:0] wa3m,
	output [3:0] wa3w,

	// (for demonstration)
	output [31:0] inst_bus,
	output [31:0] result_wire,
	output wire [31:0] register0,
	output wire [31:0] register1,
	output wire [31:0] register2,
	output wire [31:0] register3,
	output wire [31:0] register4,
	output wire [31:0] register5,
	output wire [31:0] register6,
	output wire [31:0] register7,
	output wire [31:0] register8,
	output wire [31:0] register9,
	output wire [31:0] register10,
	output wire [31:0] register11,
	output wire [31:0] register12,
	output wire [31:0] register13,
	output wire [31:0] register14,
	output wire [31:0] register15,

	output wire [3:0] a1_mux_out,  // ra1d
	output wire [3:0] a2_mux_out  // ra2d
);

wire [31:0] pc_out, pc_adder_out, pc_mux_out, inst_mem_out, branch_taken_mux_out;

wire [31:0] extended_imm_out, extended_imm_out_execute;
reg [31:0] rotated_extended_imm_out;
wire [31:0] mem_out, mem_out_writeback, alu_out_writeback;
wire [31:0] alu_out, alu_srcb_mux_out, alu_out_memory;
wire alu_co, alu_ovf, alu_n, alu_z;
wire [31:0] forward_mux_a_out, forward_mux_b_out, forward_mux_b_out_memory;

reg [31:0] shifted_rd2;

wire zero_wire = 1'b0;

// fetch
Register_sync_rw PC_REG(clk, reset, !StallF, branch_taken_mux_out, pc_out);
Mux_2to1 PC_INPUT_MUX(PCSrcW, pc_adder_out, result_wire, pc_mux_out);
defparam PC_INPUT_MUX.WIDTH = 32;
Mux_2to1 BRANCH_TAKEN_MUX(BranchTakenE, pc_mux_out, alu_out, branch_taken_mux_out);
defparam BRANCH_TAKEN_MUX.WIDTH = 32;
Adder PC_ADDER(pc_out, 4, pc_adder_out);
Instruction_memory INST_MEM(pc_out, inst_mem_out);
Register_sync_rw FETCH_REG0(clk, FlushD || reset, !StallD, inst_mem_out, inst_bus);


// decode
Mux_2to1 A1_MUX(RegSrcD[0], inst_bus[19:16], 4'b1111, a1_mux_out);
Mux_2to1 A2_MUX(RegSrcD[1], inst_bus[3:0], inst_bus[15:12], a2_mux_out);
Register_file REG_FILE(clk, RegWriteW, reset, a1_mux_out, a2_mux_out, wa3w, result_wire, pc_adder_out, rd1, rd2, register0, register1, register2, register3, register4, register5, register6, register7, register8, register9, register10, register11, register12, register13, register14, register15);
better_extender EXTENDER(inst_bus[23:0], ImmSrcD, extended_imm_out);
Register_simple DECODE_REG0(clk, (FlushE || reset), rd1, rd1_execute);
Register_simple DECODE_REG1(clk, (FlushE || reset), shifted_rd2, rd2_execute);
Register_simple DECODE_REG2(clk, (FlushE || reset), inst_bus[15:12], wa3e);
defparam DECODE_REG2.WIDTH = 4;
Register_simple DECODE_REG3(clk, (FlushE || reset), rotated_extended_imm_out, extended_imm_out_execute);


// execute
Mux_4to1 FORWARD_MUX_A(ForwardAE, rd1_execute, result_wire, alu_out_memory, 0, forward_mux_a_out);
defparam FORWARD_MUX_A.WIDTH = 32;
Mux_4to1 FORWARD_MUX_B(ForwardBE, rd2_execute, result_wire, alu_out_memory, 0, forward_mux_b_out);
defparam FORWARD_MUX_B.WIDTH = 32;
ALU ALU_MODULE(ALUControlE, zero_wire, forward_mux_a_out, alu_srcb_mux_out, alu_out, alu_co, alu_ovf, alu_n, alu_z);
Mux_2to1 ALU_SRCB_MUX(ALUSrcE, forward_mux_b_out, extended_imm_out_execute, alu_srcb_mux_out);
defparam ALU_SRCB_MUX.WIDTH = 32;
Register_simple EXECUTE_REG0(clk, reset, alu_out, alu_out_memory);
Register_simple EXECUTE_REG1(clk, reset, forward_mux_b_out, forward_mux_b_out_memory);
Register_simple EXECUTE_REG2(clk, reset, wa3e, wa3m);
defparam EXECUTE_REG2.WIDTH = 4;


// memory
Memory MEMORY_MODULE(clk, MemWriteM, alu_out_memory, forward_mux_b_out_memory, mem_out);
Register_simple MEMORY_REG0(clk, reset, mem_out, mem_out_writeback);
Register_simple MEMORY_REG1(clk, reset, alu_out_memory, alu_out_writeback);
Register_simple MEMORY_REG2(clk, reset, wa3m, wa3w);
defparam MEMORY_REG2.WIDTH = 4;

// writeback
Mux_2to1 RESULT_MUX(MemtoRegW, alu_out_writeback, mem_out_writeback, result_wire);
defparam RESULT_MUX.WIDTH = 32;


// outputs
assign Op = inst_bus[27:26];
assign Funct = inst_bus[25:20];
assign Rd = inst_bus[15:12];
assign Cond = inst_bus[31:28];
assign ALUFlags = {alu_n, alu_z, alu_co, alu_ovf};


always @(*) begin
	if (rotate_immediate_enable) begin
		rotated_extended_imm_out = {extended_imm_out, extended_imm_out} >> (inst_bus[11:8] << 1);
	end
	else begin
		rotated_extended_imm_out = extended_imm_out;
	end

	if (shift_enable) begin
		case (inst_bus[6:5])  // sh
			2'b00: shifted_rd2 = rd2 			<<  inst_bus[11:7];  // lsl
			2'b01: shifted_rd2 = rd2 			>>  inst_bus[11:7];  // lsr
			2'b10: shifted_rd2 = rd2 			>>> inst_bus[11:7];  // asr
			2'b11: shifted_rd2 = {rd2, rd2}  >>  inst_bus[11:7];  // rr
		endcase
	end
	else begin
		shifted_rd2 = rd2;
	end
end
endmodule
