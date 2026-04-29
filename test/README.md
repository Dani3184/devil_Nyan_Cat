![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Devil Nyan Cat VGA

A 1x1 tile VGA Nyan Cat with integrated sound and a toggleable "Devil Mode" (palette mutation).

- [Read the documentation for project](docs/info.md)

![preview](docs/preview.png)

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

## Project Description

This project generates a hardware-based VGA animation of Nyan Cat. It includes a real-time color transformation engine (Devil Mode) activated via `ui_in[0]`.

* **1x1 Tile:** Optimized to fit in a single tile.
* **VGA Output:** 640x480 @ 60Hz.
* **Audio:** 1-bit PWM audio synthesis.
* **Compatibility:** Designed for TinyVGA Pmod.