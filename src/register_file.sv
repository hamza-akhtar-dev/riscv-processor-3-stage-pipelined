module register_file
(
	input logic clk, rf_wr,
	input logic [4:0] rs1, rs2, rd,
	input logic [31:0] wdata,
	output logic [31:0] rdata1, rdata2
);

reg [31:0] register_file [31:0];

//Synchronous Write
always_ff @(negedge clk)
begin
	if(rf_wr)
    	register_file[rd] <= (|rd) ? wdata : 32'd0;
end  

//Asynchronuous Read
always_comb
begin
	rdata1 = (|rs1) ? register_file[rs1] : 32'd0;
	rdata2 = (|rs2) ? register_file[rs2] : 32'd0;
end
  
endmodule