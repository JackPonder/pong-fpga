module top
(
    input clk,
    output [3:0] vgaRed, 
    output [3:0] vgaGreen, 
    output [3:0] vgaBlue,
    output hSync, 
    output vSync
);

wire clkPixel;
clkWiz pll (
    .clkIn(clk),
    .clkOut(clkPixel),
    .reset(1'b0)
);

vgaController controller (
    .clk(clkPixel),
    .rst(1'b0),
    .hSync(hSync),
    .vSync(vSync),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue)
);

endmodule