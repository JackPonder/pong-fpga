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

localparam SCREEN_WIDTH = 640;
localparam SCREEN_HEIGHT = 480; 
localparam SCREEN_PIXEL_COUNT = SCREEN_WIDTH * SCREEN_HEIGHT;

wire active;
wire [$clog2(SCREEN_WIDTH)-1:0] hPos;
wire [$clog2(SCREEN_HEIGHT)-1:0] vPos;

vgaTimingGenerator #(
    .WIDTH(SCREEN_WIDTH),
    .HEIGHT(SCREEN_HEIGHT)
) timingGen (
    .clk(clk),
    .clkEn(clkEn),
    .rst(rst),
    .active(active),
    .hSync(hSync),
    .vSync(vSync),
    .hPos(hPos),
    .vPos(vPos)
);


wire [$clog2(SCREEN_PIXEL_COUNT)-1:0] bgAddress;
wire bgPixel;

counter #(
    .MAX_COUNT(SCREEN_PIXEL_COUNT)
) counterBgAddress (
    .clk(clk),
    .clkEn(clkEn & active),
    .rst(rst),
    .count(bgAddress)
);

blockRom #(
    .DEPTH(SCREEN_PIXEL_COUNT),
    .WIDTH(1),
    .INIT_FILE("background.mem")
) backgroundData (
    .clk(clk),
    .clkEn(clkEn),
    .addr(bgAddress),
    .data(bgPixel)
);

localparam DIGIT_WIDTH = 50;
localparam DIGIT_HEIGHT = 60;
localparam DIGIT_PIXEL_COUNT = DIGIT_WIDTH * DIGIT_HEIGHT;

localparam SCORE_1_H_START = 255;
localparam SCORE_1_H_END = SCORE_1_H_START + DIGIT_WIDTH;
localparam SCORE_1_V_START = 125;
localparam SCORE_1_V_END = SCORE_1_V_START + DIGIT_HEIGHT;

localparam SCORE_2_H_START = 335;
localparam SCORE_2_H_END = SCORE_2_H_START + DIGIT_WIDTH;
localparam SCORE_2_V_START = 125;
localparam SCORE_2_V_END = SCORE_2_V_START + DIGIT_HEIGHT;

wire activeScore1 = (
    (SCORE_1_H_START <= hPos) & (hPos < SCORE_1_H_END) & 
    (SCORE_1_V_START <= vPos) & (vPos < SCORE_1_V_END)
);
wire activeScore2 = (
    (SCORE_2_H_START <= hPos) & (hPos < SCORE_2_H_END) & 
    (SCORE_2_V_START <= vPos) & (vPos < SCORE_2_V_END)
);

wire [$clog2(DIGIT_PIXEL_COUNT)-1:0] digitAddress1, digitAddress2;

counter #(
    .MAX_COUNT(DIGIT_PIXEL_COUNT)
) counterDigitAddress0 (
    .clk(clk),
    .clkEn(clkEn & activeScore1),
    .rst(rst),
    .count(digitAddress1)
);

counter #(
    .MAX_COUNT(DIGIT_PIXEL_COUNT)
) counterDigitAddress1 (
    .clk(clk),
    .clkEn(clkEn & activeScore2),
    .rst(rst),
    .count(digitAddress2)
);

wire [$clog2(DIGIT_PIXEL_COUNT)-1:0] digitAddress = ( 
    activeScore1 ? digitAddress1 : 
    activeScore2 ? digitAddress2 : 0
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

wire drawScore1 = activeScore1 & digitPixel[score1];
wire drawScore2 = activeScore2 & digitPixel[score2];

wire drawPixel = drawScore1 | drawScore2 | bgPixel;
wire [11:0] colorOut = active ? (drawPixel ? fgColor : bgColor) : 0;

assign {vgaRed, vgaGreen, vgaBlue} = colorOut;

endmodule