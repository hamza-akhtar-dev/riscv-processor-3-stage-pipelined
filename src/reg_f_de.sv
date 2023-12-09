module reg_f_de
(
    input logic rst, clk, enable,
    input logic [31:0] instruction_f, pc_f,
    output logic [31:0] instruction_de, pc_de
);

always_ff @(posedge clk) 
begin
    if(rst)
    begin
        instruction_de <= 32'h00000013;
        pc_de <= 0;
    end
    else if(enable)
    begin
        instruction_de <= instruction_f;
        pc_de <= pc_f;
    end
end

endmodule