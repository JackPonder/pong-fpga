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
) timingGen (
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

wire [$clog2(PIXEL_COUNT)-1:0] pixelAddr;
wire bgPixel;

assign pixelAddr = x + WIDTH * y;

blockRom #(
    .DEPTH(PIXEL_COUNT),
    .WIDTH(1),
    .INIT_FILE("background.mem")
) backgroundData (
    .clk(clk),
    .clkEn(clkEn),
    .addr(pixelAddr),
    .data(bgPixel)
);

localparam SCORE_1_X_START = 255;
localparam SCORE_1_X_END = SCORE_1_X_START + 50;
localparam SCORE_1_Y_START = 125;
localparam SCORE_1_Y_END = SCORE_1_Y_START + 60;

localparam SCORE_2_X_START = 335;
localparam SCORE_2_X_END = SCORE_2_X_START + 50;
localparam SCORE_2_Y_START = 125;
localparam SCORE_2_Y_END = SCORE_2_Y_START + 60;

wire activeScore1, activeScore2;
assign activeScore1 = (SCORE_1_X_START <= x) && (x < SCORE_1_X_END) && (SCORE_1_Y_START <= y) && (y < SCORE_1_Y_END);
assign activeScore2 = (SCORE_2_X_START <= x) && (x < SCORE_2_X_END) && (SCORE_2_Y_START <= y) && (y < SCORE_2_Y_END);

wire [11:0] colorOut;
assign colorOut = active ? (
    activeScore1 ? 12'hF00 :
    activeScore2 ? 12'h0FF :
    bgPixel ? 12'hFFF : 0 
) : 0;

assign {vgaRed, vgaGreen, vgaBlue} = colorOut;

endmodule