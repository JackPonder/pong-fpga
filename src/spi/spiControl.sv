module spiControl (
    input  logic clk,
    input  logic rst,

    // SPI slave interface
    output logic sclk,
    output logic cs,

    // SPI master interface
    output logic [2:0] byteNum,
    output logic       readBit,
    output logic       readByte,
    output logic       done
);

// Time spent in each state
localparam TimeIdle  = 2500;
localparam TimeWait  = 1500;
localparam TimeWrite = 50;
localparam TimeRead  = 50;
localparam TimeDelay = 1000;

// State encodings
typedef enum logic [2:0] {  
    StIdle,
    StWait,
    StWrite,
    StRead,
    StDelay
} spiState;

// State variables
spiState state, nextState;
logic [3:0] bitNum, nextBitNum;
logic [2:0] nextByteNum;
logic [11:0] count, nextCount;

// Update state on clock edge
always_ff @(posedge clk) begin
    if (rst) begin
        state <= StIdle;
        bitNum <= '0;
        byteNum <= '0;
        count <= '0;
    end else begin
        state <= nextState;
        bitNum <= nextBitNum;
        byteNum <= nextByteNum;
        count <= nextCount;
    end
end

// Next state logic
always_comb begin
    // Default values
    nextState = state;
    nextBitNum = bitNum;
    nextByteNum = byteNum;
    nextCount = count + 1'b1;

    // State transitions
    unique case (state)
        StIdle:
        if (count == TimeIdle - 1) begin
            nextState = StWait;
            nextCount = '0;
        end

        StWait:
        if (count == TimeWait - 1) begin
            nextState = StWrite;
            nextCount = '0;
        end

        StWrite: 
        if (count == TimeWrite - 1) begin
            if (bitNum < 8) begin
                nextState = StRead;
                nextBitNum = bitNum + 1'b1;
            end else if (byteNum < 4) begin
                nextState = StDelay;
                nextBitNum = '0;
                nextByteNum = byteNum + 1'b1;
            end else begin
                nextState = StIdle;
                nextBitNum = '0;
                nextByteNum = '0;
            end
            nextCount = '0;
        end

        StRead: 
        if (count == TimeRead - 1) begin
            nextState = StWrite; 
            nextCount = '0;
        end

        StDelay: 
        if (count == TimeDelay - 1) begin
            nextState = StWrite;
            nextCount = '0;
        end
    endcase
end

// Output logic
assign sclk = (state == StRead);
assign cs = (state == StIdle);

assign readBit = (state == StRead) && (count == '0);
assign readByte = (state == StWrite) && (count == '0) && (bitNum == 8);
assign done = (state == StIdle) && (count == '0);

endmodule