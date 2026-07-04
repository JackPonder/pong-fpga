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

localparam PIXEL_COUNT = WIDTH * HEIGHT;
localparam COLOR_COUNT = 2;
localparam BITS_PER_COLOR = 12;

wire [$clog2(PIXEL_COUNT)-1:0] pixelAddr;
wire [$clog2(COLOR_COUNT)-1:0] colorAddr;
wire [BITS_PER_COLOR-1:0] colorData;

assign pixelAddr = x + WIDTH * y;

rom #(
    .DEPTH(PIXEL_COUNT),
    .WIDTH($clog2(COLOR_COUNT)),
    .INIT_FILE("background.mem")
) background (
    .addr(pixelAddr),
    .data(colorAddr)
);

rom #(
    .DEPTH(COLOR_COUNT),
    .WIDTH(BITS_PER_COLOR),
    .INIT_FILE("colors.mem")
) colors (
    .addr(colorAddr),
    .data(colorData)
);

wire [11:0] colorOut;
assign colorOut = active ? colorData : 0;

assign {vgaRed, vgaGreen, vgaBlue} = colorOut;

endmodule