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

localparam COLOR_COUNT = 2;

reg [11:0] colors [0:COLOR_COUNT-1];
initial $readmemh("colors.mem", colors);

reg [$clog2(COLOR_COUNT)-1:0] background [0:HEIGHT-1][0:WIDTH-1];
initial $readmemh("background.mem", background);

wire [$clog2(COLOR_COUNT)-1:0] colorNum;
assign colorNum = background[y][x];

wire [11:0] colorOut;
assign colorOut = active ? colors[colorNum] : 0;

assign {vgaRed, vgaGreen, vgaBlue} = colorOut;

endmodule