module vgaTimingGenerator 
#(
    parameter WIDTH = 1920,
    parameter HEIGHT = 1080 
)(
    input clk,  
    input rst, 
    output active, // In the visible area    
    output screenEnd, // High for one cycle between frames    
    output hSync, // Horizontal sync, active high, marks the end of a horizontal line    
    output vSync, // Vertical sync, active high, marks the end of a vertical line    
    output [$clog2(WIDTH)-1:0] x,  
    output [$clog2(HEIGHT)-1:0] y
);

localparam H_FRONT_PORCH = 88;
localparam H_SYNC_WIDTH = 44;       
localparam H_BACK_PORCH = 148;
    
localparam H_SYNC_START = WIDTH + H_FRONT_PORCH;
localparam H_SYNC_END = H_SYNC_START + H_SYNC_WIDTH;
localparam H_LINE = H_SYNC_END + H_BACK_PORCH;
    
localparam V_FRONT_PORCH = 4;
localparam V_SYNC_WIDTH = 5;       
localparam V_BACK_PORCH = 36;

localparam V_SYNC_START = HEIGHT + V_FRONT_PORCH;
localparam V_SYNC_END = V_SYNC_START + V_SYNC_WIDTH;
localparam V_LINE = V_SYNC_END + V_BACK_PORCH;

// Count the position on the screen to decide the VGA regions    
reg [$clog2(H_LINE)-1:0] hPos = 0;    
reg [$clog2(V_LINE)-1:0] vPos = 0;    

always @(posedge clk or posedge rst) begin        
    if (rst) begin            
        hPos <= 0;            
        vPos <= 0;        
    end else begin            
        if (hPos == H_LINE - 1) begin // End of horizontal line                
            hPos <= 0;                
            if (vPos == V_LINE - 1) // End of vertical line                    
                vPos <= 0;                
            else begin                    
                vPos <= vPos + 1;                
            end            
        end else begin                
            hPos <= hPos + 1; 
        end       
    end    
end

// Determine active regions    
wire activeX, activeY;    
assign activeX = (hPos < WIDTH); 
assign activeY = (vPos < HEIGHT);     
assign active = activeX & activeY;      

// Output x and y coordinates     
assign x = activeX ? hPos : 0;  
assign y = activeY ? vPos : 0;

// Screen ends when x and y reach their ends     
assign screenEnd = (vPos == (V_LINE - 1)) && (hPos == (H_LINE - 1)); 

// Generate the sync signals based on their parameters    
assign hSync = (H_SYNC_START <= hPos) && (hPos < H_SYNC_END);    
assign vSync = (V_SYNC_START <= vPos) && (vPos < V_SYNC_END);

endmodule