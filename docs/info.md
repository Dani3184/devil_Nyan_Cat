# Devil Nyan Cat (VGA + Audio)

A real-time VGA animation of Nyan Cat, modified into a corrupted "Devil Mode" version.

## How it works

This project generates a hardware-based VGA animation without the need for a CPU. It utilizes a custom rendering engine designed to fit within a single Tiny Tapeout tile.

- **VGA Timing Generator:** A dedicated `hvsync_generator` module produces precise horizontal (`hsync`) and vertical (`vsync`) synchronization signals, along with pixel coordinates (x, y) for a 640x480 @ 60Hz resolution.
- **Rendering Engine:** The main module calculates pixel colors on the fly based on:
  - Sprite data (conceptually driven by internal logic or memory).
  - A dynamic rainbow trail animation.
  - Frame-based movement and a flickering background effect.

### Devil Mode Modifications
To achieve the "horror/glitch" aesthetic, the standard Nyan Cat color palette has been mathematically mutated:
- **Green Channel:** Significantly reduced to create a dark, sickly tone.
- **Blue Channel:** Inverted relative to the frame counter for a "negative film" effect.
- **Red Channel:** Boosted to emphasize an aggressive, "evil" appearance.
- **Visual Artifacts:** Added a frame-synchronized flicker and high-contrast dithering to simulate a corrupted video signal.

## Sound (Experimental)

The design includes a 1-bit audio synthesis engine:
- **Synthesis:** Square wave generation with frequency modulation tied to the animation state.
- **Output:** The audio signal is routed to `uio[7]`. 
- **Hardware:** Can be monitored using a simple piezo buzzer or a low-pass RC filter connected to an amplifier.

## How to test

### 1. Simulation (Vivado / Verilog)
Run a behavioral simulation and observe the `uo_out` bus. You should see the `hsync` and `vsync` pulses (bits 0 and 4 in some mappings) toggling, with RGB data changing between pulses.

### 2. Cocotb (Tiny Tapeout Environment)
Run the following command in your project root:

```sh
make -B
``` 

Check that the `hsync` and `vsync` timings remain stable and that the internal frame counter increments correctly.

### 3. Hardware Implementation
This project is compatible with the **TinyVGA Pmod**.

* **Video:** Connect a VGA monitor to the outputs on `uo_out[7:0]`.
* **Audio:** Connect a small speaker or headphones (with a current-limiting resistor) to `uio[7]`.

## Pinout Mapping

* **uo_out[7:0]:** VGA Signals (Red, Green, Blue, Syncs).
* **uio[7]:** 1-bit PWM/Square-wave Audio Output.
* **ui_in[0]:** Optional frequency shift for audio.
