# Author: Daniel Roberto Garcia Miranda (Dani3184)
# Institution: Universidad Mayor de San Andrés, Physics Career, Cosmic Ray Group

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
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut._log.info("Reset complete.")

    # --- Test Behavior ---
    dut._log.info("Validating VGA Sync Signals")

    # Skip first scanline (640 active + porches + sync)
    # 640 + 16 (front) + 96 (sync) + 48 (back) = 800 cycles per line
    await ClockCycles(dut.clk, 800)

    # hsync (bit 7) and vsync (bit 3) are active low, so 1 means inactive (displaying)
    assert dut.uo_out[7].value == 1, "hsync should be high during active video"
    assert dut.uo_out[3].value == 1, "vsync should be high during first lines"

    # Test hsync timing: move past active video and front porch
    await ClockCycles(dut.clk, 640 + 16)
    
    # hsync should now be low (sync pulse active)
    assert dut.uo_out[7].value == 0, "hsync pulse failed to trigger"

    # Wait for the sync pulse to end (96 cycles)
    await ClockCycles(dut.clk, 96)
    assert dut.uo_out[7].value == 1, "hsync pulse failed to de-assert"

    dut._log.info("Devil Nyan Cat verification successful!")