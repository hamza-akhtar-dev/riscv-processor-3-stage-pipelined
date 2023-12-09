module interrupt_encoder
(
    input logic timer_int,
    output logic [31:0] cause
);

always_comb
begin
    if(timer_int)
    begin
        cause = 32'h80000000;
    end
end

endmodule