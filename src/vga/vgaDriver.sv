module vgaDriver (
    input  logic clk,
    input  logic rst,

    // Game state
    input  logic [9:0] paddle1X,
    input  logic [8:0] paddle1Y,
    input  logic [9:0] paddle2X,
    input  logic [8:0] paddle2Y,
    input  logic [9:0] ballX,
    input  logic [8:0] ballY,
    input  logic [3:0] score1,
    input  logic [3:0] score2,

    // VGA output
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue,
    output logic       hSync,
    output logic       vSync
);

////////////////
// VGA Timing //
////////////////

logic [9:0] x;
logic [8:0] y;
logic active;

vgaTiming vgaTiming (
    .clk(clk),
    .rst(rst),

    .x(x),
    .y(y),
    .active(active),

    .hSync(hSync),
    .vSync(vSync)
);

//////////////////////
// Background Image //
//////////////////////

// Screen dimensions
localparam ScreenWidth = 640;
localparam ScreenHeight = 480; 

// Calculate background pixel address
wire [18:0] bgAddr = x + y * ScreenWidth;

// Background pixel data
logic bgPixel;

// ROM for background image
rom #(
    .InitFile("background.mem"),
    .DataWidth(1),
    .Depth(ScreenWidth * ScreenHeight)
) bgImage (
    .clk(clk),
    .addr(bgAddr),
    .dout(bgPixel)
);

// Draw pixel if bitmask is a 1
wire drawBg = bgPixel;

////////////
// Scores //
////////////

// Scorecard dimensions
localparam ScoreWidth = 100;
localparam ScoreHeight = 60;

// Scorecard positions
localparam Score1X = 205;
localparam Score2X = 335;
localparam ScoreY = 125;

// Determine if position is within the region to draw the scorecard
wire activeScore1 = (Score1X <= x && x < Score1X + ScoreWidth) && (ScoreY <= y && y < ScoreY + ScoreHeight);
wire activeScore2 = (Score2X <= x && x < Score2X + ScoreWidth) && (ScoreY <= y && y < ScoreY + ScoreHeight);

// Calculate score pixel address
wire [9:0] scoreOffsetX = x - (activeScore1 ? Score1X : Score2X);
wire [8:0] scoreOffsetY = y - ScoreY;
wire [12:0] scoreAddr = scoreOffsetX + scoreOffsetY * ScoreWidth;

// Scorecard pixel data
logic scorePixels[16];

// ROMs for each scorecard
for (genvar i = 0; i < 16; i++) begin : scoreRoms
    rom #(
        .InitFile($sformatf("%d.mem", i)),
        .DataWidth(1),
        .Depth(ScoreWidth * ScoreHeight)
    ) inst (
        .clk(clk),
        .addr(scoreAddr),
        .dout(scorePixels[i])
    );
end

// Draw pixel logic
wire drawScore1 = activeScore1 ? scorePixels[score1] : '0;
wire drawScore2 = activeScore2 ? scorePixels[score2] : '0;

////////////////////
// Paddles & Ball //
////////////////////

// Object dimensions
localparam PaddleWidth = 10;
localparam PaddleHeight = 50;

localparam BallWidth = 10;
localparam BallHeight = 10;

// Draw object if current position is in range of object position
wire drawPaddle1 = (paddle1X <= x && x < paddle1X + PaddleWidth) && (paddle1Y <= y && y < paddle1Y + PaddleHeight);
wire drawPaddle2 = (paddle2X <= x && x < paddle2X + PaddleWidth) && (paddle2Y <= y && y < paddle2Y + PaddleHeight);
wire drawBall = (ballX <= x && x < ballX + BallWidth) && (ballY <= y && y < ballY + BallHeight);

////////////
// Output //
////////////

// Draw pixel logic
wire draw = |{drawBg, drawScore1, drawScore2, drawPaddle1, drawPaddle2, drawBall};

// VGA colors
localparam fgColor = 12'hFFF;
localparam bgColor = 12'h000;

// Output VGA color
assign {vgaRed, vgaGreen, vgaBlue} = active ? (draw ? fgColor : bgColor) : '0;

endmodule