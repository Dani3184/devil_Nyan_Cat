# Devil Nyan Cat Testbench

This is the testbench for the `tt_um_devil_nyancat` project, developed by Daniel Roberto Garcia Miranda (Dani3184). It uses cocotb to drive the DUT and check the VGA/Audio outputs.

## Setting up

The Makefile is already configured to point to the Devil Nyan Cat sources.

The `tb.v` has been updated to instantiate `tt_um_devil_nyancat`.

## How to run

To run the RTL simulation:


```sh
make -B
```

To run gatelevel simulation, first harden your project and copy `../runs/wokwi/results/final/verilog/gl/{your_module_name}.v` to `gate_level_netlist.v`.

Then run:

```sh
make -B GATES=yes
```

## How to view the VCD file

```sh
gtkwave tb.vcd tb.gtkw
```

Developer: Daniel Roberto Garcia Miranda - Cosmic Rays Group (UMSA)