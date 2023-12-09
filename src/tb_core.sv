module tb_core ();

logic rst, clk;
logic timer_int;
logic [3:0] match, count;

//Clock Period = 10ns
localparam T = 10;

core riscv 
(
    .rst(rst), 
    .clk(clk),
    .timer_int(timer_int)
);

timer tim 
(
    .rst(rst),
    .clk(clk),
    .match(match),
    .timer_int(timer_int),
    .count(count)
);

initial
begin
    $readmemh("instructions.txt", riscv.dp.im.instruction_cache);
    $readmemh("registers.txt", riscv.dp.rf.register_file);
    $readmemh("datamemory.txt", riscv.dp.dm.data_cache);
end

//----Clock Generator----//
initial	
begin
    clk = 0;
    forever	#(T/2)	clk=~clk;
end

//---Starting Processor--//
initial
begin

	rst = 1;
	#(T);
	rst = 0;
    match = 9;    

    #1500;

    $writememh("instructions_out.txt", riscv.dp.im.instruction_cache);
    $writememh("registers_out.txt", riscv.dp.rf.register_file);
    $writememh("datamemory_out.txt", riscv.dp.dm.data_cache);

    $finish;
end

initial begin
    $dumpfile("tb_core.vcd");
    $dumpvars(0, tb_core);
end

endmodule