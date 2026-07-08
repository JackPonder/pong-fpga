module gameController (
    input clk,
    input rst,

    input paddle1MoveUp,
    input paddle1MoveDown,
    input paddle2MoveUp,
    input paddle2MoveDown,

    output reg [9:0] paddle1PosV,
    output reg [9:0] paddle2PosV,

    output reg [9:0] ballPosH,
    output reg [9:0] ballPosV,

    output reg [3:0] score1,
    output reg [3:0] score2
);

wire clkEn;
clkEnGenerator #(
    .DIVISOR(1_000_000)
) gen (
    .clk(clk),
    .clkEn(clkEn),
    .rst(rst)
);

localparam GAME_WIDTH = 640;
localparam GAME_HEIGHT = 330;

localparam PADDLE_WIDTH = 10;
localparam PADDLE_HEIGHT = 50;

localparam BALL_WIDTH = 10;
localparam BALL_HEIGHT = 10;

reg ballMoveRight, nextBallMoveRight;
reg ballMoveDown, nextBallMoveDown;

reg [3:0] ballSpeedH = 1;
reg [3:0] ballSpeedV = 1;

reg [3:0] nextScore1;
reg [3:0] nextScore2;

reg [9:0] nextBallPosH;
reg [9:0] nextBallPosV;

reg [9:0] nextPaddle1PosV;
reg [9:0] nextPaddle2PosV;

// Ball and paddle logic
always @(*) begin
    // Score tracking
    nextScore1 = score1;
    nextScore2 = score2;

    // Left paddle movement
    nextPaddle1PosV = paddle1PosV;
    if (paddle1MoveUp & paddle1PosV > 0)
        nextPaddle1PosV = paddle1PosV - 1;
    if (paddle1MoveDown & paddle1PosV < (GAME_HEIGHT - PADDLE_HEIGHT - 1)) 
        nextPaddle1PosV = paddle1PosV + 1;

    // Right paddle movement
    nextPaddle2PosV = paddle2PosV;
    if (paddle2MoveUp & paddle2PosV > 0)
        nextPaddle2PosV = paddle2PosV - 1;
    if (paddle2MoveDown & paddle2PosV < (GAME_HEIGHT - PADDLE_HEIGHT - 1)) 
        nextPaddle2PosV = paddle2PosV + 1;

    // Ball movement
    nextBallMoveDown = ballMoveDown;
    nextBallMoveRight = ballMoveRight;
    nextBallPosH = ballMoveRight ? (ballPosH + ballSpeedH) : (ballPosH - ballSpeedH);
    nextBallPosV = ballMoveDown ? (ballPosV + ballSpeedV) : (ballPosV - ballSpeedV);

    // Left edge detection
    if (ballPosH == 0) begin
        nextScore2 = score2 + 1;
        nextBallPosH = 315;
        nextBallPosV = 135;
    end 
    
    // Right edge detection
    else if (ballPosH == (GAME_WIDTH - BALL_HEIGHT - 1)) begin
        nextScore1 = score1 + 1;
        nextBallPosH = 315;
        nextBallPosV = 155;
    end

    // Top and bottom edge detection
    if (ballPosV == 0 || ballPosV == (GAME_HEIGHT - BALL_HEIGHT - 1)) begin
        nextBallMoveDown = !nextBallMoveDown;
        nextBallPosV = ballMoveDown ? (ballPosV - ballSpeedV) : (ballPosV + ballSpeedV);
    end
end

// Update ball and paddle positions on each clock edge
always @(posedge clk or posedge rst) begin
    if (rst) begin
        paddle1PosV <= 0;
        paddle2PosV <= 0;

        ballPosH <= 315;
        ballPosV <= 155;
        
        score1 <= 0;
        score2 <= 0;

        ballSpeedH <= 1;
        ballSpeedV <= 1;
    end else if (clkEn) begin
        ballPosH <= nextBallPosH;
        ballPosV <= nextBallPosV;

        score1 <= nextScore1;
        score2 <= nextScore2;

        ballMoveRight <= nextBallMoveRight;
        ballMoveDown <= nextBallMoveDown;

        paddle1PosV <= nextPaddle1PosV;
        paddle2PosV <= nextPaddle2PosV;
    end
end

endmodule