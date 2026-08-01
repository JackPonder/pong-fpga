module angleGenerator (
    input  [9:0] ballY,
    input  [9:0] paddleY,

    // output reg [3:0] speedX,
    output reg signed [3:0] speedY
);

// Sizes
localparam PADDLE_HEIGHT = 50;
localparam BALL_HEIGHT = 10;

wire [9:0] ballCenter = ballY + BALL_HEIGHT / 2;
wire [9:0] paddleCenter = paddleY + PADDLE_HEIGHT / 2;

wire signed [9:0] angle = $signed({1'b0, ballCenter}) - $signed({1'b0, paddleCenter});

always @(*) begin
    speedY = (
        (angle > 0) ?  1 :
        (angle < 0) ? -1 : 0
    );
end
 
endmodule