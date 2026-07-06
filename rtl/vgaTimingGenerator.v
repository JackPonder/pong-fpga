module vgaTimingGenerator 
#(
    parameter WIDTH = 640,
    parameter HEIGHT = 480,

    parameter H_FRONT_PORCH = 16,
    parameter H_SYNC_WIDTH = 96,      
    parameter H_BACK_PORCH = 48,
    
    parameter V_FRONT_PORCH = 10,
    parameter V_SYNC_WIDTH = 2,     
    parameter V_BACK_PORCH = 33
)(
    input clk,
    input clkEn,
    input rst, 

    output active, // In the visible area
    output hSync, // Horizontal sync, active high, marks the end of a horizontal line    
    output vSync, // Vertical sync, active high, marks the end of a vertical line    
    output [$clog2(WIDTH)-1:0] hPos,  
    output [$clog2(HEIGHT)-1:0] vPos
);
    
localparam H_SYNC_START = WIDTH + H_FRONT_PORCH;
localparam H_SYNC_END = H_SYNC_START + H_SYNC_WIDTH;
localparam H_LINE = H_SYNC_END + H_BACK_PORCH;

localparam V_SYNC_START = HEIGHT + V_FRONT_PORCH;
localparam V_SYNC_END = V_SYNC_START + V_SYNC_WIDTH;
localparam V_LINE = V_SYNC_END + V_BACK_PORCH;

// Count the position on the screen to decide the VGA regions    
reg [$clog2(H_LINE)-1:0] hCount = 0;    
reg [$clog2(V_LINE)-1:0] vCount = 0;    

always @(posedge clk or posedge rst) begin        
    if (rst) begin            
        hCount <= 0;            
        vCount <= 0;        
    end else if (clkEn) begin            
        if (hCount == H_LINE - 1) begin // End of horizontal line                
            hCount <= 0;                
            if (vCount == V_LINE - 1) // End of vertical line                    
                vCount <= 0;                
            else begin                    
                vCount <= vCount + 1;                
            end            
        end else begin                
            hCount <= hCount + 1; 
        end       
    end    
end

// Determine active regions    
assign active = (hCount < WIDTH) & (vCount < HEIGHT);      

// Output x and y coordinates     
assign hPos = active ? hCount : 0;  
assign vPos = active ? vCount : 0;

// Generate the sync signals based on their parameters    
assign hSync = (H_SYNC_START <= hCount) & (hCount < H_SYNC_END);    
assign vSync = (V_SYNC_START <= vCount) & (vCount < V_SYNC_END);

endmodule