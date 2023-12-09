module reg_de_mw
(
    input logic rst, clk,
    input logic rf_wr_de,
    input logic csr_rf_wr_de, csr_rf_rd_de,
    input logic [1:0] wb_sel_de,
    input logic [4:0] mem_op_de,
    input logic [11:0] csr_addr_de,
    input logic [31:0] instruction_de, pc_de, alu_de, data_wr_de, csr_wdata_de,
    output logic rf_wr_mw,
    output logic csr_rf_wr_mw, csr_rf_rd_mw,
    output logic [1:0] wb_sel_mw,
    output logic [4:0] mem_op_mw,
    output logic [11:0] csr_addr_mw,
    output logic [31:0] instruction_mw, pc_mw, alu_mw, data_wr_mw, csr_wdata_mw
);

always_ff @(posedge clk) 
begin
    if(rst)
    begin
        instruction_mw <= 32'h00000013;
        rf_wr_mw <= 0;
        wb_sel_mw <= 0;
        mem_op_mw <= 0;
        pc_mw <= 0;
        alu_mw <= 0;
        data_wr_mw <= 0;
        csr_wdata_mw <= 0;
        csr_addr_mw <= 0;
        csr_rf_wr_mw <= 0;
        csr_rf_rd_mw <= 0;
    end
    else
    begin
        instruction_mw <= instruction_de;
        rf_wr_mw <= rf_wr_de;
        wb_sel_mw <= wb_sel_de;
        mem_op_mw <= mem_op_de;
        pc_mw <= pc_de;
        alu_mw <= alu_de;
        data_wr_mw <= data_wr_de;
        csr_wdata_mw <= csr_wdata_de; 
        csr_addr_mw <= csr_addr_de;
        csr_rf_wr_mw <= csr_rf_wr_de;
        csr_rf_rd_mw <= csr_rf_rd_de;
    end
end

endmodule