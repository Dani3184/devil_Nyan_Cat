//Author: Daniel Roberto Garcia Miranda
//Institution: Universidad Mayor de San Andres, Physics Career, Cosmic Ray Group
`default_nettype none

module tt_um_dual_nyancat(
  input  wire [7:0] ui_in,
  output wire [7:0] uo_out,
  input  wire [7:0] uio_in,
  output wire [7:0] uio_out,
  output wire [7:0] uio_oe,
  input  wire       ena,
  input  wire       clk,
  input  wire       rst_n
);

  // =========================================================
  // VGA SIGNALS
  // =========================================================
  wire hsync, vsync;
  reg [1:0] R, G, B;
  wire video_active;
  wire [9:0] pix_x, pix_y;

  // Output mapping (TinyVGA PMOD format)
  assign uo_out = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};

  // =========================================================
  // AUDIO OUTPUT (PWM)
  // =========================================================
  assign uio_out[7] = audio_pwm;  // audio output
  assign uio_out[6:0] = 0;
  assign uio_oe[7] = 1;
  assign uio_oe[6:0] = 0;

  wire _unused_ok = &{ena, uio_in};

  // =========================================================
  // VGA SYNC GENERATOR
  // =========================================================
  hvsync_generator sync_gen(
    .clk(clk),
    .reset(~rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(video_active),
    .hpos(pix_x),
    .vpos(pix_y)
  );

  // =========================================================
  // FRAME CONTROL
  // =========================================================
  reg [7:0] frame_count;
  wire devil_mode = ui_in[0];

  // =========================================================
  // SIMPLE PATTERN (lighter than full ROM nyan)
  // =========================================================
  wire body = (pix_x > 200 && pix_x < 350 && pix_y > 200 && pix_y < 300);
  wire rainbow = (pix_x < 200 && pix_y > 220 && pix_y < 260);

  // =========================================================
  // AUDIO GENERATOR (simple square tone)
  // =========================================================
  reg [15:0] audio_counter;
  reg audio_pwm;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      audio_counter <= 0;
      audio_pwm <= 0;
    end else begin
      audio_counter <= audio_counter + 1;

      // simple tone (different pitch per mode)
      if (devil_mode)
        audio_pwm <= audio_counter[12];  // lower tone
      else
        audio_pwm <= audio_counter[10];  // higher tone
    end
  end

  // =========================================================
  // MAIN RENDER
  // =========================================================
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      frame_count <= 0;
      R <= 0; G <= 0; B <= 0;
    end else begin

      if (pix_x == 0 && pix_y == 0)
        frame_count <= frame_count + 1;

      if (video_active) begin

        if (!devil_mode) begin
          // ================= NORMAL MODE =================
          if (body) begin
            R <= 2; G <= 2; B <= 2; // gray cat
          end else if (rainbow) begin
            R <= frame_count[2:1];
            G <= ~frame_count[2:1];
            B <= 2;
          end else begin
            R <= 0; G <= 0; B <= 1; // blue background
          end

        end else begin
          // ================= DEVIL MODE =================
          if (body) begin
            R <= 3; G <= 0; B <= 0; // red cat
          end else if (rainbow) begin
            R <= 3;
            G <= 0;
            B <= frame_count[2:1]; // purple-ish trail
          end else begin
            R <= 0; G <= 0; B <= 0; // black background
          end

          // blinking effect
          if (!frame_count[4])
            R <= 0;

          // red eyes
          if (pix_x > 260 && pix_x < 280 && pix_y > 230 && pix_y < 250) begin
            R <= 3; G <= 0; B <= 0;
          end
        end

      end else begin
        R <= 0; G <= 0; B <= 0;
      end
    end
  end

endmodule
