
module csr_register_file
(
    input logic clk, rst,
    input logic mret,
    input logic csr_reg_wr,
    input logic csr_reg_rd,
    input logic [11:0] csr_addr,
    input logic [31:0] cause,
    input logic [31:0] pc,
    input logic [31:0] csr_wdata,
    output logic csr_flush, epc_taken,
    output logic [31:0] csr_rdata,
    output logic [31:0] evec
);

localparam MSTATUS  = 12'h300;
localparam MIE      = 12'h304;
localparam MTVEC    = 12'h305;
localparam MEPC     = 12'h341;
localparam MCAUSE   = 12'h342;
localparam MIP      = 12'h344;

reg [31:0] mip;
reg [31:0] mie;
reg [31:0] mstatus;
reg [31:0] mcause;
reg [31:0] mtvec;
reg [31:0] mepc;

assign mip = cause[31] ? 32'h00000080 : 32'h00000000;

always_comb 
begin

    if(csr_reg_rd) 
    begin
        case (csr_addr)
            MIP     : csr_rdata = mip;
            MIE     : csr_rdata = mie;
            MSTATUS : csr_rdata = mstatus;
            MCAUSE  : csr_rdata = mcause;
            MTVEC   : csr_rdata = mtvec;
            MEPC    : csr_rdata = mepc;
            default : csr_rdata = '0;
        endcase
    end
    else
    begin
        csr_rdata = '0;
    end

end

always_ff @(posedge clk)
begin
    if(rst)
    begin
        mie     <= '0;
        mstatus <= '0;
        mcause  <= '0;
        mtvec   <= '0;
        mepc    <= '0;
    end
    else if (csr_reg_wr)
    begin
        case (csr_addr)
            MIE     : mie     <= csr_wdata;
            MSTATUS : mstatus <= csr_wdata;
            MCAUSE  : mcause  <= csr_wdata;
            MTVEC   : mtvec   <= csr_wdata;
            MEPC    : mepc    <= csr_wdata;
        endcase
    end 
    if(mstatus[3] && (mip[7] && mie[7]))
    begin
        mepc   <= pc;
        evec   <= mtvec;
        epc_taken <= 1;
        mie    <= 0;
        mcause <= cause;
        csr_flush  <= 1'b1;
    end
    else if (mret)
    begin
        evec <= mepc;
        epc_taken <= 1;
        mcause <= 0;
        csr_flush  <= 1'b0;
    end
    else
    begin
        epc_taken <= 0;
        csr_flush  <= 1'b0;
    end
end

endmodule