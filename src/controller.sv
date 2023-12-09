module controller
(
	input logic [2:0] funct3,
	input logic [6:0] funct7, opcode,
    output logic rf_wr, 
    output logic op1_sel, op2_sel, csr_rf_wr, csr_rf_rd, mret,
    output logic [1:0] wb_sel, 
    output logic [2:0] br_op,
	output logic [3:0] alu_op, 
    output logic [4:0] mem_op
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
localparam CSR    = 7'b1110011;

localparam ADD    = 4'b0000;
localparam SUB    = 4'b0001;
localparam SLL    = 4'b0010;
localparam SLT    = 4'b0011;
localparam SLTU   = 4'b0100;
localparam XOR    = 4'b0101;
localparam SRL    = 4'b0110;
localparam SRA    = 4'b0111;
localparam OR     = 4'b1000;
localparam AND    = 4'b1001;
localparam LUIOP   = 4'b1010;

localparam LBYTE        = 5'b00001;
localparam LHALFWORD    = 5'b00010;
localparam LWORD        = 5'b00011;
localparam LBYTEU       = 5'b00100;
localparam LHALFWORDU   = 5'b00101;
localparam SBYTE        = 5'b10110;
localparam SHALFWORD    = 5'b10111;
localparam SWORD        = 5'b11000;
localparam MEMOFF       = 5'b00000;

localparam NB = 3'b000;   
localparam BEQ = 3'b001;
localparam BNE = 3'b010;
localparam BLT = 3'b011;
localparam UC = 3'b100;

always_comb
begin
	case(opcode)

		R_TYPE:
		begin
            op1_sel = 1'b0;
            op2_sel = 1'b0;
			rf_wr  = 1'b1;
            csr_rf_wr  = 1'b0;
            csr_rf_rd  = 1'b0;
			wb_sel = 2'b0;
            mem_op = MEMOFF;
            br_op = NB;
            mret = 0;
			case(funct3)
                3'b000: 
                begin
                     case(funct7)
                         7'b0000000: alu_op = ADD;
                         7'b0100000: alu_op = SUB;
                     endcase
                end
                3'b001: alu_op = SLL;
                3'b010: alu_op = SLT; 
                3'b011: alu_op = SLTU;
                3'b100: alu_op = XOR;
                3'b101: 
                begin
                    case(funct7)
                        7'b0000000: alu_op = SRL;
                        7'b0100000: alu_op = SRA;
                    endcase
                end
                3'b110: alu_op = OR;
                3'b111: alu_op = AND;
            endcase
		end

        I_TYPE: 
		begin 
            op1_sel = 1'b0;
            op2_sel = 1'b1;
			rf_wr  = 1'b1;
            csr_rf_wr  = 1'b0;
            csr_rf_rd  = 1'b0;
			wb_sel = 2'd0;
            mem_op = MEMOFF;
            br_op = NB;
            mret = 0;
            case(funct3)
                3'b000: alu_op = ADD;
                3'b001: alu_op = SLL;
                3'b010: alu_op = SLT; 
                3'b011: alu_op = SLTU;
                3'b100: alu_op = XOR;
                3'b101: alu_op = SRL;
                3'b110: alu_op = OR;
                3'b111: alu_op = AND;
            endcase
		end

        LOAD: 
		begin  
            op1_sel = 1'b0;
            op2_sel = 1'b1;
			rf_wr  = 1'b1;
            csr_rf_wr  = 1'b0;
            csr_rf_rd  = 1'b0;
			wb_sel = 2'd1;
            alu_op = ADD;
            br_op = NB;
            mret = 0;
			case(funct3)
                3'b000: mem_op = LBYTE;
                3'b001: mem_op = LHALFWORD;
                3'b010: mem_op = LWORD;
                3'b100: mem_op = LBYTEU;
                3'b101: mem_op = LHALFWORDU;
            endcase
		end

        S_TYPE: 
		begin 
            op1_sel = 1'b0;
            op2_sel = 1'b1;
            rf_wr  = 1'b0;
            csr_rf_wr  = 1'b0;
            csr_rf_rd  = 1'b0;
            wb_sel = 2'd0;
            alu_op = ADD;
            br_op = NB;
            mret = 0;
			case(funct3)
                3'b000: mem_op = SBYTE;
                3'b001: mem_op = SHALFWORD;
                3'b010: mem_op = SWORD;
            endcase
		end

        B_TYPE: 
        begin 
            begin 
                op1_sel  = 1'd1;
                op2_sel  = 1'd1;
                rf_wr  = 1'd0;
                csr_rf_wr  = 1'b0;
                csr_rf_rd  = 1'b0;
                wb_sel = 2'd0;
                alu_op = ADD;
                mem_op = MEMOFF;
                mret = 0;
                case(funct3)
                    3'b000: br_op  = BEQ;
                    3'b001: br_op  = BNE;
                    3'b100: br_op  = BLT;
                endcase
		    end
        end

        J_TYPE: 
        begin 
           op1_sel  = 1'd1;
           op2_sel  = 1'd1;
           rf_wr  = 1'd1;
           csr_rf_wr  = 1'b0;
           csr_rf_rd  = 1'b0;
           wb_sel = 2'd2;
           mem_op = MEMOFF;
           alu_op = ADD;
           br_op = UC;
           mret = 0;
        end

        LUI: 
		begin 
           op1_sel  = 1'b0;
           op2_sel  = 1'b1;
           rf_wr = 1'b1;
           csr_rf_wr  = 1'b0;
           csr_rf_rd  = 1'b0;
           wb_sel = 2'd0;
           alu_op = LUIOP;
           mem_op = MEMOFF;
           br_op = NB;
           mret = 0;
		end

        AUIPC: 
		begin  
           op1_sel  = 1'b1;
           op2_sel  = 1'b1;
           rf_wr = 1'b1;
           csr_rf_wr  = 1'b0;
           csr_rf_rd  = 1'b0;
           wb_sel = 2'd0;
           alu_op = ADD;
           mem_op = MEMOFF;
           br_op = NB;
           mret = 0;
		end

        JALR: 
        begin 
           op1_sel  = 1'd0;
           op2_sel  = 1'd1;
           rf_wr = 1'b1;
           csr_rf_wr  = 1'b0;
           csr_rf_rd  = 1'b0;
           wb_sel = 2'd2;
           alu_op = ADD;
           mem_op = MEMOFF;
           br_op = UC;
           mret = 0;
        end

        CSR: 
        begin
            begin
                case(funct3)
                    3'b001:
                    begin
                        op1_sel  = 1'd0;
                        op2_sel  = 1'd1;
                        rf_wr = 1'b1;
                        csr_rf_wr  = 1'b1;
                        csr_rf_rd  = 1'b1;
                        wb_sel = 2'd3;
                        alu_op = ADD;
                        mem_op = MEMOFF;
                        br_op = NB;
                        mret = 0;
                    end
                    3'b000:
                    begin
                        op1_sel  = 1'd0;
                        op2_sel  = 1'd0;
                        rf_wr = 1'b0;
                        csr_rf_wr  = 1'b0;
                        csr_rf_rd  = 1'b0;
                        wb_sel = 2'd0;
                        alu_op = ADD;
                        mem_op = MEMOFF;
                        br_op = NB;
                        mret = 1;
                    end
                endcase
            end
        end
	endcase 
end

endmodule