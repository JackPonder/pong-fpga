module ballSpeed (
    input  logic clk,
    input  logic rst,

    // Collision flags
    input  logic collision1,
    input  logic collision2,

    // Hit locations
    input  logic [4:0] hitLocation1,
    input  logic [4:0] hitLocation2,

    // Divisors for ball position enable signals
    output logic [22:0] divisorEnX,
    output logic [22:0] divisorEnY
);

// Next state variables
logic [22:0] newDivisorEnX;
logic [22:0] newDivisorEnY;

// Update X and Y speed on collisions
always_ff @(posedge clk) begin
    if (rst) begin
        divisorEnX <= 23'd200069;
        divisorEnY <= 23'd7640310;
    end else if (collision1 || collision2) begin
        divisorEnX <= newDivisorEnX;
        divisorEnY <= newDivisorEnY;
    end
end

// Lookup table for new X and Y divisors based on point where ball hits paddle
always_comb begin
    unique case (collision1 ? hitLocation1 : hitLocation2) inside
        [0:1]:   begin newDivisorEnX = 23'd200069; newDivisorEnY = 23'd7640310; end
        [2:3]:   begin newDivisorEnX = 23'd200618; newDivisorEnY = 23'd2549099; end
        [4:5]:   begin newDivisorEnX = 23'd201726; newDivisorEnY = 23'd1532260; end
        [6:7]:   begin newDivisorEnX = 23'd203406; newDivisorEnY = 23'd1097481; end
        [8:9]:   begin newDivisorEnX = 23'd205683; newDivisorEnY = 23'd856732; end
        [10:11]: begin newDivisorEnX = 23'd208590; newDivisorEnY = 23'd704187; end
        [12:13]: begin newDivisorEnX = 23'd212170; newDivisorEnY = 23'd599149; end
        [14:15]: begin newDivisorEnX = 23'd216478; newDivisorEnY = 23'd522625; end
        [16:17]: begin newDivisorEnX = 23'd221586; newDivisorEnY = 23'd464564; end
        [18:19]: begin newDivisorEnX = 23'd227579; newDivisorEnY = 23'd419148; end
        [20:21]: begin newDivisorEnX = 23'd234566; newDivisorEnY = 23'd382776; end
        [22:23]: begin newDivisorEnX = 23'd242681; newDivisorEnY = 23'd353103; end
        [24:25]: begin newDivisorEnX = 23'd252094; newDivisorEnY = 23'd328536; end
        [26:27]: begin newDivisorEnX = 23'd263017; newDivisorEnY = 23'd307954; end
        [28:29]: begin newDivisorEnX = 23'd275720; newDivisorEnY = 23'd290548; end
        default: begin newDivisorEnX = 23'd290548; newDivisorEnY = 23'd275720; end
    endcase
end
    
endmodule