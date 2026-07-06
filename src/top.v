module top
(
    input clk,
    input [15:0] sw,

    output [15:0] led,
    output [3:0] vgaRed, 
    output [3:0] vgaGreen, 
    output [3:0] vgaBlue,
    output hSync, 
    output vSync
);

wire rst;
assign rst = 0;

wire clkEn;
clkEnGenerator #(
    .DIVISOR(4)
) gen (
    .clk(clk),
    .clkEn(clkEn),
    .rst(rst)
);

vgaController controller (
    .clk(clk),
    .clkEn(clkEn),
    .rst(rst),
    .score1(sw[15:12]),
    .score2(sw[3:0]),
    .hSync(hSync),
    .vSync(vSync),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue)
);

assign led = sw;

endmodule