//Author: Daniel Roberto Garcia Miranda
//Institution: Universidad Mayor de San Andres, Physics Career, Cosmic Ray Group

  `ifndef HVSYNC_GENERATOR_H
`define HVSYNC_GENERATOR_H

/* Standard VGA sync generator
   Timing based on 640x480 @ 60Hz specs
*/

module hvsync_generator(
    input wire clk,           // Clock input
    input wire reset,         // Active high reset
    output reg hsync,         // Horizontal sync pulse
    output reg vsync,         // Vertical sync pulse
    output wire display_on,   // High when within visible area
    output reg [9:0] hpos,    // Horizontal pixel position
    output reg [9:0] vpos     // Vertical line position
);

  // Horizontal timing constants
  parameter H_DISPLAY       = 640; 
  parameter H_BACK          = 48;  
  parameter H_FRONT         = 16;  
  parameter H_SYNC          = 96;  
  // Vertical timing constants
  parameter V_DISPLAY       = 480; 
  parameter V_TOP           = 33;  
  parameter V_BOTTOM        = 10;  
  parameter V_SYNC          = 2;   

  // Derived timing boundaries
  parameter H_SYNC_START    = H_DISPLAY + H_FRONT;
  parameter H_SYNC_END      = H_DISPLAY + H_FRONT + H_SYNC - 1;
  parameter H_MAX           = H_DISPLAY + H_BACK + H_FRONT + H_SYNC - 1;
  parameter V_SYNC_START    = V_DISPLAY + V_BOTTOM;
  parameter V_SYNC_END      = V_DISPLAY + V_BOTTOM + V_SYNC - 1;
  parameter V_MAX           = V_DISPLAY + V_TOP + V_BOTTOM + V_SYNC - 1;

  // Status flags for counter rollover
  wire hmaxxed = (hpos == H_MAX) || reset;
  wire vmaxxed = (vpos == V_MAX) || reset;
  
  // Horizontal counter and sync generation
  always @(posedge clk) begin
    hsync <= ~(hpos >= H_SYNC_START && hpos <= H_SYNC_END);
    if(hmaxxed)
      hpos <= 0;
    else
      hpos <= hpos + 1;
  end

  // Vertical counter and sync generation
  always @(posedge clk) begin
    if(hmaxxed) begin
      vsync <= ~(vpos >= V_SYNC_START && vpos <= V_SYNC_END);
      if (vmaxxed)
        vpos <= 0;
      else
        vpos <= vpos + 1;
    end
  end
  
  // Output signal for active video region
  assign display_on = (hpos < H_DISPLAY) && (vpos < V_DISPLAY);

endmodule
`endif
