module core
(
    input logic rst, clk, 
    input logic timer_int
);

logic op1_sel, op2_sel, rf_wr, csr_rf_rd, csr_rf_wr, mret;
logic [1:0] wb_sel;
logic [2:0] br_op;
logic [3:0] alu_op; 
logic [4:0] mem_op;
logic [2:0] funct3;
logic [6:0] opcode, funct7;

controller ctrl 
(
    .funct3(funct3), 
    .funct7(funct7), 
    .opcode(opcode), 
    .op1_sel(op1_sel), 
    .op2_sel(op2_sel),
    .csr_rf_rd(csr_rf_rd),
    .csr_rf_wr(csr_rf_wr),
    .wb_sel(wb_sel), 
    .rf_wr(rf_wr),
    .br_op(br_op), 
    .alu_op(alu_op), 
    .mem_op(mem_op),
    .mret(mret)
);

datapath dp 
(
    .rst(rst), 
    .clk(clk),
    .timer_int(timer_int), 
    .op1_sel(op1_sel), 
    .op2_sel(op2_sel),
    .csr_rf_rd(csr_rf_rd),
    .csr_rf_wr(csr_rf_wr),
    .wb_sel_de(wb_sel), 
    .rf_wr_de(rf_wr), 
    .br_op(br_op), 
    .alu_op(alu_op), 
    .mem_op_de(mem_op),
    .funct3(funct3), 
    .funct7(funct7), 
    .opcode(opcode),
    .mret(mret)
);



endmodule
