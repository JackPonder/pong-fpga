module top (
    input clk,

    // Buttons
    input btnC,
    input btnU,
    input btnL,
    input btnR,
    input btnD,

    // Switches
    input [15:0] sw,

    // LEDs
    output [15:0] led,
    
    // VGA display
    output [3:0] vgaRed, 
    output [3:0] vgaGreen, 
    output [3:0] vgaBlue,
    output hSync, 
    output vSync,

    // Seven degment display
    output dp,
    output [6:0] seg,
    output [3:0] an,

    // Pmod joystick
    output sclk,
    output mosi,
    input  miso,
    output cs
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

wire [9:0] jstkY;
wire trigger;

spiMaster spiMaster (
    .clk(clk),
    .rst(1'b0),
    
    .sclk(sclk),
    .mosi(mosi),
    .miso(miso),
    .cs(cs),
    
    .jstkX(),
    .jstkY(jstkY),
    .trigger(trigger),
    .button()
);

gameController control (
    .clk(clk),
    .rst(trigger),

    .paddle1MoveUp(jstkY > 682),
    .paddle1MoveDown(jstkY < 341),
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

ssdDriver ssdDriver (
    .clk(clk),
    .rst(1'b0),

    .seg(seg),
    .dp(dp),
    .an(an)
);

assign led = sw;

endmodule