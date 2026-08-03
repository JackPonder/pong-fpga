module spiControl (
    input  logic clk,
    input  logic rst,

    // SPI slave interface
    output logic sclk,
    output logic cs,

    // SPI master interface
    output logic sample,
    output logic done
);

// Time spent in each state
localparam TimeIdle  = 2500;
localparam TimeWait  = 1500;
localparam TimeWrite = 50;
localparam TimeRead  = 50;
localparam TimeDelay = 1000;
localparam TimeDone  = 100;

// State encodings
typedef enum logic [2:0] {  
    StIdle,
    StWait,
    StWrite,
    StRead,
    StDelay,
    StDone
} spiState;

// State variables
spiState state, nextState;
logic [2:0] bitNum, nextBitNum;
logic [2:0] byteNum, nextByteNum;
logic [11:0] timer;

// Update state on each clock edge
always_ff @(posedge clk) begin
    if (rst) begin
        state <= StIdle;
        bitNum <= '0;
        byteNum <= '0;
        timer <= '0;
    end else begin
        state <= nextState;
        bitNum <= nextBitNum;
        byteNum <= nextByteNum;
        timer <= (state == nextState) ? (timer + 1'b1) : '0;
    end
end

// Next state logic
always_comb begin
    // Default values
    nextState = state;
    nextBitNum = bitNum;
    nextByteNum = byteNum;

    // State transitions
    unique case (state)
        StIdle:
        if (timer == TimeIdle - 1) begin
            nextState = StWait;
        end

        StWait:
        if (timer == TimeWait - 1) begin
            nextState = StWrite;
        end

        StWrite: 
        if (timer == TimeWrite - 1) begin
            nextState = StRead;
        end

        StRead: 
        if (timer == TimeRead - 1) begin
            if (bitNum < 7) begin
                nextState = StWrite; 
                nextBitNum = bitNum + 1'b1;
            end else if (byteNum < 4) begin
                nextState = StDelay;
                nextBitNum = '0;
                nextByteNum = byteNum + 1'b1;
            end else begin
                nextState = StDone;
                nextBitNum = '0;
                nextByteNum = '0;
            end
        end

        StDelay: 
        if (timer == TimeDelay - 1) begin
            nextState = StWrite;
        end

        StDone:
        if (timer == TimeDone - 1) begin
            nextState = StIdle;
        end
    endcase
end

// Output logic
always_comb begin
    sclk = (state == StRead);
    cs = (state == StIdle);
    sample = (state == StRead) && (timer == '0);
    done = (state == StDone) && (timer == '0);
end

endmodule