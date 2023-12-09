module uart_datapath
(
    input logic reset_i, clk_i,
    input logic [7:0] data_in,
    input logic load_xmt_dreg_o, load_xmt_shftreg_o, start_o, clear_o, clear_baud_o, shift_o, 
    output logic counter_baud_of_i, counter_of_i, tx
);

logic [31:0] bit_count, baud_count;

logic [7:0] dreg;

always_ff@(posedge clk_i)
begin
    if(reset_i)
    begin
        dreg <= 0;
    end
    else if(load_xmt_dreg_o)
    begin
        dreg <= data_in;
    end
end

shift_register shft (clk_i, load_xmt_shftreg_o, shift_o, reset_i, dreg, serial_out_o);

bit_mux2x1 mx1 (start_o, 1'b1, serial_out_o, tx);

counter baudcount (clear_baud_o, clk_i, baud_count);

comparator baudcmp (baud_count, 32'd5, counter_baud_of_i);

en_counter bitcount (clear_o, clk_i, counter_baud_of_i, bit_count);

comparator bitcmp (bit_count, 32'd8, counter_of_i);

endmodule