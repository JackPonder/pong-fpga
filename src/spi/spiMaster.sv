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
logic readBit, readByte, done;
logic [2:0] byteNum;
spiControl spiControl (
    .clk(clk),
    .rst(rst),

    .sclk(sclk),
    .mosi(mosi),
    .cs(cs),

    .readBit(readBit),
    .readByte(readByte),
    .byteNum(byteNum),
    .done(done)
);

// 8-bit shift register to hold input data
logic [7:0] data;

// Read bits from MISO
always_ff @(posedge clk) begin
    if (readBit) 
        data <= {data[6:0], miso};
end

// 5-byte data packet
logic [7:0] bytes[5];

// Read byte from shift register once 8 bits are read
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