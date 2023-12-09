module load_store_unit 
(
	input logic clk,
    input logic [4:0] mem_op,
    input logic [31:0] cpu_addr, cpu_data_wr, dbus_data_rd,
    output logic [31:0] dbus_addr, cpu_data_rd, dbus_data_wr,
    output logic [3:0] mask,
    output logic dmem_sel, uart_sel, wr, t_byte_i, byte_ready_i
);

localparam LBYTE        = 5'b00001;
localparam LHALFWORD    = 5'b00010;
localparam LWORD        = 5'b00011;
localparam LBYTEU       = 5'b00100;
localparam LHALFWORDU   = 5'b00101;
localparam SBYTE        = 5'b10110;
localparam SHALFWORD    = 5'b10111;
localparam SWORD        = 5'b11000;
localparam MEMOFF       = 5'b00000;

logic [7:0] rdata_byte;
logic [15:0] rdata_hword;
logic [31:0] rdata_word;

always_comb 
begin

	rdata_byte = 8'd0;	
	rdata_hword = 16'd0;	
	rdata_word = 32'd0;

	case (mem_op)

		LBYTE, LBYTEU:
		begin
			case(cpu_addr[1:0])
				2'b00: 
				begin
					rdata_byte = dbus_data_rd[7:0];
				end
				2'b01: 
				begin
					rdata_byte = dbus_data_rd[15:8];
				end
				2'b10: 
				begin
					rdata_byte = dbus_data_rd[23:16];
				end
				2'b11: 
				begin
					rdata_byte = dbus_data_rd[31:24];
				end
			endcase
		end

		LHALFWORD, LHALFWORDU: 
		begin
			case(cpu_addr[1])
				1'b0: 
				begin
					rdata_hword = dbus_data_rd[15:0];
				end
				1'b1: 
				begin
					rdata_hword = dbus_data_rd[31:16];
				end
			endcase
		end

		LWORD: 
		begin
			rdata_word = dbus_data_rd;
		end

	endcase

end

always_comb
begin
	case(mem_op)
		LBYTE: cpu_data_rd = $signed(rdata_byte);
		LBYTEU: cpu_data_rd = $unsigned(rdata_byte);
		LHALFWORD: cpu_data_rd = $signed(rdata_hword);
		LHALFWORDU: cpu_data_rd = $unsigned(rdata_hword);
		LWORD: cpu_data_rd = rdata_word;
		default: cpu_data_rd = 32'd0;
	endcase
end

always_comb
begin
	dbus_data_wr = 32'd0;
	mask = 32'd0;
	case (mem_op)
		SBYTE: 
		begin
			case(cpu_addr[1:0])
				2'b00: 
				begin
					dbus_data_wr[7:0] = cpu_data_wr[7:0];
					mask = 4'b0001;
				end
				2'b01: 
				begin
					dbus_data_wr[15:8] = cpu_data_wr[15:8];
					mask = 4'b0010;
				end
				2'b10: 
				begin
					dbus_data_wr[23:16] = cpu_data_wr[23:16];
					mask = 4'b0100;
				end
				2'b11:
				begin
					dbus_data_wr[31:24] = cpu_data_wr[31:24];
					mask = 4'b1000;
				end
			endcase
		end
		SHALFWORD: 
		begin
			case(cpu_addr[1])
				1'b0: 
				begin
					dbus_data_wr[15:0] = cpu_data_wr[15:0];
					mask = 4'b0011;
				end
				1'b1: 
				begin
					dbus_data_wr[31:16] = cpu_data_wr[31:16];
					mask = 4'b1100;
				end
			endcase
		end
		SWORD: 
		begin
			dbus_data_wr = cpu_data_wr;
			mask = 4'b1111;
		end
		default:
		begin
			dbus_data_wr = 32'd0;
		end
	endcase
end

assign dbus_addr = cpu_addr;

always_comb
begin
	if(mem_op != MEMOFF)
	begin
		if(mem_op[4])
		begin
			wr = 1'b1;
		end
		else
		begin
			wr = 1'b0;
		end
	end
end
    
assign dmem_sel = (mem_op != MEMOFF) && (dbus_addr[31:28] == 4'h0);
assign uart_sel = (mem_op != MEMOFF) && (dbus_addr[31:28] == 4'h8);

always_ff@(posedge clk)
begin
	if(uart_sel)
	begin
		byte_ready_i <= 1'b1;
		if(byte_ready_i)
		begin
			t_byte_i <= 1'b1;
		end
		else
		begin
			t_byte_i <= 1'b0;
		end
	end
	else 
	begin
		byte_ready_i <= 1'b0;
	end
end

endmodule