module collisionDetector (
    // Object positions
    input  logic [9:0] paddleX,
    input  logic [8:0] paddleY,
    input  logic [9:0] ballX,
    input  logic [8:0] ballY,

    // Collision flags
    output logic collision,
    output logic collisionAngle,

    // Ball speed
    output logic [22:0] ballAngleX,
    output logic [22:0] ballAngleY
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
wire signed [9:0] paddleCenter = paddleY + (PaddleHeight / 2);
wire signed [9:0] ballCenter = ballY + (BallHeight / 2);
wire signed [9:0] hitLocation = ballCenter - paddleCenter;

// Determine new ball angle after collision
assign collisionAngle = (hitLocation > 0) ? 1'b1 : 1'b0;

// 
always_comb begin
    case ((hitLocation > 0) ? hitLocation : -hitLocation) inside
        [0:1]:   begin ballAngleX = 23'd200069; ballAngleY = 23'd7640310; end
        [2:3]:   begin ballAngleX = 23'd200618; ballAngleY = 23'd2549099; end
        [4:5]:   begin ballAngleX = 23'd201726; ballAngleY = 23'd1532260; end
        [6:7]:   begin ballAngleX = 23'd203406; ballAngleY = 23'd1097481; end
        [8:9]:   begin ballAngleX = 23'd205683; ballAngleY = 23'd856732; end
        [10:11]: begin ballAngleX = 23'd208590; ballAngleY = 23'd704187; end
        [12:13]: begin ballAngleX = 23'd212170; ballAngleY = 23'd599149; end
        [14:15]: begin ballAngleX = 23'd216478; ballAngleY = 23'd522625; end
        [16:17]: begin ballAngleX = 23'd221586; ballAngleY = 23'd464564; end
        [18:19]: begin ballAngleX = 23'd227579; ballAngleY = 23'd419148; end
        [20:21]: begin ballAngleX = 23'd234566; ballAngleY = 23'd382776; end
        [22:23]: begin ballAngleX = 23'd242681; ballAngleY = 23'd353103; end
        [24:25]: begin ballAngleX = 23'd252094; ballAngleY = 23'd328536; end
        [26:27]: begin ballAngleX = 23'd263017; ballAngleY = 23'd307954; end
        [28:29]: begin ballAngleX = 23'd275720; ballAngleY = 23'd290548; end
        default: begin ballAngleX = 23'd290548; ballAngleY = 23'd275720; end
    endcase
end


    
endmodule