module counter
#(
    parameter MAX_COUNT = 8
)(
    input clk,
    input clkEn,
    input rst,

    output reg [$clog2(MAX_COUNT)-1:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
    end else if (clkEn) begin
        if (count == MAX_COUNT - 1) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule