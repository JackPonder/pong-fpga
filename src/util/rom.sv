module rom #(
    parameter InitFile = "",
    parameter DataWidth = 50,
    parameter Depth = 60,

    localparam AddrWidth = $clog2(Depth)
) (
    input  logic clk,

    // Read interface
    input  logic [AddrWidth-1:0] addr, 
    output logic [DataWidth-1:0] dout
);

// 2D memory array for image data
logic [DataWidth-1:0] rom[Depth];

// Initialize ROM
initial begin
    $readmemb(InitFile, rom);
end

// Synchronous read from memory
always_ff @(posedge clk) begin
    dout = rom[addr];
end

endmodule