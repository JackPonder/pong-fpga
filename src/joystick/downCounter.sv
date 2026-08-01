module downCounter #(
    parameter  MaxCount = 8,
    localparam Width = $clog2(MaxCount)
) (
    input  logic clk,
    input  logic rst,

    input  logic             load,
    input  logic [Width-1:0] value,
    output logic             zero
);

// Counter
logic [Width-1:0] count;

// Update count on each clock edge
always_ff @(posedge clk) begin
    if (rst)
        count <= MaxCount;
    else if (load)
        count <= value;
    else if (count > 0)
        count <= count - 1; 
end

// Set zero flag
assign zero = (count == 0);
    
endmodule