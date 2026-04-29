//Author: Daniel Roberto Garcia Miranda
//Institution: Universidad Mayor de San Andres, Physics Career, Cosmic Rays Group
`timescale 1ns/1ps

// Simple Vivado testbench for waveform inspection

module tb_vivado;

  reg clk;
  reg rst_n;
  reg [7:0] ui_in;
  reg [7:0] uio_in;

  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  tt_um_dual_nyancat dut (
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .ena(1'b1),
    .clk(clk),
    .rst_n(rst_n)
  );

  // 25 MHz approx clock
  always #20 clk = ~clk;

  initial begin
    clk = 0;
    rst_n = 0;
    ui_in = 0;   // start in NORMAL mode
    uio_in = 0;

    #100;
    rst_n = 1;

    // run normal mode
    #2000000;

    // switch to DEVIL mode
    ui_in[0] = 1;

    #2000000;

    $finish;
  end

endmodule
