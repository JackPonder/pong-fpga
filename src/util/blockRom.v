module blockRom #(
    parameter DEPTH = 256,
    parameter WIDTH = 8,
    parameter INIT_FILE = ""
)(
    input clk,
    input clkEn,
    
    input [$clog2(DEPTH)-1:0] addr,
    output reg [WIDTH-1:0] data
);

reg [WIDTH-1:0] memory [0:DEPTH-1];
initial $readmemh(INIT_FILE, memory);

always @(posedge clk) begin
    if (clkEn) data = memory[addr];
end

endmodule