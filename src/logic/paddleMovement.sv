module paddleMovement #(
    parameter FixedPaddleX = 0
) (
    input  logic clk,
    input  logic rst,
    input  logic en,

    // User input
    input  logic [9:0] jstk,

    // Paddle position
    output logic [9:0] paddleX,
    output logic [8:0] paddleY
);

// Paddle boundaries
localparam PaddleMinY = 110;
localparam PaddleMaxY = 390;

// Initial paddle position
localparam InitialPaddleY = 250;

// Paddle movement logic
always @(posedge clk) begin
    if (rst) begin
        paddleY <= InitialPaddleY;
    end else if (en) begin
        if ((jstk > 682) && (paddleY > PaddleMinY))
            paddleY <= paddleY - 1'b1;
        else if ((jstk < 381) && (paddleY < PaddleMaxY))
            paddleY <= paddleY + 1'b1;
    end
end

// Keep paddle at fixed X position
assign paddleX = FixedPaddleX;
    
endmodule