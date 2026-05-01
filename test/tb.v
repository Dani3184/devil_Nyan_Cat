// Author: Daniel Roberto Garcia Miranda (Dani3184)
// Institution: Universidad Mayor de San Andrés, Physics Career, Cosmic Ray Group
`default_nettype none
`timescale 1ns / 1ps

/* This testbench instantiates the module and makes signals accessible 
   for the cocotb test.py.
*/
module tb ();

  // Dump signals for GTKWave analysis
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Signals for the project
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // --- POWER AND GROUND WIRES ---
  wire vcc = 1'b1;
  wire gnd = 1'b0;

  // Instantiating the Devil Nyan Cat module
  tt_um_devil_nyancat user_project (
`ifdef GL_TEST
      .VPWR(vcc),      // Connected to wire vcc
      .VGND(gnd),      // Connected to wire gnd
`endif
      .ui_in   (ui_in),
      .uo_out  (uo_out),
      .uio_in  (uio_in),
      .uio_out (uio_out),
      .uio_oe  (uio_oe),
      .ena     (ena),
      .clk     (clk),
      .rst_n   (rst_n)
  );

endmodule