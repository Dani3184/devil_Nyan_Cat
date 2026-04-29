//Author: Daniel Roberto Garcia Miranda
//Institution: Universidad Mayor de San Andres, Physics Career, Cosmic Ray Group
`default_nettype none

module tt_um_devil_nyancat(
  input  wire [7:0] ui_in,    // ui_in[0] toggles Good (0) / Evil (1)
  output wire [7:0] uo_out,   // VGA outputs
  input  wire [7:0] uio_in,   // Bidirectional inputs
  output wire [7:0] uio_out,  // Bidirectional outputs
  output wire [7:0] uio_oe,   // Output enables
  input  wire       ena,      // Design enable
  input  wire       clk,      // System clock
  input  wire       rst_n     // Active low reset
);

  // Control and video internal signals
  wire evil_mode = ui_in[0];
  wire hsync, vsync, video_active;
  wire [9:0] pix_x, pix_y;
  reg [1:0] R, G, B;

  // VGA PMOD mapping: {hsync, B0, G0, R0, vsync, B1, G1, R1}
  assign uo_out = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};
  
  // Unused IO configuration
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // Instantiate sync generator
  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(~rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(video_active),
    .hpos(pix_x),
    .vpos(pix_y)
  );

  // Placeholder wires for original cat colors (from your .hex logic)
  wire [3:0] r_base, g_base, b_base; 
  
  // --- COLOR TRANSFORMATION ---
  // If evil_mode is active, we force high Red and invert Blue/Green
  wire [3:0] r_final = evil_mode ? (r_base | 4'hE) : r_base;
  wire [3:0] g_final = evil_mode ? (g_base & 4'h1) : g_base;
  wire [3:0] b_final = evil_mode ? (b_base ^ 4'hF) : b_base;

  // Synchronous output logic
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      {R, G, B} <= 6'b0;
    end else begin
      // Apply color only when in the visible video area
      R <= video_active ? r_final[3:2] : 2'b0;
      G <= video_active ? g_final[3:2] : 2'b0;
      B <= video_active ? b_final[3:2] : 2'b0;
    end
  end

  // Clean up unused signal warnings
  wire _unused = &{ena, ui_in[7:1], uio_in};

endmodule
