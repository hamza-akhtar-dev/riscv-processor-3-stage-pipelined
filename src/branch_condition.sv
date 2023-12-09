module branch_condition
(
    input   logic [2:0] br_op,
    input   logic [31:0] operand1, operand2,
    output  logic br_taken
);
 
localparam NB = 3'b000;   
localparam BEQ = 3'b001;
localparam BNE = 3'b010;
localparam BLT = 3'b011;
localparam UC = 3'b100;

always_comb
begin
    br_taken = 1'b0;
    case(br_op)
        BEQ: 
        begin
            if($signed(operand1) == $signed(operand2))
            begin
                br_taken = 1'b1;
            end
        end
        BNE: 
        begin
            if($signed(operand1) != $signed(operand2))
            begin
                br_taken = 1'b1;
            end
        end
        BLT: 
        begin
            if($signed(operand1) < $signed(operand2))
            begin
                br_taken = 1'b1;
            end
        end
        UC: 
        begin
            br_taken = 1'b1;
        end
        NB: 
        begin
            br_taken = 1'b0;
        end
    endcase
end
endmodule