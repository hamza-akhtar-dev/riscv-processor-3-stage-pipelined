module mux4x1 (
    input logic [1:0] sel,
    input logic [31:0] in1, in2, in3, in4,
    output logic [31:0] out 
);
    
always_comb
begin
    case(sel)
        2'b00: out = in1;
        2'b01: out = in2;
        2'b10: out = in3;
        2'b11: out = in4;
    endcase
end

endmodule