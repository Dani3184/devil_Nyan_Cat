# Author: Daniel Roberto Garcia Miranda (Dani3184)
# Institution: Universidad Mayor de San Andrés, Physics Career, Cosmic Ray Group
# Project: Devil Nyan Cat VGA Generator

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Devil Nyan Cat Test")

    # VGA Clock: ~25.175 MHz -> Period approx 39.72ns
    clock = Clock(dut.clk, 39.72, units="ns")
    cocotb.start_soon(clock.start())

    # --- Reset Sequence ---
    dut._log.info("Resetting design...")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    # Wait 10 cycles to ensure global reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut._log.info("Reset complete.")

    # --- Test Behavior ---
    dut._log.info("Validating VGA Sync Signals")

    # Skip the first full scanline to allow pipeline stabilization
    # Calculation: 640 active + 16 front + 96 sync + 48 back = 800 cycles
    await ClockCycles(dut.clk, 800)

    # Validate that sync signals are high during active video (Active Low signals)
    # uo_out[7] -> HSync, uo_out[3] -> VSync
    assert dut.uo_out[7].value == 1, "Error: hsync should be high during active video"
    assert dut.uo_out[3].value == 1, "Error: vsync should be high during active video"

    # Test HSync timing:
    # Wait for 640 (active) + 16 (front porch) + 2 cycles of safety margin for latency
    await ClockCycles(dut.clk, 640 + 16 + 2)
    
    # HSync should be low now (sync pulse active)
    assert dut.uo_out[7].value == 0, f"Error: hsync pulse failed to trigger. Got {dut.uo_out[7].value}"

    # Wait for the sync pulse duration (96 cycles)
    await ClockCycles(dut.clk, 96)
    
    # HSync should be high again (back porch / next line start)
    assert dut.uo_out[7].value == 1, "Error: hsync pulse failed to de-assert"

    dut._log.info("Devil Nyan Cat verification successful! PASS")