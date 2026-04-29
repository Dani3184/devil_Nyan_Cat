#Author: Daniel Roberto Garcia Miranda
#Institution: Universidad Mayor de San Andres, Physics Career, Cosmic Ray Group
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):

    clock = Clock(dut.clk, 40, units="ns")
    cocotb.start_soon(clock.start())

    dut.ena.value = 1
    dut.ui_in.value = 0  # start normal mode
    dut.uio_in.value = 0

    # reset
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # run normal mode
    await ClockCycles(dut.clk, 10000)

    # switch to devil mode
    dut.ui_in.value = 1
    await ClockCycles(dut.clk, 10000)

    # simple checks
    assert dut.uo_out.value is not None
