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
    .DIVISOR(1_000_000)
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

// Ball and paddle movement logic
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
    nextBallSpeedH = ballSpeedH;
    nextBallSpeedV = ballSpeedV;
    nextBallPosH = ballPosH + {{6{ballSpeedH[3]}}, ballSpeedH};
    nextBallPosV = ballPosV + {{6{ballSpeedV[3]}}, ballSpeedV};

    // Left edge detection
    if (ballPosH == 0) begin
        nextBallSpeedH = ~ballSpeedH + 1;
        nextBallPosH = 315;
        nextBallPosV = 135;
        nextScore2 = score2 + 1;
    end 
    
    // Right edge detection
    else if (ballPosH == (GAME_WIDTH - BALL_HEIGHT - 1)) begin
        nextBallSpeedH = ~ballSpeedH + 1;
        nextBallPosH = 315;
        nextBallPosV = 155;
        nextScore1 = score1 + 1;
    end

    // Top and bottom edge detection
    if (ballPosV == 0 || ballPosV == (GAME_HEIGHT - BALL_HEIGHT - 1)) begin
        nextBallSpeedV = ~ballSpeedV + 1;
        nextBallPosV = ballPosV - {{6{ballSpeedV[3]}}, ballSpeedV};
    end
end

// Update ball and paddle positions
always @(posedge clk or posedge rst) begin
    // Restart game
    if (rst) begin
        paddle1PosV <= 140;
        paddle2PosV <= 140;

        ballPosH <= 315;
        ballPosV <= 155;

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