//Author: Daniel Roberto Garcia Miranda
//Institution: Universidad Mayor de San Andres, Physics Career, Cosmic Ray Group
`default_nettype none
`timescale 1ns / 1ps

/* Simple testbench to instantiate the user project 
   and dump waveform data for GTKWave.
*/

module tb ();
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Instantiate the project with the new module name
  tt_um_devil_nyancat user_project (
`ifdef GL_TEST
      .VPWR(1'b1), .VGND(1'b0),
`endif
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );
endmodule
