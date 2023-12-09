module data_cache
(
	input logic rst, clk, dmem_sel, wr,
	input logic [3:0] mask,
	input logic [31:0] addr, dmem_data_wr,
	output logic [31:0] dmem_data_rd
);

reg [31:0] data_cache [63:0];

assign dmem_data_rd = (dmem_sel & ~wr) ? data_cache[addr[31:2]] : 32'd0;

always_ff @(negedge clk) 
begin
	if(dmem_sel && wr)
	begin
		if(mask[0])
		begin
			data_cache[addr[31:2]][7:0] = dmem_data_wr[7:0];
		end
		if(mask[1])
		begin
			data_cache[addr[31:2]][15:8] = dmem_data_wr[15:8];
		end 
		if(mask[2])
		begin
			data_cache[addr[31:2]][23:16] = dmem_data_wr[23:16];
		end 
		if(mask[3])
		begin
			data_cache[addr[31:2]][31:24] = dmem_data_wr[31:24];
		end 
	end
end

endmodule