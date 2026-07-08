module sevenSegmentDriver (
    input clk,
    input rst,

    output dp,
    output reg [6:0] seg,
    output reg [3:0] an
);

// Run display at 1 kHz
wire clkEn;
clkEnGenerator #(
    .DIVISOR(100_000)
) gen (
    .clk(clk),
    .clkEn(clkEn),
    .rst(rst)
);

// Move to next digit on each clock edge
reg [2:0] count = 0;
always @(posedge clk) begin
    if (rst) 
        count <= 0;
    else if (clkEn) 
        count <= count + 1;
end

// Output PONG on the display
always @(*) begin
    case (count)
        0: begin an = 'b0111; seg = 'b0001100; end
        1: begin an = 'b1011; seg = 'b1000000; end
        2: begin an = 'b1101; seg = 'b1001000; end
        3: begin an = 'b1110; seg = 'b1000010; end
        default: begin an = 'b1111; seg = 'b1111111; end
    endcase
end

assign dp = 1;
    
endmodule