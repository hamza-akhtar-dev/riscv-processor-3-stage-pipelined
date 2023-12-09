module instruction_cache
(
    input logic [31:0] addr,
    output logic [31:0] instruction
);  

    reg [31:0] instruction_cache [1023:0];

    assign instruction = instruction_cache[addr[31:2]];

endmodule