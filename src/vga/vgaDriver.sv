module vgaDriver (
    input  logic clk,
    input  logic rst,

    // Screen position
    input  logic [9:0] x,
    input  logic [8:0] y,
    input  logic       active,

    // Game state
    input  logic [9:0] paddle1X,
    input  logic [8:0] paddle1Y,
    input  logic [9:0] paddle2X,
    input  logic [8:0] paddle2Y,
    input  logic [9:0] ballX,
    input  logic [8:0] ballY,
    input  logic [3:0] score1,
    input  logic [3:0] score2,

    // VGA pixel color
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue
);

//////////////////////
// Background Image //
//////////////////////

// Screen dimensions
localparam ScreenWidth = 640;
localparam ScreenHeight = 480; 

// Background image row buffer
logic bgPixel;

// ROM for background image
rom #(
    .InitFile("background.mem"),
    .DataWidth(1),
    .Depth(ScreenWidth * ScreenHeight)
) bgImage (
    .clk(clk),
    .addr(x + y * ScreenWidth),
    .dout(bgPixel)
);

// Draw pixel if bitmask is a 1
wire drawBg = bgPixel;

////////////
// Scores //
////////////

// Scorecard dimensions
localparam logic [9:0] ScoreWidth = 100;
localparam logic [8:0] ScoreHeight = 60;

// Scorecard positions
localparam logic [9:0] Score1X = 205;
localparam logic [9:0] Score2X = 335;
localparam logic [8:0] ScoreY = 125;

// Scorecard row buffers
logic scorePixels[16];

// ROMs for each scorecard
for (genvar i = 0; i < 16; i++) begin
    rom #(
        .InitFile($sformatf("%d.mem", i)),
        .DataWidth(1),
        .Depth(ScoreWidth * ScoreHeight)
    ) scoreImage (
        .clk(clk),
        .addr('0),
        .dout(scorePixels[i])
    );
end

// Draw pixel logic
wire activeScore1 = (Score1X <= x && x < Score1X + ScoreWidth) && (ScoreY <= y && y < ScoreY + ScoreHeight);
wire activeScore2 = (Score2X <= x && x < Score2X + ScoreWidth) && (ScoreY <= y && y < ScoreY + ScoreHeight);

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