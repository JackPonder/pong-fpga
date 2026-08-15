module collisionDetector (
    // Object positions
    input  logic [9:0] paddleX,
    input  logic [8:0] paddleY,
    input  logic [9:0] ballX,
    input  logic [8:0] ballY,

    // Collision flags
    output logic collision,
    output logic collisionPoint,

    // Hit location
    output logic [4:0] hitLocation
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
wire [8:0] paddleCenter = paddleY + (PaddleHeight / 2);
wire [8:0] ballCenter = ballY + (BallHeight / 2);

// Determine if collision is on the top or bottom half of the paddle
assign collisionPoint = (ballCenter > paddleCenter);

// Calculate hit location
assign hitLocation = collisionPoint ? (ballCenter - paddleCenter) : (paddleCenter - ballCenter);
    
endmodule
