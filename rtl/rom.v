module rom 
#(
    parameter DEPTH = 256,
    parameter WIDTH = 8,
    parameter INIT_FILE = ""
)(
    input [$clog2(DEPTH)-1:0] addr,
    output [WIDTH-1:0] data
);

// Distributed ROM
reg [WIDTH-1:0] memory [0:DEPTH-1];

// Initialize memory from file
initial $readmemh(INIT_FILE, memory);

// Output data at input address
assign data = memory[addr];

endmodule