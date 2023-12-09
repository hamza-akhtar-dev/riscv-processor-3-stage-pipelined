module comparator
(
    input logic [31:0] op1, op2,
    output logic eq
);

    assign eq = (op1 == op2);

endmodule