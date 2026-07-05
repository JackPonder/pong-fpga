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

wire [$clog2(PIXEL_COUNT)-1:0] bgAddress;
wire bgPixel;

counter #(
    .MAX_COUNT(PIXEL_COUNT)
) counterBgAddress (
    .clk(clk),
    .clkEn(clkEn && active),
    .rst(rst),
    .count(bgAddress)
);

blockRom #(
    .DEPTH(PIXEL_COUNT),
    .WIDTH(1),
    .INIT_FILE("background.mem")
) backgroundData (
    .clk(clk),
    .clkEn(clkEn),
    .addr(bgAddress),
    .data(bgPixel)
);

localparam SCORE_WIDTH = 50;
localparam SCORE_HEIGHT = 60;
localparam DIGIT_PIXEL_COUNT = SCORE_WIDTH * SCORE_HEIGHT;

localparam SCORE_1_X_START = 255;
localparam SCORE_1_X_END = SCORE_1_X_START + SCORE_WIDTH;
localparam SCORE_1_Y_START = 125;
localparam SCORE_1_Y_END = SCORE_1_Y_START + SCORE_HEIGHT;

localparam SCORE_2_X_START = 335;
localparam SCORE_2_X_END = SCORE_2_X_START + SCORE_WIDTH;
localparam SCORE_2_Y_START = 125;
localparam SCORE_2_Y_END = SCORE_2_Y_START + SCORE_HEIGHT;

wire activeScores [0:1];
wire [$clog2(DIGIT_PIXEL_COUNT)-1:0] digitAddresses [0:1];

assign activeScores[0] = (SCORE_1_X_START <= x) && (x < SCORE_1_X_END) && (SCORE_1_Y_START <= y) && (y < SCORE_1_Y_END);
assign activeScores[1] = (SCORE_2_X_START <= x) && (x < SCORE_2_X_END) && (SCORE_2_Y_START <= y) && (y < SCORE_2_Y_END);

counter #(
    .MAX_COUNT(DIGIT_PIXEL_COUNT)
) counterDigitAddress0 (
    .clk(clk),
    .clkEn(clkEn && activeScores[0]),
    .rst(rst),
    .count(digitAddresses[0])
);

counter #(
    .MAX_COUNT(DIGIT_PIXEL_COUNT)
) counterDigitAddress1 (
    .clk(clk),
    .clkEn(clkEn && activeScores[1]),
    .rst(rst),
    .count(digitAddresses[1])
);

wire [$clog2(DIGIT_PIXEL_COUNT)-1:0] digitAddress = ( 
    activeScores[0] ? digitAddresses[0] : 
    activeScores[1] ? digitAddresses[1] : 0
);
wire [9:0] digitPixel;

blockRom #(
    .DEPTH(DIGIT_PIXEL_COUNT),
    .WIDTH(10),
    .INIT_FILE("digits.mem")
) digitsData (
    .clk(clk),
    .clkEn(clkEn),
    .addr(digitAddress),
    .data(digitPixel)
);

localparam fgColor = 12'hFFF;
localparam bgColor = 12'h000;

wire [11:0] colorOut = active ? (
    (activeScores[0] && digitPixel[score1]) || 
    (activeScores[1] && digitPixel[score2]) || 
    bgPixel ? fgColor : bgColor
) : 0;

assign {vgaRed, vgaGreen, vgaBlue} = colorOut;

endmodule