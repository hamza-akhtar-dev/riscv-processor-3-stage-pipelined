module datapath
(
    input logic rst, clk, op1_sel, op2_sel, timer_int,
    input logic rf_wr_de, csr_rf_wr, csr_rf_rd, mret,
    input logic [1:0] wb_sel_de, 
    input logic [2:0] br_op,
    input logic [3:0] alu_op, 
    input logic [4:0] mem_op_de,
    output logic [2:0] funct3, 
    output logic [6:0] funct7, opcode
);


logic [31:0] pc_f, pc_de, pc_mw, pc_x, pc_xx, instruction_f, instruction_de, instruction_mw, result_de, result_mw, result_x, operand1, operand1_x, operand2_de, operand2_mw, operand2_x, imm, addr, cpu_data_rd, dbus_data_rd, dbus_data_wr, forwarded_op1, forwarded_op2, csr_wdata_mw, csr_rdata, evec, cause;
logic[11:0] csr_addr_mw;
logic [4:0] rs1, rs2, rd_de, mem_op_mw;
logic [3:0] mask;
logic [1:0] wb_sel_mw;
logic cs, wr, csr_flush, stall, fwd_op1, fwd_op2, tx;

interrupt_encoder enc
(
    .timer_int(timer_int),
    .cause(cause)
);

mux2x1 mx1 
(
    .sel(br_taken),
    .in1(pc_f + 32'd4), 
    .in2(result_de),
    .out(pc_x)
);

mux2x1 mx7
(
    .sel(epc_taken),
    .in1(pc_x),
    .in2(evec),
    .out(pc_xx)
);

program_counter pcnt
(
    .rst(rst), 
    .clk(clk), 
    .pc_in(pc_xx),
    .pc_out(pc_f)
);

instruction_cache im 
(
    .addr(pc_f), 
    .instruction(instruction_f)
);

reg_f_de f_de 
(
    .rst(rst|csr_flush|flush), 
    .clk(clk), 
    .enable(~stall),
    .instruction_f(instruction_f),
    .pc_f(pc_f),
    .instruction_de(instruction_de), 
    .pc_de(pc_de)
);

hazard_detection_unit hzu
(
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd_de),
    .opcode(instruction_f[6:0]),
    .stall(stall)
);

instruction_decoder id 
(
    .instruction(instruction_de), 
    .funct3(funct3), 
    .rs1(rs1), 
    .rs2(rs2), 
    .rd(rd_de), 
    .funct7(funct7),
    .opcode(opcode), 
    .imm(imm)
);

register_file rf 
(
    .clk(clk),
    .rf_wr(rf_wr_mw),
    .rs1(rs1) , 
    .rs2(rs2), 
    .rd(instruction_mw[11:7]), 
    .wdata(result_x), 
    .rdata1(operand1), 
    .rdata2(operand2_de)
);

mux2x1 mx5
(
    .sel(fwd_op1), 
    .in1(operand1), 
    .in2(result_mw), 
    .out(forwarded_op1)
);

mux2x1 mx6
(
    .sel(fwd_op2), 
    .in1(operand2_de), 
    .in2(result_mw), 
    .out(forwarded_op2)
);

branch_condition bc 
(
    .br_op(br_op), 
    .operand1(forwarded_op1), 
    .operand2(forwarded_op2), 
    .br_taken(br_taken)
);

mux2x1 mx2 
(
    .sel(op1_sel), 
    .in1(forwarded_op1), 
    .in2(pc_de), 
    .out(operand1_x)
);

mux2x1 mx3 
(
    .sel(op2_sel), 
    .in1(forwarded_op2), 
    .in2(imm), 
    .out(operand2_x)
);

alu au 
(
    .alu_op(alu_op), 
    .operand1(operand1_x), 
    .operand2(operand2_x),
    .result(result_de)
);

reg_de_mw de_mw 
(
    .rst(rst|csr_flush), 
    .clk(clk),
    .rf_wr_de(rf_wr_de),
    .wb_sel_de(wb_sel_de), 
    .mem_op_de(mem_op_de),
    .csr_rf_rd_de(csr_rf_rd),
    .csr_rf_wr_de(csr_rf_wr),
    .data_wr_de(operand2_de), 
    .alu_de(result_de), 
    .csr_addr_de(imm[11:0]),
    .csr_wdata_de(forwarded_op1),
    .pc_de(pc_de), 
    .instruction_de(instruction_de),
    .rf_wr_mw(rf_wr_mw),
    .wb_sel_mw(wb_sel_mw), 
    .mem_op_mw(mem_op_mw),
    .csr_rf_rd_mw(csr_rf_rd_mw),
    .data_wr_mw(operand2_mw),
    .alu_mw(result_mw), 
    .csr_rf_wr_mw(csr_rf_wr_mw),
    .csr_addr_mw(csr_addr_mw),
    .csr_wdata_mw(csr_wdata_mw),
    .pc_mw(pc_mw), 
    .instruction_mw(instruction_mw)
);

forwarding_unit fwd
(
   .rf_wr(rf_wr_mw),
   .br_taken(br_taken),
   .rs1(rs1),
   .rs2(rs2),
   .rd(instruction_mw[11:7]),
   .fwd_op1(fwd_op1),
   .fwd_op2(fwd_op2),
   .flush(flush)
);

csr_register_file csr_rf
(
    .clk(clk),
    .rst(rst),
    .mret(mret),
    .csr_reg_wr(csr_rf_wr_mw),
    .csr_reg_rd(csr_rf_rd_mw),
    .csr_addr(csr_addr_mw),
    .pc(pc_f),
    .csr_wdata(csr_wdata_mw),
    .csr_rdata(csr_rdata),
    .cause(cause),
    .evec(evec),
    .epc_taken(epc_taken),
    .csr_flush(csr_flush)
);

load_store_unit lsu 
(
    .clk(clk),
    .mem_op(mem_op_mw), 
    .cpu_addr(result_mw), 
    .cpu_data_wr(operand2_mw), 
    .cpu_data_rd(cpu_data_rd),
    .dbus_addr(addr),
    .dbus_data_wr(dbus_data_wr),
    .dbus_data_rd(dbus_data_rd), 
    .mask(mask),
    .dmem_sel(dmem_sel),
    .uart_sel(uart_sel),
    .wr(wr),
    .t_byte_i(t_byte_i),
    .byte_ready_i(byte_ready_i)
);

uart uart_tx
(
    .rst(rst),
    .clk(clk),
    .uart_sel(uart_sel),
    .t_byte_i(t_byte_i),
    .byte_ready_i(byte_ready_i),
    .wr(wr),
    .data_in(dbus_data_wr[7:0]),
    .tx(tx)
);

data_cache dm 
(
    .rst(rst), 
    .clk(clk), 
    .dmem_sel(dmem_sel), 
    .wr(wr), 
    .mask(mask), 
    .addr(addr),
    .dmem_data_wr(dbus_data_wr),
    .dmem_data_rd(dbus_data_rd)
);

mux4x1 mx4 
(
    .sel(wb_sel_mw), 
    .in1(result_mw), 
    .in2(cpu_data_rd), 
    .in3(pc_mw + 32'd4), 
    .in4(csr_rdata), 
    .out(result_x)
);

endmodule