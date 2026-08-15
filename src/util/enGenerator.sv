module enGenerator #(
    parameter Width = 8
) (
    input  logic clk,
    input  logic rst,

    // Clock divisor
    input  logic [Width-1:0] divisor,

    // Generated enable signal
    output logic en
);

logic [Width-1:0] count;

always_ff @(posedge clk) begin
    if (rst) begin
        count <= '0;
        en <= 1'b0;
    end else if (count >= divisor - 1) begin
        count <= '0;
        en <= 1'b1;
    end else begin
        count <= count + 1'b1;
        en <= 1'b0;
    end
end

endmodule
