module vgaTiming (
    input  logic clk,
    input  logic rst,

    // Screen position
    output logic [9:0] x,
    output logic [8:0] y,
    output logic       active,

    // Sync signals
    output logic hSync,
    output logic vSync
);

// Timing parameters for 640x480 resolution at 60 Hz
localparam HorzActive = 640;
localparam HorzFrontPorch = 16;
localparam HorzSync = 96;
localparam HorzBackPorch = 48;

localparam VertActive = 480;
localparam VertFrontPorch = 10;
localparam VertSync = 2;
localparam VertBackPorch = 33;

localparam HorzSyncStart = HorzActive + HorzFrontPorch;
localparam HorzSyncEnd = HorzSyncStart + HorzSync;
localparam HorzTotal = HorzSyncEnd + HorzBackPorch;

localparam VertSyncStart = VertActive + VertFrontPorch;
localparam VertSyncEnd = VertSyncStart + VertSync;
localparam VertTotal = VertSyncEnd + VertBackPorch;

// Count the position on the screen to determine the current VGA region
logic [9:0] hCount;
logic [9:0] vCount;

// Next position logic
always_ff @(posedge clk) begin
    if (rst) begin
        hCount <= '0;
        vCount <= '0;
    end else begin
        if (hCount == HorzTotal - 1) begin // End of horizontal line
            hCount <= '0;
            if (vCount == VertTotal - 1) begin // End of vertical line
                vCount <= '0;
            end else begin
                vCount <= vCount + 1'b1;
            end
        end else begin
            hCount <= hCount + 1'b1;
        end
    end
end

// Determine if position is in the active region
assign active = (hCount < HorzActive) && (vCount < VertActive);

// Output position on screen
assign x = active ? hCount : '0;
assign y = active ? vCount : '0;

// Generate sync signals (active low)
assign hSync = (hCount < HorzSyncStart) || (hCount >= HorzSyncEnd);
assign vSync = (vCount < VertSyncStart) || (vCount >= VertSyncEnd);

endmodule