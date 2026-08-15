module counter #(
    parameter Max = 8,
    localparam Width = $clog2(Max)
) (
    input  logic             clk,
    input  logic             en,
    input  logic             rst,
    output logic [Width-1:0] count
);

always_ff @(posedge clk) begin
    if (rst)
        count <= '0;
    else if (en)
        count <= (count < Max - 1) ? count + 1'b1 : '0;
end

endmodule
