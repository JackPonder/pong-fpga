module gameController (
    input clk,
    input rst,

    input paddle1MoveUp,
    input paddle1MoveDown,
    input paddle2MoveUp,
    input paddle2MoveDown,

    output [9:0] paddle1PosH,
    output [9:0] paddle2PosH,
    output reg [9:0] paddle1PosV,
    output reg [9:0] paddle2PosV,

    output reg [9:0] ballPosH,
    output reg [9:0] ballPosV,

    output reg [3:0] score1,
    output reg [3:0] score2
);

// Run game logic at 100 Hz
wire clkEn;
clkEnGenerator #(
    .DIVISOR(500_000)
) gen (
    .clk(clk),
    .clkEn(clkEn),
    .rst(rst)
);

// Game parameters
localparam GAME_WIDTH = 640;
localparam GAME_HEIGHT = 330;

localparam PADDLE_WIDTH = 10;
localparam PADDLE_HEIGHT = 50;

localparam BALL_WIDTH = 10;
localparam BALL_HEIGHT = 10;

// State variables
reg [3:0] ballSpeedH;
reg [3:0] ballSpeedV;

// Next state variables
reg [9:0] nextPaddle1PosV;
reg [9:0] nextPaddle2PosV;

reg [9:0] nextBallPosH;
reg [9:0] nextBallPosV;

reg [3:0] nextBallSpeedH;
reg [3:0] nextBallSpeedV;

reg [3:0] nextScore1;
reg [3:0] nextScore2;

// Left paddle angle generator
wire [3:0] newSpeedY1;
angleGenerator agLeft (
    nextBallPosV,
    nextPaddle1PosV,
    newSpeedY1
);

// Right paddle angle generator
wire [3:0] newSpeedY2;
angleGenerator agRight (
    nextBallPosV,
    nextPaddle2PosV,
    newSpeedY2
);

// Ball and paddle movement logic
always @(*) begin
    // Left paddle movement
    nextPaddle1PosV = paddle1PosV;
    if (paddle1MoveUp == paddle1MoveDown);
    else if (paddle1MoveUp & paddle1PosV > 0)
        nextPaddle1PosV = paddle1PosV - 1;
    else if (paddle1MoveDown & paddle1PosV < (GAME_HEIGHT - PADDLE_HEIGHT)) 
        nextPaddle1PosV = paddle1PosV + 1;

    // Right paddle movement
    nextPaddle2PosV = paddle2PosV;
    if (paddle2MoveUp == paddle2MoveDown);
    else if (paddle2MoveUp & paddle2PosV > 0)
        nextPaddle2PosV = paddle2PosV - 1;
    else if (paddle2MoveDown & paddle2PosV < (GAME_HEIGHT - PADDLE_HEIGHT)) 
        nextPaddle2PosV = paddle2PosV + 1;

    // Score tracking
    nextScore2 = score2;
    nextScore1 = score1;

    // Ball movement
    nextBallSpeedH = ballSpeedH;
    nextBallSpeedV = ballSpeedV;
    nextBallPosH = ballPosH + {{6{ballSpeedH[3]}}, ballSpeedH};
    nextBallPosV = ballPosV + {{6{ballSpeedV[3]}}, ballSpeedV};

    // Left and right edge detection
    if (ballPosH == 0) begin
        nextScore2 = score2 + 1;
        nextBallSpeedH = ~ballSpeedH + 1;
        nextBallPosH = 315;
        nextBallPosV = 160;
    end else if (ballPosH == (GAME_WIDTH - BALL_WIDTH)) begin
        nextScore1 = score1 + 1;
        nextBallSpeedH = ~ballSpeedH + 1;
        nextBallPosH = 315;
        nextBallPosV = 160;
    end

    // Top and bottom edge detection
    else if (nextBallPosV == 0 | nextBallPosV == (GAME_HEIGHT - BALL_HEIGHT))
        nextBallSpeedV = ~ballSpeedV + 1;

    // Left and right paddle collision detection
    if (checkCollision(nextBallPosH, nextBallPosV, paddle1PosH, paddle1PosV)) begin
        nextBallSpeedH = ~ballSpeedH + 1;
        nextBallSpeedV = newSpeedY1;
    end else if (checkCollision(nextBallPosH, nextBallPosV, paddle2PosH, paddle2PosV)) begin
        nextBallSpeedH = ~ballSpeedH + 1;
        nextBallSpeedV = newSpeedY2;
    end
end

function automatic checkCollision(input [9:0] ballX, ballY, paddleX, paddleY);
    checkCollision = (
        (ballX + BALL_WIDTH >= paddleX) &&
        (paddleX + PADDLE_WIDTH >= ballX) &&
        (ballY + BALL_HEIGHT >= paddleY) &&
        (paddleY + PADDLE_HEIGHT >= ballY)
    );
endfunction

// Update ball and paddle positions
always @(posedge clk or posedge rst) begin
    // Restart game
    if (rst) begin
        paddle1PosV <= 140;
        paddle2PosV <= 140;

        ballPosH <= 315;
        ballPosV <= 160;

        ballSpeedH <= 1;
        ballSpeedV <= 1;

        score1 <= 0;
        score2 <= 0;
    end 
    
    // Update ball and paddle positions on each clock edge
    else if (clkEn) begin
        paddle1PosV <= nextPaddle1PosV;
        paddle2PosV <= nextPaddle2PosV;

        ballPosH <= nextBallPosH;
        ballPosV <= nextBallPosV;

        ballSpeedH <= nextBallSpeedH;
        ballSpeedV <= nextBallSpeedV;

        score1 <= nextScore1;
        score2 <= nextScore2;
    end
end

// Assign constant outputs
assign paddle1PosH = 50;
assign paddle2PosH = 580;

endmodule