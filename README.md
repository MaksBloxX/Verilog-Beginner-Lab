# Verilog Beginner Lab
![Verilog](https://img.shields.io/badge/Verilog-2005-blue.svg)
![Simulator](https://img.shields.io/badge/Simulator-Icarus%20Verilog-orange.svg)
![Labs](https://img.shields.io/badge/Labs-6-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
> **Six hands-on labs for learning digital design with Verilog — from logic gates to a 4-bit ALU.**  
> Built for a **Computer Architecture Lab (CSE)** course using **Icarus Verilog** (`iverilog`) + **GTKWave**, with step-by-step testbenches and EDA Playground compatibility.

---

## 📚 Overview

This repository contains six progressive Verilog labs designed for a university Computer Architecture sessional. Each lab focuses on a fundamental building block of digital logic, starting from basic gates and building up to a 4-bit Arithmetic Logic Unit (ALU).

Every module ships with:

- A **design file** (`design.v`) — synthesizable RTL
- A **self-checking testbench** (`testbench.v`) — prints pass/fail and dumps waveforms
- An **expected output** (`expected_output.txt`) — reference log output
- A **VCD waveform** (`dump.vcd`) — viewable in GTKWave / EPWave
- Detailed **lab notes** (in Bengali/English in `docs/`) with line-by-line explanations

A single Python runner (`run_all.py`) compiles and simulates every lab with one command.

---

## 📂 Repository Structure

```
Verilog-Beginner-Lab/
├── README.md                ← This file
├── run_all.py               ← One-command runner (iverilog + vvp for every lab)
│
├── 01_logic_gates/          ← Lab 1: AND, OR, NOT gates
│   ├── design.v
│   ├── testbench.v
│   ├── expected_output.txt
│   └── dump.vcd             ← generated after simulation
│
├── 02_full_adder/           ← Lab 2: 1-bit Full Adder
│   ├── design.v
│   ├── testbench.v
│   ├── expected_output.txt
│   └── dump.vcd
│
├── 03_mux2/                 ← Lab 3: 2-to-1 Multiplexer
│   ├── design.v
│   ├── testbench.v
│   ├── expected_output.txt
│   └── dump.vcd
│
├── 04_register4/            ← Lab 4: 4-bit Register (clocked, sync reset + enable)
│   ├── design.v
│   ├── testbench.v
│   ├── expected_output.txt
│   └── dump.vcd
│
├── 05_counter4/             ← Lab 5: 4-bit Up Counter (mod-16 wrap-around)
│   ├── design.v
│   ├── testbench.v
│   ├── expected_output.txt
│   └── dump.vcd
│
└── 06_alu4/                 ← Lab 6: 4-bit ALU (ADD/SUB/AND/OR)
    ├── design.v
    ├── testbench.v
    ├── expected_output.txt
    └── dump.vcd
```

---

## 🔧 Labs at a Glance

| # | Lab | Module | Concepts | Type |
|---|-----|--------|----------|------|
| 01 | Logic Gates | `logic_gates` | AND, OR, NOT; dataflow `assign` | Combinational |
| 02 | Full Adder | `full_adder` | XOR, carry, boolean equations | Combinational |
| 03 | 2-to-1 MUX | `mux2` | Ternary `?:`, data selection | Combinational |
| 04 | 4-bit Register | `register4` | `posedge clk`, `<=`, sync reset, enable | **Sequential** |
| 05 | 4-bit Counter | `counter4` | Feedback increment, mod-16 wrap | **Sequential** |
| 06 | 4-bit ALU | `alu4` | `always @*`, `case`, +, −, &, \| | Combinational |

---

## 🚀 Quick Start (3 ways)

### Option A — EDA Playground (no install, best for class)

1. Open [edaplayground.com](https://edaplayground.com) and log in with Google.
2. Go to **Profile → Settings** and enable **"Open EPWave in a new window"**.
3. In the editor, paste `testbench.v` into the left panel and `design.v` into the right panel.
4. Set **Tools → Icarus Verilog 12.0**, then check **☐ Open EPWave after run**.
5. Click **Run ▶️** — see the pass/fail output in the **Log** panel and the waveform in the EPWave popup.

### Option B — Run locally with Icarus Verilog

Prerequisites: install [Icarus Verilog](http://bleyer.org/icarus/) and GTKWave.

```bash
# Single lab
cd 01_logic_gates
iverilog -g2005 -Wall -s tb -o sim.vvp design.v testbench.v
vvp sim.vvp
gtkwave dump.vcd
```

### Option C — Run all six labs at once

```bash
python3 run_all.py
```

This compiles and simulates every lab, prints the results, writes `simulation.log` into each lab folder, and confirms that all six pass.

---

## 📋 Verilog Conventions Used

- **Timescale:** `` `timescale 1ns/1ps ``
- **Combinational logic:** `assign` or `always @*` with blocking `=`
- **Sequential logic:** `always @(posedge clk)` with non-blocking `<=`
- **Active-high synchronous reset** for sequential blocks
- **Self-checking testbenches** — print `PASS:` / `FAIL:` after applying every input combination
- **VCD dumping** via `$dumpfile("dump.vcd"); $dumpvars(0, tb);` for waveform viewing

---

## 🖥️ Suggested Tools

| Tool | Purpose | Install |
|------|---------|---------|
| [Icarus Verilog](https://steveicarus.github.io/iverilog/) | Verilog compiler + simulator (`iverilog`, `vvp`) | `apt install iverilog` / Windows installer |
| [GTKWave](https://gtkwave.sourceforge.io/) | VCD waveform viewer | `apt install gtkwave` |
| [EDA Playground](https://edaplayground.com) | In-browser simulator (no install) | Web, Google login |
| VS Code + Verilog extension | Editor with syntax highlighting | VS Code marketplace |

---

## ✅ Verification

All six labs are verified against their expected outputs. Running `python3 run_all.py` should end with:

```
All six labs passed. Each folder now contains dump.vcd and simulation.log.
```

---

## 📖 Learning Path

These labs form the foundation of a simple CPU datapath:

```
Logic Gates → Full Adder → MUX → Register → Counter → ALU
                                                      │
                                                      ▼
                                        Control Unit, Register File,
                                              Simple CPU (next step)
```

After completing this set, you're ready to build:
- Ripple-carry adders (N-bit)
- Register files (M × N-bit registers with read/write ports)
- Simple ALUs with flags (zero, carry, overflow)
- State machines (FSMs)
- A basic single-cycle CPU (MIPS/RISC-V subset)

---

## 📝 License

MIT — feel free to use, modify, and share for your own courses.

---

## 🤝 Contributing

Issues, corrections, and additional labs (e.g., 7-segment decoder, UART, register file, control unit) are welcome! Open an issue or a pull request.
