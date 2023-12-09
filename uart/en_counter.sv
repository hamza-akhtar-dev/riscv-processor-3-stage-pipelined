module en_counter
(
    input logic rst, clk, enable,
    output logic[31:0] count
);

always_ff@(posedge clk)
begin 
    if(rst)
    begin
        count <= 0;
    end
    else if (enable)
    begin
        count <= count + 1'b1;
    end
end 

endmodule
