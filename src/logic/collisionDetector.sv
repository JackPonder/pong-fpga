module collisionDetector (
    // Object positions
    input  logic [9:0] paddleX,
    input  logic [8:0] paddleY,
    input  logic [9:0] ballX,
    input  logic [8:0] ballY,

    // Collision flag
    output logic collsion
);

// Object dimensions
localparam [9:0] PaddleWidth = 10;
localparam [8:0] PaddleHeight = 50;
localparam [9:0] BallWidth = 10;
localparam [8:0] BallHeight = 10;

// Set collsion flag using AABB collsion detection
assign collsion = (
    (ballX + BallWidth >= paddleX) &&
    (paddleX + PaddleWidth >= ballX) &&
    (ballY + BallHeight >= paddleY) &&
    (paddleY + PaddleHeight >= ballY)
);
    
endmodule