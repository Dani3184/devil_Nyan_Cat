#Author: Daniel Roberto Garcia Miranda
#Institution: Universidad Mayor de San Andres, Physics Career, Cosmic Ray Group
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_nyan_cat_switching(dut):
    """Test VGA sync and mode switching between Good and Evil Cat"""
    
    dut._log.info("Starting simulation...")
    
    # Define clock: 25.175 MHz (typical VGA) is approx 39.72ns period
    clock = Clock(dut.clk, 40, units="ns")
    cocotb.start_soon(clock.start())

    # Initial Reset Sequence
    dut.rst_n.value = 0
    dut.ui_in.value = 0 # Default: Good Cat mode
    dut.ena.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    # 1. Verify "Good Cat" operation
    dut._log.info("Rendering Good Cat (Normal Mode)...")
    await ClockCycles(dut.clk, 2000)

    # 2. Switch to "Evil Cat" using the control pin
    dut._log.info("Switching to EVIL mode via ui_in[0]...")
    dut.ui_in.value = 1 
    await ClockCycles(dut.clk, 2000)

    # 3. Check if VGA sync signals are still functional
    # uo_out[3] is vsync, uo_out[7] is hsync (both active low, so 1 when idle)
    assert dut.uo_out[3].value == 1, "VSync failure!"
    assert dut.uo_out[7].value == 1, "HSync failure!"
    
    dut._log.info("Simulation completed successfully!")
