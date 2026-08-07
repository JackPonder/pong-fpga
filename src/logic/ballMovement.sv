module ballMovement (
    input  logic clk,
    input  logic rst,
    input  logic enX,
    input  logic enY,

    // Collision flags
    input  logic collision1,
    input  logic collision2,
    input  logic collisionPoint1,
    input  logic collisionPoint2,

    // Ball position
    output logic [9:0] ballX,
    output logic [8:0] ballY,

    // Scoring
    output logic incScore1,
    output logic incScore2
);

// Ball boundaries
localparam BallMinX = 0;
localparam BallMaxX = 630;
localparam BallMinY = 110;
localparam BallMaxY = 430;

// Initial ball position
localparam InitialBallX = 315;
localparam InitialBallY = 270;

// State registers
logic [9:0] nextBallX;
logic [8:0] nextBallY;
logic ballDirX, nextBallDirX;
logic ballDirY, nextBallDirY;

// State transition logic
always_ff @(posedge clk) begin
    if (rst) begin
        ballX <= InitialBallX;
        ballY <= InitialBallY;
        ballDirX <= 1'b1;
        ballDirY <= 1'b1;
    end else begin
        if (enX) begin
            ballX <= nextBallX;
            ballDirX <= nextBallDirX;
        end
        if (enY) begin
            ballY <= nextBallY;
            ballDirY <= nextBallDirY;
        end
    end
end

// Next ball position logic
always_comb begin
    nextBallX = ballDirX ? (ballX + 1'b1) : (ballX - 1'b1);
    nextBallY = ballDirY ? (ballY + 1'b1) : (ballY - 1'b1);
    nextBallDirX = ballDirX;
    nextBallDirY = ballDirY;

    // Left edge detection
    if (ballX == BallMinX) begin
        nextBallDirX = 1'b1;
        nextBallX = InitialBallX;
        nextBallY = InitialBallY;
    end 

    // Right edge detection
    else if (ballX == BallMaxX) begin
        nextBallDirX = 1'b0;
        nextBallX = InitialBallX;
        nextBallY = InitialBallY;
    end

    // Top edge detection
    if (ballY == BallMinY) begin
        nextBallDirY = 1'b1;
    end

    // Botton edge detection
    else if (ballY == BallMaxY) begin
        nextBallDirY = 1'b0;
    end

    // Paddle 1 collision detection
    if (collision1) begin
        nextBallDirX = 1'b1;
        nextBallDirY = collisionPoint1;
    end

    // Paddle 2 collision detection
    else if (collision2) begin
        nextBallDirX = 1'b0;
        nextBallDirY = collisionPoint2;
    end
end

// Increment score flags
assign incScore1 = (ballX == BallMaxX);
assign incScore2 = (ballX == BallMinX);

endmodule