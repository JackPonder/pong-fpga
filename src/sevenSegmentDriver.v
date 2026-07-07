module sevenSegmentDriver 
(
    input clk,
    input rst,

    output dp,
    output reg [6:0] seg,
    output reg [3:0] an
);

wire clkEn;
clkEnGenerator #(
    .DIVISOR(250_000)
) gen (
    .clk(clk),
    .clkEn(clkEn),
    .rst(rst)
);

reg [2:0] count;
always @(posedge clk)
    if (clkEn) count <= count + 1;

always @(*)
    case (count)
        0: begin an = 'b0111; seg = 'b0001100; end
        1: begin an = 'b1011; seg = 'b1000000; end
        2: begin an = 'b1101; seg = 'b1001000; end
        3: begin an = 'b1110; seg = 'b1000010; end
        default: begin an = 'b1111; seg = 'b1111111; end
    endcase

assign dp = 1;
    
endmodule