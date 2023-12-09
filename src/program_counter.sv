module program_counter
(
	input logic rst, clk,
	input logic [31:0] pc_in,
	output logic [31:0] pc_out
);

always_ff @(posedge rst or posedge clk)
begin
	if(rst)
		pc_out <= 0; // Reset to ZERO
	else
		pc_out <= pc_in;
end

endmodule