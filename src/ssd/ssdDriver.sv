module ssdDriver (
    input  logic clk,
    input  logic rst,

    // 7-segment display interface
    output logic [6:0] seg,
    output logic       dp,
    output logic [3:0] an
);

// Time spent displaying each digit
localparam DisplayTime = 100000;

// State registers to control the current digit being displayed
logic [1:0] digit;
logic [16:0] timer;

// State transition logic
always_ff @(posedge clk) begin
    if (rst) begin
        digit <= '0;
        timer <= '0;
    end else if (timer == DisplayTime - 1) begin
        digit <= digit + 1'b1;
        timer <= '0;
    end else begin
        timer <= timer + 1'b1;
    end
end

// Display PONG on the 7-segment display
always_comb begin
    unique case (digit)
        2'd0: begin an = 4'b0111; seg = 7'b0001100; end
        2'd1: begin an = 4'b1011; seg = 7'b1000000; end
        2'd2: begin an = 4'b1101; seg = 7'b1001000; end
        2'd3: begin an = 4'b1110; seg = 7'b1000010; end
    endcase
end

// Decimal point is always off
assign dp = 1'b1;
    
endmodule