# Devil Nyan Cat (VGA + Audio)

A real-time hardware VGA animation of Nyan Cat with a toggleable "Devil Mode" transformation.

## How it works

This project generates a VGA animation and audio synthesis using pure Verilog, optimized for a single Tiny Tapeout tile.

- **VGA Timing:** Uses `hvsync_generator` to produce 640x480 @ 60Hz timing (25.175 MHz).
- **Rendering:** Calculates pixels on the fly, including the rainbow trail, starfield via LFSR, and sprite animation.
- **Devil Mode:** Controlled by `ui_in[0]`. When high, it applies a real-time palette mutation (boosting Red, masking Green, and inverting Blue) for a corrupted aesthetic.
- **Audio:** 1-bit PWM engine generating square waves for melody and bass, output on `uio_out[7]`.

## How to test

1. **Simulation:** Run `make test` to verify sync signals and mode switching via Cocotb.
2. **Hardware:** - Set clock to **25.175 MHz**.
    - Toggle **ui_in[0]** to switch between Normal and Devil modes.
    - Connect a VGA monitor to the `uo_out` pins.

## Pinout Mapping

| Pin | Function | Description |
| --- | --- | --- |
| **ui_in[0]** | `mode_sel` | 0: Normal Cat / 1: Devil Cat |
| **uo_out[7]** | `hsync` | Horizontal Sync |
| **uo_out[3]** | `vsync` | Vertical Sync |
| **uo_out[6, 2]** | `blue` | Blue Color bits (MSB, LSB) |
| **uo_out[5, 1]** | `green` | Green Color bits (MSB, LSB) |
| **uo_out[4, 0]** | `red` | Red Color bits (MSB, LSB) |
| **uio_out[7]** | `audio` | 1-bit PWM Audio Output |

## External Hardware

* **TinyVGA Pmod:** Connect to the `uo_out[7:0]` header.
* **Audio:** Connect a piezo buzzer or low-pass RC filter to `uio[7]`.