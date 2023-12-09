module instruction_decoder
(
	input [31:0] instruction, 
	output logic [2:0] funct3,
	output logic [4:0] rs1, rs2, rd,
	output logic [6:0] funct7, opcode,
	output logic [31:0] imm
);

localparam R_TYPE = 7'b0110011;
localparam I_TYPE = 7'b0010011;
localparam S_TYPE = 7'b0100011;
localparam B_TYPE = 7'b1100011;
localparam J_TYPE = 7'b1101111;
localparam LOAD   = 7'b0000011;
localparam JALR   = 7'b1100111;
localparam LUI    = 7'b0110111;
localparam AUIPC  = 7'b0010111;
localparam CSRRW  = 7'b1110011;

assign opcode = instruction[6:0];

always_comb
begin
	case(opcode)
		R_TYPE: 
		begin 
		    funct3 = instruction[14:12];
		    funct7 = instruction[31:25];
		    rs1 = instruction[19:15];
		    rs2 = instruction[24:20];
		    rd = instruction[11:7];
		end
		
		I_TYPE, LOAD, JALR: 
		begin 
			funct3 = instruction[14:12];
            rs1 = instruction[19:15];
            rd = instruction[11:7];
            imm = $signed(instruction[31:20]);
		end
		
		S_TYPE: 
		begin 
			funct3 = instruction[14:12];
            rs1 = instruction[19:15];
            rs2 = instruction[24:20];
            imm = $signed({instruction[31:25], instruction[11:7]});
		end

		B_TYPE: 
		begin 
			funct3 = instruction[14:12];
            rs1 = instruction[19:15];
            rs2 = instruction[24:20];
            imm = $signed({instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0});
		end

		J_TYPE: 
		begin 
			rd = instruction[11:7];
            imm = $signed({instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0});
		end
		
		LUI, AUIPC: 
		begin 
			rd = instruction[11:7];
			imm = {instruction[31:12], 12'b0};
		end

		CSRRW:
		begin
			funct3 = instruction[14:12];
            rs1 = instruction[19:15];
            rd = instruction[11:7];
            imm = instruction[31:20];
		end
		
		default:
		begin
		      funct3 = 3'd0;
		      funct7 = 7'd0;
		      rs1 = 5'd0;
		      rs2 = 5'd0;
		      rd = 5'd0;
		      imm = 32'd0;
		end
	endcase 
end

endmodule


/*
addi x5 x0 4	
lb x6 0(x5)
lh x7 0(x5)	
lw x8 0(x5)	
lbu x9 0(x5)	
lhu x10 0(x5)	
addi x5 x0 8	
lui x11 720309	
addi x11 x11 998	
sb x11 0(x5)	
sh x11 4(x5)	
sw x11 8(x5)	
auipc x12 1	
addi x20 x0 2	
addi x21 x0 10	
slti x22 x21 -5	
sltiu x22 x21 -5	
xori x22 x21 5	
ori x22 x21 5	
andi x22 x21 5	
slli x22 x21 5	
srli x22 x21 5	
srai x22 x21 5	
add x22 x21 x20	
sub x22 x21 x20	
sll x22 x21 x20	
slt x22 x21 x20	
sltu x22 x21 x20	
xor x22 x21 x20	
srl x22 x21 x20	
sra x22 x21 x20	
or x22 x21 x20	
and x22 x21 x20	
*/