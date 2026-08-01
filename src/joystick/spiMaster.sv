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
logic sample, readByte, done;
logic [2:0] byteNum;
spiControl u_spiControl (
    .clk         (clk),
    .rst         (rst),

    // SPI slave interface
    .sclk        (sclk),
    .mosi        (mosi),
    .cs          (cs),

    // SPI master signals
    .sample      (sample),
    .readByte    (readByte),
    .byteNum     (byteNum),
    .done        (done)
);

// 8-bit shift register to hold data
logic [7:0] data;

// SPI mode 0, sample data on rising edge
always_ff @(posedge clk) begin
    if (sample) 
        data <= {data[6:0], miso};
end

// 5 bytes
logic [7:0] bytes[5];

// Read byte from shift register into RAM
always_ff @(posedge clk) begin
    if (readByte)
        bytes[byteNum] <= data;
end

// Update joystick readings once all bytes are read
always_ff @(posedge clk) begin
    if (rst) begin
        jstkX   <= '0;
        jstkY   <= '0;
        trigger <= '0;
        button  <= '0;
    end else if (done) begin
        jstkX   <= {bytes[1], bytes[0]};
        jstkY   <= {bytes[3], bytes[2]};
        trigger <= bytes[4][1];
        button  <= bytes[4][0];
    end
end
    
endmodule