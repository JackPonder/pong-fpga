module top
(
    input clk,
    output [3:0] vgaRed, 
    output [3:0] vgaGreen, 
    output [3:0] vgaBlue,
    output hSync, 
    output vSync
);

wire rst;
assign rst = 0;

wire clkEn;
clkEnGenerator #(
    .DIVISOR(4)
) gen (
    .clk(clk),
    .clkEn(clkEn),
    .reset(rst)
);

vgaController controller (
    .clk(clk),
    .clkEn(clkEn),
    .rst(rst),
    .hSync(hSync),
    .vSync(vSync),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue)
);

endmodule