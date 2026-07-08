module top (
    input clk,

    input btnC,
    input btnU,
    input btnL,
    input btnR,
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

localparam OFFSET_WIDTH = 0;
localparam OFFSET_HEIGHT = 110;

wire [9:0] paddle1PosH;
wire [9:0] paddle2PosH;
wire [9:0] paddle1PosV;
wire [9:0] paddle2PosV;

wire [9:0] ballPosH;
wire [9:0] ballPosV;

wire [3:0] score1;
wire [3:0] score2;

gameController control (
    .clk(clk),
    .rst(btnC),

    .paddle1MoveUp(btnU),
    .paddle1MoveDown(btnL),
    .paddle2MoveUp(btnR),
    .paddle2MoveDown(btnD),

    .paddle1PosH(paddle1PosH),
    .paddle2PosH(paddle2PosH),
    .paddle1PosV(paddle1PosV),
    .paddle2PosV(paddle2PosV),

    .ballPosH(ballPosH),
    .ballPosV(ballPosV),

    .score1(score1),
    .score2(score2)
);

vgaController controller (
    .clk(clk),
    .rst(1'b0),

    .paddle1PosH(OFFSET_WIDTH + paddle1PosH),
    .paddle1PosV(OFFSET_HEIGHT + paddle1PosV),
    .paddle2PosH(OFFSET_WIDTH + paddle2PosH),
    .paddle2PosV(OFFSET_HEIGHT + paddle2PosV),

    .ballPosH(OFFSET_WIDTH + ballPosH),
    .ballPosV(OFFSET_HEIGHT + ballPosV),

    .score1(score1),
    .score2(score2),

    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue),
    .hSync(hSync),
    .vSync(vSync)
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