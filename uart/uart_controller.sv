module uart_controller
(
	input logic  reset_i, clk_i, byte_ready_i, counter_baud_of_i, counter_of_i, t_byte_i,                
	output logic load_xmt_dreg_o, load_xmt_shftreg_o, start_o, clear_o, clear_baud_o, shift_o
);
	
	localparam S0 = 2'b00;
	localparam S1 = 2'b01;
	localparam S2 = 2'b10;
	
	logic [1:0] cs, ns;
	
	always_ff@(posedge clk_i) 
	begin
		if(reset_i) 
		begin	
			cs<= S0;
		end 
		else 
		begin
			cs <= ns;
		end
	end
	
	//Next State logic
	always_comb 
	begin	
		case(cs)

			S0: 
			begin	
				if (!byte_ready_i) 
				begin
					ns = S0; 
				end

				else 
				begin
					ns = S1; 
				end
			end

			S1: 
			begin
				if (!t_byte_i) ns= S1;
				else ns = S2;
			end

			S2: 
			begin
				if({counter_of_i, counter_baud_of_i} == 2'b11) 
				begin
					ns = S0; 
				end
				else 
				begin
					ns = S2; 
				end
			end

			default: ns = S0;

		endcase
	end
	
	// Output Logic
	always_comb 
	begin
		load_xmt_dreg_o = 0;
		load_xmt_shftreg_o = 0;
		start_o = 0;
		clear_o = 0;
		clear_baud_o = 0;
		shift_o = 0;

		case(cs)
			S0: 
			begin
				if (!byte_ready_i) 
				begin
					clear_baud_o = 1;
					clear_o = 1;
					load_xmt_dreg_o = 1;
				end

				else 
				begin
					clear_baud_o = 1;
					clear_o = 1;
				end
			end

			S1:
			begin
				clear_baud_o = 1;
				clear_o = 1;
				load_xmt_shftreg_o = 1;
			end

			S2: 
			begin
				if ({counter_of_i, counter_baud_of_i}==2'b10) 
				begin
					start_o = 1; 
				end
				
				else if ({counter_of_i, counter_baud_of_i}==2'b00) 
				begin
					start_o = 1; 
				end

				else if ({counter_of_i, counter_baud_of_i}==2'b01) 
				begin
					start_o = 1; 
					shift_o = 1;
					clear_baud_o = 1;
				end

				else if ({counter_of_i, counter_baud_of_i}==2'b11) 
				begin
					start_o = 0;
				end
			end
		endcase				
	end
endmodule	