module collisionDetector (
    // Object positions
    input  logic [9:0] paddleX,
    input  logic [8:0] paddleY,
    input  logic [9:0] ballX,
    input  logic [8:0] ballY,

    // Collision flags
    output logic collision,
    output logic collisionAngle
);

// Object dimensions
localparam [9:0] PaddleWidth = 10;
localparam [8:0] PaddleHeight = 50;
localparam [9:0] BallWidth = 10;
localparam [8:0] BallHeight = 10;

// Set collision flag using AABB collision detection
assign collision = (
    (ballX + BallWidth >= paddleX) &&
    (paddleX + PaddleWidth >= ballX) &&
    (ballY + BallHeight >= paddleY) &&
    (paddleY + PaddleHeight >= ballY)
);

// Center positions
wire [9:0] paddleCenter = paddleY + (PaddleHeight / 2);
wire [9:0] ballCenter = ballY + (BallHeight / 2);

// Determine new ball angle after collision
assign collisionAngle = (ballCenter > paddleCenter) ? 1'b1 : 1'b0;
    
endmodule