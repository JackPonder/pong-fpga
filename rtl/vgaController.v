module vgaController
(
    input clk,
    input rst,
    output hSync,
    output vSync,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue
);

localparam WIDTH = 1920;
localparam HEIGHT = 1080; 

wire active;
wire [$clog2(WIDTH)-1:0] x;
wire [$clog2(HEIGHT)-1:0] y;

vgaTimingGenerator #(
    .WIDTH(WIDTH),
    .HEIGHT(HEIGHT)
) display (
    .clk(clk),
    .rst(rst),
    .active(active),
    .hSync(hSync),
    .vSync(vSync),
    .x(x),
    .y(y)
);

localparam bgColor = 12'h5AE;
localparam fgColor = 12'hFFF;

wire [11:0] colorData;
assign colorData = bgColor;

wire [11:0] colorOut;
assign colorOut = active ? colorData : 12'h000;

assign {vgaRed, vgaGreen, vgaBlue} = colorOut;

endmodule
