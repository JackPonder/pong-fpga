module top (
    input  logic clk,

    // SPI joysticks
    output logic [1:0] cs,
    output logic [1:0] mosi,
    input  logic [1:0] miso,
    output logic [1:0] sclk,

    // VGA display
    output logic [3:0] vgaRed, 
    output logic [3:0] vgaGreen, 
    output logic [3:0] vgaBlue,
    output logic       hSync, 
    output logic       vSync,

    // 7-segment display
    output logic [6:0] seg,
    output logic       dp,
    output logic [3:0] an
);

////////////
// Clocks //
////////////

logic clkVga;
logic locked;

clocks clocks (
    .clk(clk),
    .rst(1'b0),
    .clkVga(clkVga),
    .locked(locked)
);

//////////////////////////
// Joystick SPI Masters //
//////////////////////////

logic [9:0] jstk1Y;
logic [9:0] jstk2Y;
logic [1:0] buttons;

spiMaster master1 (
    .clk(clk),
    .rst(1'b0),
    
    .sclk(sclk[0]),
    .mosi(mosi[0]),
    .miso(miso[0]),
    .cs(cs[0]),
    
    .jstkX(),
    .jstkY(jstk1Y),
    .buttons(buttons)
);

spiMaster master2 (
    .clk(clk),
    .rst(1'b0),
    
    .sclk(sclk[1]),
    .mosi(mosi[1]),
    .miso(miso[1]),
    .cs(cs[1]),
    
    .jstkX(),
    .jstkY(jstk2Y),
    .buttons()
);

////////////////
// Game Logic //
////////////////

logic [9:0] paddle1X;
logic [8:0] paddle1Y;
logic [9:0] paddle2X;
logic [8:0] paddle2Y;
logic [9:0] ballX;
logic [8:0] ballY;

logic [3:0] score1;
logic [3:0] score2;

gameLogic gameLogic (
    .clk(clk),
    .rst(buttons[1]),

    .jstk1(jstk1Y),
    .jstk2(jstk2Y),

    .paddle1X(paddle1X),
    .paddle1Y(paddle1Y),
    .paddle2X(paddle2X),
    .paddle2Y(paddle2Y),
    .ballX(ballX),
    .ballY(ballY),

    .score1(score1),
    .score2(score2)
);

////////////////
// VGA Output //
////////////////

vgaDriver vgaDriver (
    .clk(clkVga),
    .rst(!locked),

    .paddle1X(paddle1X),
    .paddle1Y(paddle1Y),
    .paddle2X(paddle2X),
    .paddle2Y(paddle2Y),
    .ballX(ballX),
    .ballY(ballY),
    .score1(score1),
    .score2(score2),

    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue),
    .hSync(hSync),
    .vSync(vSync)
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

endmodule