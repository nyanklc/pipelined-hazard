import cocotb
from cocotb.triggers import Timer

async def clock_pulse(dut):
    dut.KEY[0].value = 0
    await Timer(5, units='ms')
    dut.KEY[0].value = 1
    await Timer(5, units='ms')
    dut.KEY[0].value = 0
    await Timer(5, units='ms')

@cocotb.test()
async def test_desoc(dut):
    dut.KEY[1].value = 1
    await Timer(1, units='ms')

    for i in range(25):
        print(f"CLOCK {i+1}")
        await clock_pulse(dut)
        print(dut.PC.value)
