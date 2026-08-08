# Verilog Traffic Signal Controller

A small, synthesizable finite-state-machine (FSM) project for a two-road traffic intersection. The main highway normally has a green light. When a vehicle is detected on the country road, the controller safely changes the signals through yellow and all-red phases before giving the country road a green light.

![State diagram]

## Original diagram

The diagram above is the original source image supplied for this project.

## Behaviour

| State | Highway | Country road | Transition |
| --- | --- | --- | --- |
| `S0_MAIN_GREEN` | Green | Red | Move to `S1` when a country-road car is detected |
| `S1_MAIN_YELLOW` | Yellow | Red | Wait `YELLOW_CYCLES`, then go to `S2` |
| `S2_ALL_RED_TO_COUNTRY` | Red | Red | Wait `ALL_RED_CYCLES`, then go to `S3` |
| `S3_COUNTRY_GREEN` | Red | Green | Move to `S4` once no country-road car is detected |
| `S4_COUNTRY_YELLOW` | Red | Yellow | Wait `YELLOW_CYCLES`, then return to `S0` |

The all-red interval makes the direction handoff safe. The controller uses a synchronous active-high `clear` input to return immediately to the highway-green state.

## Repository layout

```text
rtl/traffic_signal_controller.v  Synthesizable controller
tb/traffic_signal_controller_tb.v Self-checking simulation testbench
assets/state-diagram.svg          Renderable FSM diagram
docs/design.md                    Interface and design notes
Makefile                          Simulation commands
.github/workflows/sim.yml         GitHub Actions verification
```

## Simulate locally

Install [Icarus Verilog](https://steveicarus.github.io/iverilog/) and run:

```bash
make test
```

The testbench creates `build/traffic_signal.vcd`, which can be opened with GTKWave:

```bash
gtkwave build/traffic_signal.vcd
```

## Configure timings

The timing values are counts of rising clock edges, not seconds. Override them when instantiating the module:

```verilog
traffic_signal_controller #(
    .YELLOW_CYCLES(3),
    .ALL_RED_CYCLES(2)
) controller (...);
```

For hardware, choose counts based on the clock frequency and required traffic timings, or place this FSM behind a clock-enable generator. See [design notes](docs/design.md).

## Publish to GitHub

This folder is already a Git repository. Create an empty repository on GitHub, then run the following from this directory (replace the URL):

```bash
git commit -m "Initial traffic signal controller"
git remote add origin https://github.com/YOUR-USERNAME/verilog-traffic-signal-controller.git
git branch -M main
git push -u origin main
```

## License

Released under the [MIT License](LICENSE).
