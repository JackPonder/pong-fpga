module spiControl (
    input  logic clk,
    input  logic rst,

    // SPI slave signals
    output logic sclk,
    output logic mosi,
    output logic cs,

    // SPI master signals
    output logic       sample,
    output logic       readByte,
    output logic [2:0] byteNum,
    output logic       done
);

// State encodings
typedef enum logic [2:0] {  
    StateIdle,
    StateWait,
    StateWrite,
    StateRead,
    StateDelay
} stateType;

// State and next state variables
stateType state, nextState;
logic [3:0] bitNum, nextBitNum;
logic [2:0] nextByteNum;

// Update state on clock edge
always_ff @(posedge clk) begin
    if (rst) begin
        state <= StateIdle;
        bitNum <= '0;
        byteNum <= '0;
    end else begin
        state <= nextState;
        bitNum <= nextBitNum;
        byteNum <= nextByteNum;
    end
end

// Counter
logic load, zero;
logic [11:0] value;
downCounter #(2500) counter (
    .clk         (clk),
    .rst         (rst),
    .load        (load),
    .value       (value),
    .zero        (zero)
);

// Next state logic
always_comb begin
    // Default values
    nextState = state;
    load = '0;
    value = '0;
    nextBitNum = bitNum;
    nextByteNum = byteNum;
    sample = '0;
    readByte = '0;
    done = '0;

    // Move to next state only if counter is finished
    if (zero) begin
        load = 1'b1;
        unique case (state)
            StateIdle: begin 
                nextState = StateWait; 
                value = 12'd1500;
                nextBitNum = '0;
                nextByteNum = '0;
            end
            StateWait: begin 
                nextState = StateWrite; 
                value = 12'd50;
            end
            StateWrite: begin
                if (bitNum < 8) begin
                    nextState = StateRead;
                    value = 12'd50;
                    sample = 1'b1;
                end else begin
                    nextState = StateDelay;
                    value = 12'd1000;
                    readByte = 1'b1;
                end
            end
            StateRead: begin 
                nextBitNum = bitNum + 1'b1;
                nextState = StateWrite; 
                value = 12'd50; 
            end
            StateDelay: begin 
                nextBitNum = '0;
                nextByteNum = byteNum + 1'b1;
                if (byteNum < 4) begin
                    nextState = StateWrite;
                    value = 12'd50; 
                end else begin
                    nextState = StateIdle;
                    value = 12'd2500;
                    done = 1'b1;
                end
            end
        endcase 
    end
end

// Output logic
assign sclk = (state == StateRead);
assign mosi = 1'b0;
assign cs = (state == StateIdle);
    
endmodule