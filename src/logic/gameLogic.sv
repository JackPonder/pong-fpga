module gameLogic (
    input  logic clk,
    input  logic rst,

    // User inputs
    input  logic [9:0] jstk1,
    input  logic [9:0] jstk2,

    // Game state
    output logic [9:0] paddle1X,
    output logic [8:0] paddle1Y,
    output logic [9:0] paddle2X,
    output logic [8:0] paddle2Y,
    output logic [9:0] ballX,
    output logic [8:0] ballY,

    output logic [3:0] score1,
    output logic [3:0] score2
);

////////////////////
// Enable signals //
////////////////////

logic en;

enGenerator #(
    .Width(19)
) enGen (
    .clk(clk),
    .rst(rst),
    .divisor(19'd500000),
    .en(en)
);

logic [22:0] divisorEnX;
logic enX;

enGenerator #(
    .Width(23)
) enGenX (
    .clk(clk),
    .rst(rst),
    .divisor(divisorEnX),
    .en(enX)
);

logic [22:0] divisorEnY;
logic enY;

enGenerator #(
    .Width(23)
) enGenY (
    .clk(clk),
    .rst(rst),
    .divisor(divisorEnY),
    .en(enY)
);

/////////////////////
// Paddle movement //
/////////////////////

paddleMovement #(50) paddleMovement1 (
    .clk(clk),
    .rst(rst),
    .en(en),

    .jstk(jstk1),
    .paddleX(paddle1X),
    .paddleY(paddle1Y)
);

paddleMovement #(580) paddleMovement2 (
    .clk(clk),
    .rst(rst),
    .en(en),

    .jstk(jstk2),
    .paddleX(paddle2X),
    .paddleY(paddle2Y)
);

///////////////////
// Ball movement //
///////////////////

logic collision1;
logic collision2;
logic collisionPoint1;
logic collisionPoint2;

logic [4:0] hitLocation1;
logic [4:0] hitLocation2;

logic incScore1;
logic incScore2;

ballMovement ballMovement (
    .clk(clk),
    .rst(rst),
    .enX(enX),
    .enY(enY),

    .collision1(collision1),
    .collision2(collision2),
    .collisionPoint1(collisionPoint1),
    .collisionPoint2(collisionPoint2),

    .ballX(ballX),
    .ballY(ballY),

    .incScore1(incScore1),
    .incScore2(incScore2)
);

ballSpeed ballSpeed (
    .clk(clk),
    .rst(rst),

    .collision1(collision1),
    .collision2(collision2),
    .hitLocation1(hitLocation1),
    .hitLocation2(hitLocation2),

    .divisorEnX(divisorEnX),
    .divisorEnY(divisorEnY)
);

/////////////////////////
// Collision detection //
/////////////////////////

collisionDetector detector1 (
    .paddleX(paddle1X),
    .paddleY(paddle1Y),
    .ballX(ballX),
    .ballY(ballY),
    .collision(collision1),
    .collisionPoint(collisionPoint1),
    .hitLocation(hitLocation1)
);

collisionDetector detector2 (
    .paddleX(paddle2X),
    .paddleY(paddle2Y),
    .ballX(ballX),
    .ballY(ballY),
    .collision(collision2),
    .collisionPoint(collisionPoint2),
    .hitLocation(hitLocation2)
);

////////////////////
// Score tracking //
////////////////////

counter #(15) scoreCounter1 (
    .clk(clk),
    .rst(rst),
    .en(enX && incScore1),
    .count(score1)
);

counter #(15) scoreCounter2 (
    .clk(clk),
    .rst(rst),
    .en(enX && incScore2),
    .count(score2)
);

endmodule