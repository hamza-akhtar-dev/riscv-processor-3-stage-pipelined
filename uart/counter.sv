module counter
(
    input logic rst, clk,
    output logic[31:0] count
);

always_ff@(posedge clk)
begin 
    if(rst)
    begin
        count <= 0;
    end
    else 
    begin
        count <= count + 1'b1;
    end
end 

endmodule
