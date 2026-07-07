module top
(
    input clk,

    input btnC,
    input btnR,
    input btnL,
    input btnU,
    input btnD,

    input [15:0] sw,
    output [15:0] led,
    
    output [3:0] vgaRed, 
    output [3:0] vgaGreen, 
    output [3:0] vgaBlue,
    output hSync, 
    output vSync,

    output dp,
    output [6:0] seg,
    output [3:0] an
);

localparam MIN_V_POS = 110;

wire [9:0] paddle1vPos;
wire [9:0] paddle2vPos;

wire [9:0] ballhPos;
wire [9:0] ballvPos;

wire [3:0] score1;
wire [3:0] score2;

gameController control (
    .clk(clk),
    .rst(btnC),
    .paddle1Up(btnU),
    .paddle1Down(btnL),
    .paddle2Up(btnR),
    .paddle2Down(btnD),
    .paddle1vPos(paddle1vPos),
    .paddle2vPos(paddle2vPos),
    .ballhPos(ballhPos),
    .ballvPos(ballvPos),
    .score1(score1),
    .score2(score2)
);

vgaController controller (
    .clk(clk),
    .rst(1'b0),
    .score1(score1),
    .score2(score2),
    .paddle1hPos(50),
    .paddle1vPos(MIN_V_POS + paddle1vPos),
    .paddle2hPos(580),
    .paddle2vPos(MIN_V_POS + paddle2vPos),
    .ballhPos(ballhPos),
    .ballvPos(MIN_V_POS + ballvPos),
    .hSync(hSync),
    .vSync(vSync),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue)
);

sevenSegmentDriver driver (
    .clk(clk),
    .rst(1'b0),
    .dp(dp),
    .seg(seg),
    .an(an)
);

assign led = sw;

endmodule