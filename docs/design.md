# Design notes

## Interface

| Signal | Direction | Description |
| --- | --- | --- |
| `clock` | input | Controller clock; all state changes occur on its rising edge. |
| `clear` | input | Synchronous active-high reset. It selects highway green and country red. |
| `car_on_country_rd` | input | Vehicle-presence request for the country road. |
| `hwy` | output | Highway lamp encoding: red `100`, yellow `010`, green `001`. |
| `cntry` | output | Country-road lamp encoding: red `100`, yellow `010`, green `001`. |

## Timing semantics

`YELLOW_CYCLES` and `ALL_RED_CYCLES` specify how many complete rising-edge intervals a timed state remains selected. This is intentionally clock-domain friendly: the module contains no `#delay` statements, so it can be synthesized for FPGA or ASIC flow.

For a 50 MHz clock, a 3-second yellow phase requires a count of 150,000,000. In practical hardware, use a slower clock-enable pulse (for example, once per second) so the counter stays compact.

## Verification

The testbench performs a full request-and-release cycle and checks every lamp state. It also writes a VCD waveform for visual inspection.
