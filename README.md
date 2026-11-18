<div align="center">

# 🔬 Verilog Beginner Lab

### From Logic Gates to a 4-bit ALU — Six hands-on labs for Computer Architecture

[![Verilog](https://img.shields.io/badge/Verilog-IEEE%201364--2005-blue?style=for-the-badge&logo=verilog)](https://ieeexplore.ieee.org/document/1620780)
[![Simulator](https://img.shields.io/badge/Simulator-Icarus%20Verilog%2012.0-orange?style=for-the-badge&logo=apachespark)](https://steveicarus.github.io/iverilog/)
[![Waveform](https://img.shields.io/badge/Waveform-GTKWave%20%2F%20EPWave-success?style=for-the-badge)]()
[![Labs](https://img.shields.io/badge/Labs-6%20complete-brightgreen?style=for-the-badge)]()
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Education](https://img.shields.io/badge/Course-Computer%20Architecture%20Lab-important?style=for-the-badge)]()

*Built for university Computer Architecture sessional courses — runs in the browser with EDA Playground or locally with Icarus Verilog.*

[Getting Started](#-quick-start) • [Labs](#-labs-overview) • [Structure](#-repository-structure) • [How to Run](#-how-to-run) • [Learning Path](#-learning-path)

</div>

---

## ✨ What is this?

A **progressive, beginner-friendly Verilog course** covering six fundamental digital design building blocks:

| Stage | You build... | Foundation for |
|:----:|---|---|
| 🟢 Lab 01 | AND, OR, NOT gates | All digital logic |
| 🟢 Lab 02 | 1-bit Full Adder | Arithmetic circuits |
| 🟡 Lab 03 | 2-to-1 Multiplexer | Data steering, busses |
| 🟠 Lab 04 | 4-bit Register (sync reset + enable) | Memory, state |
| 🔴 Lab 05 | 4-bit Up Counter (mod-16) | Timers, program counters |
| 🔴 Lab 06 | 4-bit ALU (ADD / SUB / AND / OR) | CPUs! |

Every lab includes:
- ✅ **Synthesizable RTL design** (`design.v`)
- ✅ **Self-checking testbench** with PASS/FAIL output (`testbench.v`)
- ✅ **Expected output log** (`expected_output.txt`)
- ✅ **Waveform dump** (`dump.vcd`) for visual verification
- ✅ A single **Python runner** (`run_all.py`) to simulate everything at once
- ✅ **[Detailed lab notes](docs/)** with line-by-line explanations (Bengali)

---

## 🚀 Quick Start (pick one)

### 🌐 Option A — EDA Playground (zero install, best for class)

1. Open [edaplayground.com](https://edaplayground.com) → **Log in with Google**
2. Go to **Profile → Settings** → ☑ *"Open EPWave in a new browser window"*
3. Paste `testbench.v` in the **left panel** and `design.v` in the **right panel**
4. Select **Tools → Icarus Verilog 12.0** and check **☐ Open EPWave after run**
5. Click **Run ▶** → see results in the **Log** panel; waveforms pop up in EPWave

### 💻 Option B — Local with Icarus Verilog + GTKWave

Install [Icarus Verilog](http://bleyer.org/icarus/) and [GTKWave](https://gtkwave.sourceforge.io/), then:

```bash
cd 01_logic_gates
iverilog -g2005 -Wall -s tb -o sim.vvp design.v testbench.v
vvp sim.vvp
gtkwave dump.vcd
```

### ⚡ Option C — Run all six labs at once

```bash
python3 run_all.py
```

You should see:
```
All six labs passed. Each folder now contains dump.vcd and simulation.log.
```

---

## 📚 Labs Overview

<table>
<tr>
<th width="4%">#</th>
<th width="18%">Lab</th>
<th width="14%">Module</th>
<th width="34%">Key Concepts</th>
<th width="15%">Type</th>
<th width="15%">Output bits</th>
</tr>

<tr>
<td align="center">01</td>
<td><b>Logic Gates</b></td>
<td><code>logic_gates</code></td>
<td>
<sub>
<code>assign</code>, dataflow modeling, AND/OR/NOT operators, first Verilog module
</sub>
</td>
<td align="center">Combinational</td>
<td align="center">3 × 1-bit</td>
</tr>

<tr>
<td align="center">02</td>
<td><b>Full Adder</b></td>
<td><code>full_adder</code></td>
<td>
<sub>
XOR (<code>^</code>), carry-out logic, concatenation, <code>for</code>-loop testbench
</sub>
</td>
<td align="center">Combinational</td>
<td align="center">sum + cout</td>
</tr>

<tr>
<td align="center">03</td>
<td><b>2-to-1 MUX</b></td>
<td><code>mux2</code></td>
<td>
<sub>
Ternary operator <code>?:</code>, conditional assignment, border-case testing
</sub>
</td>
<td align="center">Combinational</td>
<td align="center">1-bit</td>
</tr>

<tr>
<td align="center">04</td>
<td><b>4-bit Register</b></td>
<td><code>register4</code></td>
<td>
<sub>
<b>First sequential circuit!</b> <code>posedge clk</code>, non-blocking <code><=</code>,
synchronous reset, enable/hold, clock generator in testbench
</sub>
</td>
<td align="center">⭐ Sequential</td>
<td align="center">4-bit bus</td>
</tr>

<tr>
<td align="center">05</td>
<td><b>4-bit Counter</b></td>
<td><code>counter4</code></td>
<td>
<sub>
Feedback incrementer, modulo-16 wrap-around, long test sequence, clock divider
</sub>
</td>
<td align="center">⭐ Sequential</td>
<td align="center">4-bit bus</td>
</tr>

<tr>
<td align="center">06</td>
<td><b>4-bit ALU</b></td>
<td><code>alu4</code></td>
<td>
<sub>
<code>always @(*)</code>, <code>case</code> statement, ADD/SUB/AND/OR, overflow truncation, two's complement
</sub>
</td>
<td align="center">Combinational</td>
<td align="center">4-bit result</td>
</tr>
</table>

---

## 📂 Repository Structure

```
Verilog-Beginner-Lab/
│
├── README.md                     ← You are here
├── LICENSE                       ← MIT License
├── .gitignore
├── run_all.py                    ← One-command runner for all labs
│
├── 01_logic_gates/               ├── AND · OR · NOT
│   ├── design.v
│   ├── testbench.v
│   ├── expected_output.txt
│   └── dump.vcd                  (generated)
│
├── 02_full_adder/                ├── 1-bit full adder (sum + carry)
│   ├── design.v
│   ├── testbench.v
│   └── expected_output.txt
│
├── 03_mux2/                      ├── 2-to-1 multiplexer
│   └── ...
│
├── 04_register4/                 ├── 4-bit register (clocked)
│   └── ...
│
├── 05_counter4/                  ├── 4-bit up counter (0→15→0)
│   └── ...
│
├── 06_alu4/                      ├── 4-bit ALU (+, −, &, |)
│   └── ...
│
└── docs/                         ← Detailed lab notes (Bengali)
    ├── 00_Setup_Guide.md
    ├── Lab_01_Logic_Gates.md
    ├── Lab_02_Full_Adder.md
    ├── Lab_03_Mux2.md
    ├── Lab_04_Register4.md
    ├── Lab_05_Counter4.md
    └── Lab_06_ALU4.md
```

---

## 🖥️ Sample Output

Every testbench produces a clear pass/fail log:

```
VCD info: dumpfile dump.vcd opened for output.
a b | AND OR NOT_a
0 0 |  0   0    1
0 1 |  0   1    1
1 0 |  0   1    0
1 1 |  1   1    0
PASS: logic gates
```

<div align="center">
<img src="docs/screenshots/logic_gates_waveform.png" alt="Waveform preview" width="700">
<p><sub><i>Waveform from Lab 01 (Logic Gates) — view in GTKWave or EPWave.</i></sub></p>
</div>

> 💡 To add your own screenshot, drop it at `docs/screenshots/logic_gates_waveform.png`.

---

## 📐 Verilog Conventions Used

| Concept | How we write it |
|---|---|
| **Timescale** | `` `timescale 1ns/1ps `` |
| **Continuous assignments** | `assign y = a & b;` |
| **Combinational logic** | `always @* begin ... end` with blocking `=` |
| **Sequential logic** | `always @(posedge clk) begin ... end` with non-blocking `<=` |
| **Reset** | Active-high synchronous reset (reset takes priority over enable) |
| **Testbench pattern** | Instantiate DUT → `$dumpfile`/`$dumpvars` → apply inputs with `#delay` → self-check → `PASS:` / `FAIL:` → `$finish` |
| **Output checking** | Uses `!==` (4-state comparison) to catch X/Z bugs |

---

## 🧰 Tools You'll Need

| Tool | Purpose | Install |
|:---|---|---|
| **[Icarus Verilog](https://steveicarus.github.io/iverilog/)** | Verilog compiler + simulator | `apt install iverilog` / [Windows installer](http://bleyer.org/icarus/) |
| **[GTKWave](https://gtkwave.sourceforge.io/)** | VCD waveform viewer | `apt install gtkwave` |
| **[EDA Playground](https://edaplayground.com)** | In-browser simulator (no install) | Web (Google login) |
| **Python 3** | To run `run_all.py` | Pre-installed on most systems |
| **VS Code + Verilog extension** *(optional)* | Editor with syntax highlighting | Marketplace: `mshr-h.veriloghdl` |

---

## 🛠️ Troubleshooting

<details>
<summary><b>"Unknown module type" in EDA Playground</b></summary>

The design module must be in its own file (right panel / `design.sv`). The testbench in the left panel imports it — it can't be in the same file.
</details>

<details>
<summary><b>EPWave replaced my editor / I can't see the log</b></summary>

Go to <b>Profile → Settings</b> and enable <i>"Open EPWave in a new browser window"</i>. Then click Run again — EPWave will pop up in a small corner window without replacing the editor.
</details>

<details>
<summary><b>`iverilog: command not found`</b></summary>

Icarus Verilog is not installed or not on your PATH. On Windows, add `C:\iverilog\bin` to System PATH and restart VS Code / terminal.
</details>

<details>
<summary><b>Empty waveform / flat lines</b></summary>

Make sure your testbench calls `$dumpfile("dump.vcd"); $dumpvars(0, tb);` inside the `initial begin` block. Our testbenches already include this.
</details>

<details>
<summary><b>Inferred latch warning during synthesis</b></summary>

You forgot the `default` branch in a `case` statement inside `always @*`, or omitted an `else` in a combinational `if`. Always assign the output in every path.
</details>

> 👉 More issues and fixes in [`docs/00_Setup_Guide.md`](docs/00_Setup_Guide.md).

---

## 🧠 Learning Path

These six labs give you all the building blocks for a simple CPU:

```
   Logic Gates        →      Boolean foundation
       ↓
   Full Adder         →      Arithmetic
       ↓
   MUX                →      Data selection
       ↓
   Register           →      State / memory
       ↓
   Counter            →      Clocked state machines
       ↓
   ALU                →      Execution
       ↓
 ┌─────────────────────────────────────┐
 │  Next (build these yourself!):      │
 │   • N-bit Ripple-Carry Adder        │
 │   • Register File (M × N-bit)       │
 │   • ALU with flags (Z, C, V, N)     │
 │   • Finite State Machines           │
 │   • Single-cycle CPU (MIPS/RISC-V)  │
 └─────────────────────────────────────┘
```

---

## 📝 Documentation

Detailed, line-by-line lab notes (Bengali) are available in the [`docs/`](docs/) folder:

- 📘 [`docs/00_Setup_Guide.md`](docs/00_Setup_Guide.md) — EDA Playground, Icarus install, troubleshooting
- 📗 [`docs/Lab_01_Logic_Gates.md`](docs/Lab_01_Logic_Gates.md)
- 📗 [`docs/Lab_02_Full_Adder.md`](docs/Lab_02_Full_Adder.md)
- 📗 [`docs/Lab_03_Mux2.md`](docs/Lab_03_Mux2.md)
- 📙 [`docs/Lab_04_Register4.md`](docs/Lab_04_Register4.md)
- 📙 [`docs/Lab_05_Counter4.md`](docs/Lab_05_Counter4.md)
- 📕 [`docs/Lab_06_ALU4.md`](docs/Lab_06_ALU4.md)

Each lab note contains:
- 🎯 Objective & truth table / function table
- 💻 Design code with line-by-line explanation
- 🧪 Testbench walkthrough
- 📊 Expected output
- 📈 Waveform analysis (what to look for in GTKWave / EPWave)
- ⚠️ Common mistakes
- 💡 Extra practice exercises
- 📝 Report writing guide

---

## 🤝 Contributing

This is a teaching project — corrections, clarifications, and new labs are very welcome!

- 🐛 **Found a bug?** Open an issue describing the lab + what went wrong.
- ✨ **Want to add a lab?** (7-segment decoder, register file, UART, simple CPU, …) — fork, add the lab in the same `design.v` + `testbench.v` + `expected_output.txt` format, and open a PR.
- 📖 **Improved explanations?** PRs for docs/ are appreciated.
- 🌐 **Translation?** Lab notes in other languages welcome in `docs/<lang>/`.

---

## 👤 Author

**Md. Makshedul Islam** ([@MaksBloxX](https://github.com/MaksBloxX))

Built as teaching material for a Computer Architecture sessional course. If these labs helped your coursework, a ⭐ on the repo is always appreciated!

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details. You're free to use, modify, and share this for educational or personal projects.

<div align="center">
<br>
<sub>Made with ❤️ for digital design students.</sub>
<br><br>
<img alt="Digital Logic" src="https://img.shields.io/badge/Digital%20Logic-1%2B1%3D10-blueviolet?style=flat-square">
<img alt="Verilog" src="https://img.shields.io/badge/Verilog-%E2%8C%82%EF%B8%8F-blue?style=flat-square">
<img alt="Hardware" src="https://img.shields.io/badge/Tapeout-ready-success?style=flat-square">
</div>
