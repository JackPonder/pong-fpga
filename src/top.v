module top (
    input clk,

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

////////////////////////////
// Joystick SPI Interface //
////////////////////////////

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

////////////////
// Game Logic //
////////////////

wire [9:0] paddle1X;
wire [8:0] paddle1Y;

wire [9:0] paddle2X;
wire [8:0] paddle2Y;

wire [9:0] ballX;
wire [8:0] ballY;

wire [3:0] score1;
wire [3:0] score2;

gameController control (
    .clk(clk),
    .rst(trigger),

    .paddle1MoveUp(jstkY > 682),
    .paddle1MoveDown(jstkY < 341),
    .paddle2MoveUp(jstkY > 682),
    .paddle2MoveDown(jstkY < 341),

    .paddle1PosH(paddle1X),
    .paddle2PosH(paddle2X),
    .paddle1PosV(paddle1Y),
    .paddle2PosV(paddle2Y),

    .ballPosH(ballX),
    .ballPosV(ballY),

    .score1(score1),
    .score2(score2)
);

////////////
// Clocks //
////////////

wire clkVga, locked;

clocks clocks (
    .clk(clk),
    .rst(1'b0),
    .clkVga(clkVga),
    .locked(locked)
);

////////////////
// VGA Output //
////////////////

wire [9:0] x;
wire [8:0] y;
wire active;

vgaTiming vgaTiming (
    .clk(clkVga),
    .rst(!locked),

    .x(x),
    .y(y),
    .active(active),

    .hSync(hSync),
    .vSync(vSync)
);

localparam [9:0] OffsetX = 0;
localparam [8:0] OffsetY = 110;

vgaDriver vgaDriver (
    .clk(clkVga),
    .rst(!locked),

    .x(x),
    .y(y),
    .active(active),

    .paddle1X(OffsetX + paddle1X),
    .paddle1Y(OffsetY + paddle1Y),
    .paddle2X(OffsetX + paddle2X),
    .paddle2Y(OffsetY + paddle2Y),
    .ballX(OffsetX + ballX),
    .ballY(OffsetY + ballY),
    .score1(score1),
    .score2(score2),

    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue)
);

////////////////
// SSD Output //
////////////////

ssdDriver ssdDriver (
    .clk(clk),
    .rst(1'b0),

    .seg(seg),
    .dp(dp),
    .an(an)
);

//////////
// Misc //
//////////

assign led = sw;

endmodule