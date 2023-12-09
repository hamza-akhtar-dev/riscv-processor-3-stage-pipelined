
module forwarding_unit
(
    input logic rf_wr, br_taken,
    input logic [4:0] rs1, rs2, rd,
    output logic fwd_op1, fwd_op2, flush
);

    logic rs1_valid, rs2_valid;

    assign rs1_valid = |rs1;
    assign rs2_valid = |rs2;

    assign fwd_op1 = ((rs1 == rd) & rf_wr) & rs1_valid;
    assign fwd_op2 = ((rs2 == rd) & rf_wr) & rs2_valid;

    assign flush = br_taken;

endmodule