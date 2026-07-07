module top
(
    input clk,

    input [15:0] sw,
    output [15:0] led,
    
    output [3:0] vgaRed, 
    output [3:0] vgaGreen, 
    output [3:0] vgaBlue,
    output hSync, 
    output vSync
);

wire [3:0] score1 = sw[15:12];
wire [3:0] score2 = sw[3:0];

localparam PADDLE_MIN_H_POS = 110;

wire [9:0] paddle1vPos = PADDLE_MIN_H_POS + sw[15:8];
wire [9:0] paddle2vPos = PADDLE_MIN_H_POS + sw[7:0];

vgaController controller (
    .clk(clk),
    .rst(1'b0),
    .score1(score1),
    .score2(score2),
    .paddle1hPos(50),
    .paddle1vPos(paddle1vPos),
    .paddle2hPos(580),
    .paddle2vPos(paddle2vPos),
    .hSync(hSync),
    .vSync(vSync),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue)
);

assign led = sw;

endmodule