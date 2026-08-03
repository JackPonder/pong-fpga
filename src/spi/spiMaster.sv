module spiMaster (
    input  logic clk,
    input  logic rst,

    // SPI slave interface
    output logic sclk,
    output logic mosi,
    input  logic miso,
    output logic cs,

    // Joystick data
    output logic [9:0] jstkX,
    output logic [9:0] jstkY,
    output logic       trigger,
    output logic       button
);

// SPI controller
logic sample, done;
spiControl spiControl (
    .clk(clk),
    .rst(rst),

    .sclk(sclk),
    .cs(cs),

    .sample(sample),
    .done(done)
);

// 5-byte shift register to hold input packet
logic [39:0] packet;

// Read bits from MISO into shift register
always_ff @(posedge clk) begin
    if (sample) 
        packet <= {packet[38:0], miso};
end

// Update joystick data once entire packet is read
always_ff @(posedge clk) begin
    if (rst) begin
        jstkX <= '0;
        jstkY <= '0;
        trigger <= '0;
        button <= '0;
    end else if (done) begin
        jstkX <= {packet[25:24], packet[39:32]};
        jstkY <= {packet[9:8], packet[23:16]};
        trigger <= packet[1];
        button <= packet[0];
    end
end

// Hold MOSI low
assign mosi = '0;

endmodule