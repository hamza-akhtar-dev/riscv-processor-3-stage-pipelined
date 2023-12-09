module alu
(
    input logic [3:0] alu_op,
    input logic [31:0] operand1, operand2,
    output logic [31:0] result
);

localparam ADD  = 4'b0000;
localparam SUB  = 4'b0001;
localparam SLL   = 4'b0010;
localparam SLT  = 4'b0011;
localparam SLTU  = 4'b0100;
localparam XOR  = 4'b0101;
localparam SRL = 4'b0110;
localparam SRA  = 4'b0111;
localparam OR  = 4'b1000;
localparam AND  = 4'b1001;
localparam LUIOP  = 4'b1010;

always_comb 
begin
    case(alu_op)
        ADD : result = operand1 + operand2; //ADD
        SUB : result = operand1 - operand2; //SUBTRACT
        OR  : result = operand1 | operand2; //OR
        AND : result = operand1 & operand2; //AND
        XOR : result = operand1 ^ operand2; //XOR
        SLL : result = operand1 << operand2; //SLL
        SRL : result = operand1 >> operand2; //SRL
        SRA : result = operand1 >>> operand2; //SRA
        SLT : result = ($signed(operand1) < $signed(operand2)) ? 32'd1 : 32'd0; //SLT
        SLTU : result = (operand1 < operand2) ? 32'd1 : 32'd0; //SLTU
        LUIOP : result = operand2;
        default: result = 32'd0;
	endcase
end

endmodule