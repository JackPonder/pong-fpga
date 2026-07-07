module top
(
    input clk,
    input btnC,
    input [15:0] sw,

    output [15:0] led,
    output [3:0] vgaRed, 
    output [3:0] vgaGreen, 
    output [3:0] vgaBlue,
    output hSync, 
    output vSync
);

wire rst = btnC;

vgaController controller (
    .clk(clk),
    .rst(rst),
    .score1(sw[15:12]),
    .score2(sw[3:0]),
    .hSync(hSync),
    .vSync(vSync),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue)
);

assign led = sw;

endmodule