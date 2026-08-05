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

/////////////////////
// Paddle movement //
/////////////////////

paddleMovement #(50) paddleMovement1 (
    .clk(clk),
    .rst(rst),

    .jstk(jstk1),
    .paddleX(paddle1X),
    .paddleY(paddle1Y)
);

paddleMovement #(580) paddleMovement2 (
    .clk(clk),
    .rst(rst),

    .jstk(jstk2),
    .paddleX(paddle2X),
    .paddleY(paddle2Y)
);

///////////////////
// Ball movement //
///////////////////

logic collision1;
logic collision2;

logic incScore1;
logic incScore2;

ballMovement ballMovement (
    .clk(clk),
    .rst(rst),

    .collision1(collision1),
    .collision2(collision2),

    .ballX(ballX),
    .ballY(ballY),

    .incScore1(incScore1),
    .incScore2(incScore2)
);

/////////////////////////
// Collision detection //
/////////////////////////

collisionDetector detector1 (
    .paddleX(paddle1X),
    .paddleY(paddle1Y),
    .ballX(ballX),
    .ballY(ballY),
    .collsion(collision1)
);

collisionDetector detector2 (
    .paddleX(paddle2X),
    .paddleY(paddle2Y),
    .ballX(ballX),
    .ballY(ballY),
    .collsion(collision2)
);

////////////////////
// Score tracking //
////////////////////

counter #(15) scoreCounter1 (
    .clk(clk),
    .rst(rst),
    .en(incScore1),
    .count(score1)
);

counter #(15) scoreCounter2 (
    .clk(clk),
    .rst(rst),
    .en(incScore2),
    .count(score2)
);

endmodule