module gameController (
    input clk,
    input rst,

    input paddle1Up,
    input paddle1Down,
    input paddle2Up,
    input paddle2Down,

    output reg [9:0] paddle1vPos,
    output reg [9:0] paddle2vPos,

    output reg [9:0] ballhPos,
    output reg [9:0] ballvPos,

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

localparam H_POS_MAX = 630;
localparam V_POS_MAX = 320;

reg ballRight, nextBallRight;
reg ballDown, nextBallDown;

reg [3:0] ballhSpeed = 1;
reg [3:0] ballvSpeed = 1;

reg [3:0] nextScore1;
reg [3:0] nextScore2;

reg [9:0] nextBallhPos;
reg [9:0] nextBallvPos;

reg [9:0] nextPaddle1vPos;
reg [9:0] nextPaddle2vPos;

always @(*) begin
    nextBallDown = ballDown;
    nextBallRight = ballRight;

    nextScore1 = score1;
    nextScore2 = score2;

    nextBallhPos = ballRight ? (ballhPos + ballhSpeed) : (ballhPos - ballhSpeed);
    nextBallvPos = ballDown ? (ballvPos + ballvSpeed) : (ballvPos - ballvSpeed);

    nextPaddle1vPos = paddle1vPos;
    nextPaddle2vPos = paddle2vPos;

    if (paddle1Up)
        nextPaddle1vPos = paddle1vPos - 1;
    if (paddle1Down) 
        nextPaddle1vPos = paddle1vPos + 1;

    if (paddle2Up)
        nextPaddle2vPos = paddle2vPos - 1;
    if (paddle2Down) 
        nextPaddle2vPos = paddle2vPos + 1;

    if (ballhPos == 0) begin
        nextScore2 = score2 + 1;
        nextBallhPos = 315;
        nextBallvPos = 135;
    end else if (ballhPos == H_POS_MAX - 1) begin
        nextScore1 = score1 + 1;
        nextBallhPos = 315;
        nextBallvPos = 155;
    end

    if (ballvPos == 0 || ballvPos == V_POS_MAX - 1) begin
        nextBallDown = !nextBallDown;
        nextBallvPos = ballDown ? (ballvPos - ballvSpeed) : (ballvPos + ballvSpeed);
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        paddle1vPos <= 0;
        paddle2vPos <= 0;

        ballhPos <= 315;
        ballvPos <= 155;
        
        score1 <= 0;
        score2 <= 0;

        ballhSpeed <= 1;
        ballvSpeed <= 1;
    end else if (clkEn) begin
        ballhPos <= nextBallhPos;
        ballvPos <= nextBallvPos;

        score1 <= nextScore1;
        score2 <= nextScore2;

        ballRight <= nextBallRight;
        ballDown <= nextBallDown;

        paddle1vPos <= nextPaddle1vPos;
        paddle2vPos <= nextPaddle2vPos;
    end
end

endmodule