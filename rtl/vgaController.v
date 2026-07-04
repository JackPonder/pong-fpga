module vgaController
(
    input clk,
    input clkEn,
    input rst,

    output hSync,
    output vSync,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue
);

localparam WIDTH = 640;
localparam HEIGHT = 480; 

wire active;
wire [$clog2(WIDTH)-1:0] x;
wire [$clog2(HEIGHT)-1:0] y;

vgaTimingGenerator #(
    .WIDTH(WIDTH),
    .HEIGHT(HEIGHT)
) display (
    .clk(clk),
    .clkEn(clkEn),
    .rst(rst),
    .active(active),
    .hSync(hSync),
    .vSync(vSync),
    .x(x),
    .y(y)
);

wire [11:0] colorOut;
assign colorOut = active ? 12'h125 : 12'h000;

assign {vgaRed, vgaGreen, vgaBlue} = colorOut;

endmodule
