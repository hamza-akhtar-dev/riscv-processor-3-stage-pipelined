module uart
(
    input logic rst, clk, uart_sel, wr,
    input logic [7:0] data_in,
    input logic byte_ready_i, t_byte_i,
    output logic tx
);

logic load_xmt_dreg_o, load_xmt_shftreg_o, start_o, clear_o, clear_baud_o, shift_o, counter_baud_of_i, counter_of_i;

logic [7:0] data_to_uart;

assign data_to_uart = (uart_sel & wr) ? data_in : 8'h00;

uart_datapath uart_dp (rst, clk, data_to_uart, load_xmt_dreg_o, load_xmt_shftreg_o, start_o, clear_o, clear_baud_o, shift_o, counter_baud_of_i, counter_of_i, tx);

uart_controller uart_ctrl (rst, clk, byte_ready_i, counter_baud_of_i, counter_of_i, t_byte_i, load_xmt_dreg_o, load_xmt_shftreg_o, start_o, clear_o, clear_baud_o, shift_o);

endmodule