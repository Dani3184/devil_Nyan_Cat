# Devil Nyan Cat VGA (Tiny Tapeout)

![](../../workflows/gds/badge.svg)
![](../../workflows/docs/badge.svg)
![](../../workflows/test/badge.svg)
![](../../workflows/fpga/badge.svg)

## Overview

This project implements a VGA animation of Nyan Cat with an additional "devil mode" visual effect and a simple PWM audio output.

The design is intended for Tiny Tapeout FPGA/VGA demonstrations.

## Features

- VGA 640x480 output using a hardware sync generator
- Nyan Cat animation with rainbow background
- Devil mode (activated via `ui_in[0]`)
  - Darkened color palette
  - Red blinking effects
  - Red eye highlights
- Simple PWM audio tone output on `uio[7]`

## Hardware mapping

- `uo[7:0]`: VGA output signals (RGB + HSYNC + VSYNC)
- `uio[7]`: Audio PWM output
- `ui[0]`: Mode select (0 = normal, 1 = devil mode)

## Clock

- 25 MHz target clock

## Files

- `tt_um_dual_nyancat.v` → main design
- `hvsync_generator.v` → VGA timing generator
- `tb.v` → TinyTapeout testbench
- `tb_vivado.v` → Vivado simulation testbench
