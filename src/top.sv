module top (
    input  logic clk,

    // Switches & LEDs
    input  logic [15:0] sw,
    output logic [15:0] led,
    
    // VGA display
    output logic [3:0] vgaRed, 
    output logic [3:0] vgaGreen, 
    output logic [3:0] vgaBlue,
    output logic       hSync, 
    output logic       vSync,

    // 7-segment display
    output logic [6:0] seg,
    output logic       dp,
    output logic [3:0] an,

    // Pmod joystick
    output logic sclk,
    output logic mosi,
    input  logic miso,
    output logic cs
);

////////////////////////////
// Joystick SPI Interface //
////////////////////////////

logic [9:0] jstkY;
logic trigger;

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
    .rst(trigger),

    .jstk1(jstkY),
    .jstk2(jstkY),

    .paddle1X(paddle1X),
    .paddle1Y(paddle1Y),
    .paddle2X(paddle2X),
    .paddle2Y(paddle2Y),
    .ballX(ballX),
    .ballY(ballY),

    .score1(score1),
    .score2(score2)
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

////////////////
// VGA Output //
////////////////

logic [9:0] x;
logic [8:0] y;
logic active;

vgaTiming vgaTiming (
    .clk(clkVga),
    .rst(!locked),

    .x(x),
    .y(y),
    .active(active),

    .hSync(hSync),
    .vSync(vSync)
);

vgaDriver vgaDriver (
    .clk(clkVga),
    .rst(!locked),

    .x(x),
    .y(y),
    .active(active),

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