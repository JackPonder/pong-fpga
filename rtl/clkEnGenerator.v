module clkEnGenerator 
#(
    parameter DIVISOR = 4
)(
    input clk,
    input rst,
    output reg clkEn
);

reg [$clog2(DIVISOR)-1:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        clkEn <= 0;
    end else if (count == DIVISOR - 1) begin
        count <= 0;
        clkEn <= 1;
    end else begin
        count <= count + 1;
        clkEn <= 0;
    end
end
    
endmodule