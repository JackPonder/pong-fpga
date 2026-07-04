module vgaController
(
    input clk,
    input clkEn,
    input rst,

    input [3:0] score1,
    input [3:0] score2,

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

localparam SCORE_WIDTH = 50;
localparam SCORE_HEIGHT = 60;

localparam SCORE_1_X_START = 255;
localparam SCORE_1_X_END = SCORE_1_X_START + SCORE_WIDTH;
localparam SCORE_1_Y_START = 125;
localparam SCORE_1_Y_END = SCORE_1_Y_START + SCORE_HEIGHT;

localparam SCORE_2_X_START = 335;
localparam SCORE_2_X_END = SCORE_2_X_START + SCORE_WIDTH;
localparam SCORE_2_Y_START = 125;
localparam SCORE_2_Y_END = SCORE_2_Y_START + SCORE_HEIGHT;

wire activeScore1, activeScore2;
assign activeScore1 = (SCORE_1_X_START <= x) && (x < SCORE_1_X_END) && (SCORE_1_Y_START <= y) && (y < SCORE_1_Y_END);
assign activeScore2 = (SCORE_2_X_START <= x) && (x < SCORE_2_X_END) && (SCORE_2_Y_START <= y) && (y < SCORE_2_Y_END);

localparam DIGIT_PIXEL_COUNT = SCORE_WIDTH * SCORE_HEIGHT;
localparam DIGITS_PIXEL_COUNT = DIGIT_PIXEL_COUNT * 10;

wire [$clog2(DIGITS_PIXEL_COUNT)-1:0] numberAddr;
wire numberPixel;

assign numberAddr = ( 
    activeScore1 ? (
        (x - SCORE_1_X_START) + (SCORE_WIDTH * (y - SCORE_1_Y_START)) + (DIGIT_PIXEL_COUNT * score1)
    ) : activeScore2 ? (
        (x - SCORE_2_X_START) + (SCORE_WIDTH * (y - SCORE_2_Y_START)) + (DIGIT_PIXEL_COUNT * score2)
    ) : 0
);

blockRom #(
    .DEPTH(DIGITS_PIXEL_COUNT),
    .WIDTH(1),
    .INIT_FILE("digits.mem")
) numbersData (
    .clk(clk),
    .clkEn(clkEn),
    .addr(numberAddr),
    .data(numberPixel)
);

wire [11:0] colorOut;
assign colorOut = active ? (
    activeScore1 ? (numberPixel ? 12'hFFF : 0) :
    activeScore2 ? (numberPixel ? 12'hFFF : 0) :
    bgPixel ? 12'hFFF : 0 
) : 0;

assign {vgaRed, vgaGreen, vgaBlue} = colorOut;

endmodule