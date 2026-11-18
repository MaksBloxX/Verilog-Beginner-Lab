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

[Quick Start](#quick-start) •
[Labs](#labs-overview) •
[Structure](#repository-structure) •
[How to Run](#how-to-run) •
[Documentation](#documentation) •
[Learning Path](#learning-path)

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
- ✅ **Detailed lab notes** (in [`docs/`](docs/)) with line-by-line explanations (Bengali)

---

## Quick Start (pick one)<a name="quick-start"></a>

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

## Labs Overview<a name="labs-overview"></a>

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
<td><b><a href="01_logic_gates">Logic Gates</a></b></td>
<td><code>logic_gates</code></td>
<td><sub><code>assign</code>, dataflow modeling, AND/OR/NOT, first Verilog module</sub></td>
<td align="center">Combinational</td>
<td align="center">3 × 1-bit</td>
</tr>

<tr>
<td align="center">02</td>
<td><b><a href="02_full_adder">Full Adder</a></b></td>
<td><code>full_adder</code></td>
<td><sub>XOR (<code>^</code>), carry-out, concatenation, <code>for</code>-loop testbench</sub></td>
<td align="center">Combinational</td>
<td align="center">sum + cout</td>
</tr>

<tr>
<td align="center">03</td>
<td><b><a href="03_mux2">2-to-1 MUX</a></b></td>
<td><code>mux2</code></td>
<td><sub>Ternary <code>?:</code>, conditional assignment, border-case testing</sub></td>
<td align="center">Combinational</td>
<td align="center">1-bit</td>
</tr>

<tr>
<td align="center">04</td>
<td><b><a href="04_register4">4-bit Register</a></b></td>
<td><code>register4</code></td>
<td><sub><b>First sequential circuit.</b> <code>posedge clk</code>, non-blocking <code>&lt;=</code>, sync reset, enable</sub></td>
<td align="center">⭐ Sequential</td>
<td align="center">4-bit bus</td>
</tr>

<tr>
<td align="center">05</td>
<td><b><a href="05_counter4">4-bit Counter</a></b></td>
<td><code>counter4</code></td>
<td><sub>Feedback incrementer, modulo-16 wrap-around, long test sequence, clock divider</sub></td>
<td align="center">⭐ Sequential</td>
<td align="center">4-bit bus</td>
</tr>

<tr>
<td align="center">06</td>
<td><b><a href="06_alu4">4-bit ALU</a></b></td>
<td><code>alu4</code></td>
<td><sub><code>always @(*)</code>, <code>case</code>, ADD/SUB/AND/OR, overflow, two's complement</sub></td>
<td align="center">Combinational</td>
<td align="center">4-bit result</td>
</tr>
</table>

**📖 Lab notes (detailed, Bengali):** see the [`docs/`](docs/) folder.

---

## Repository Structure<a name="repository-structure"></a>

```
Verilog-Beginner-Lab/
│
├── README.md                 ← You are here
├── LICENSE                   ← MIT License
├── .gitignore                ← Ignore build artifacts (*.vvp, *.vcd)
├── run_all.py                ← One-command runner for all labs
│
├── 01_logic_gates/           ← Lab 1: AND · OR · NOT
│   ├── design.v
│   ├── testbench.v
│   └── expected_output.txt
│
├── 02_full_adder/            ← Lab 2: 1-bit full adder
│   └── ...
│
├── 03_mux2/                  ← Lab 3: 2-to-1 multiplexer
├── 04_register4/             ← Lab 4: 4-bit register (clocked)
├── 05_counter4/              ← Lab 5: 4-bit up counter (0→15→0)
├── 06_alu4/                  ← Lab 6: 4-bit ALU (+, −, &, |)
│
└── docs/                     ← Detailed lab notes (Bengali)
    ├── 00_Setup_Guide.md     ← EDA Playground / Icarus install guide
    ├── Lab_01_Logic_Gates.md
    ├── Lab_02_Full_Adder.md
    ├── Lab_03_Mux2.md
    ├── Lab_04_Register4.md
    ├── Lab_05_Counter4.md
    ├── Lab_06_ALU4.md
    └── screenshots/          ← Drop GTKWave / EPWave screenshots here
```

---

## Sample Output

Every testbench produces a clear pass/fail log. For example, Lab 01:

```
VCD info: dumpfile dump.vcd opened for output.
a b | AND OR NOT_a
0 0 |  0   0    1
0 1 |  0   1    1
1 0 |  0   1    0
1 1 |  1   1    0
PASS: logic gates
```

> 📸 Add your own EPWave/GTKWave screenshots into [`docs/screenshots/`](docs/screenshots/) and reference them from the lab notes.

---

## Verilog Conventions Used<a name="verilog-conventions"></a>

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

## Tools You'll Need

| Tool | Purpose | Install |
|:---|---|---|
| **[Icarus Verilog](https://steveicarus.github.io/iverilog/)** | Verilog compiler + simulator | `apt install iverilog` / [Windows installer](http://bleyer.org/icarus/) |
| **[GTKWave](https://gtkwave.sourceforge.io/)** | VCD waveform viewer | `apt install gtkwave` |
| **[EDA Playground](https://edaplayground.com)** | In-browser simulator (no install) | Web (Google login) |
| **Python 3** | To run `run_all.py` | Pre-installed on most systems |
| **VS Code + Verilog extension** *(optional)* | Editor with syntax highlighting | Marketplace: `mshr-h.veriloghdl` |

---

## How to Run (step by step)<a name="how-to-run"></a>

### Step 1 — Pick an environment

| Where | Best for |
|---|---|
| **EDA Playground** (browser) | Class lab, no install needed |
| **Icarus + GTKWave local** | Home practice, offline work |

### Step 2 — For EDA Playground (each lab)

1. Click **New** to open a fresh playground
2. Paste `testbench.v` code in the **left** editor panel
3. Paste `design.v` code in the **right** editor panel
4. Under **Tools & Simulators**, select **Icarus Verilog 12.0**
5. Under **Run Options**, tick **☐ Open EPWave after run**
6. Click **Run ▶**
7. Scroll down to the **Log panel** to see PASS/FAIL
8. In the EPWave popup (bottom-right corner):
   - Click **Get Signals** → select **tb** scope → **Append All** → **Close**
   - Use **Ctrl + mouse wheel** to zoom
   - Click any signal line to drop a cursor and see values
9. Repeat from step 1 for the next lab (or click **New**)

### Step 3 — Verifying a successful run

You should see:
- ✅ No red compilation errors in the log
- ✅ A line starting with `PASS:` (e.g. `PASS: logic gates`)
- ✅ EPWave shows all signals toggling at expected times
- ✅ `errors[31:0]` stays at 0 throughout the waveform

### Step 4 — Run everything at once (local only)

```bash
python3 run_all.py
```

---

## Troubleshooting

<details>
<summary><b>"Unknown module type" in EDA Playground</b></summary>
The design module must be in its own file (right panel / <code>design.sv</code>). The testbench in the left panel imports it — don't put both modules in one file.
</details>

<details>
<summary><b>EPWave replaced my editor / I can't see the log</b></summary>
Go to <b>Profile → Settings</b> and enable <i>"Open EPWave in a new browser window"</i>. Then click Run again — EPWave pops up in a corner window without covering the editor.
</details>

<details>
<summary><b>"iverilog: command not found"</b> (local)</summary>
Icarus Verilog isn't on your PATH. On Windows, add <code>C:\iverilog\bin</code> to System PATH and restart your terminal.
</details>

<details>
<summary><b>Empty waveform / flat lines</b></summary>
Make sure your testbench calls <code>$dumpfile("dump.vcd"); $dumpvars(0, tb);</code> inside the <code>initial begin</code> block. All our testbenches include this already.
</details>

<details>
<summary><b>"Inferred latch" warning during synthesis</b></summary>
You forgot the <code>default</code> branch in a <code>case</code> statement inside <code>always @*</code>, or omitted an <code>else</code> in a combinational <code>if</code>. Always assign the output in every path.
</details>

<details>
<summary><b>Waveform signals appear duplicated</b></summary>
You clicked <b>Append All</b> more than once. Right-click a signal name and choose Delete, or close EPWave and run again.
</details>

> 👉 More detailed setup help: [`docs/00_Setup_Guide.md`](docs/00_Setup_Guide.md).

---

## Learning Path<a name="learning-path"></a>

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

## Documentation<a name="documentation"></a>

Detailed, line-by-line lab notes (Bengali) live in [`docs/`](docs/):

| File | Contents |
|---|---|
| [`docs/00_Setup_Guide.md`](docs/00_Setup_Guide.md) | EDA Playground setup, Icarus install, troubleshooting |
| [`docs/Lab_01_Logic_Gates.md`](docs/Lab_01_Logic_Gates.md) | AND/OR/NOT — first Verilog module |
| [`docs/Lab_02_Full_Adder.md`](docs/Lab_02_Full_Adder.md) | Full adder, carry, XOR |
| [`docs/Lab_03_Mux2.md`](docs/Lab_03_Mux2.md) | 2-to-1 multiplexer, ternary operator |
| [`docs/Lab_04_Register4.md`](docs/Lab_04_Register4.md) | First sequential circuit, clock, `<=` |
| [`docs/Lab_05_Counter4.md`](docs/Lab_05_Counter4.md) | Mod-16 counter, wrap-around |
| [`docs/Lab_06_ALU4.md`](docs/Lab_06_ALU4.md) | Combinational ALU, case statement |
| [`docs/screenshots/`](docs/screenshots/) | Drop waveform screenshots here |

Each lab note includes: objective, truth/function table, line-by-line code walkthrough, expected output, waveform analysis, common mistakes, extra practice, and a report-writing guide.

---

## Contributing

This is a teaching project — corrections, clarifications, and new labs are very welcome!

- 🐛 **Found a bug?** Open an issue with the lab number and what went wrong.
- ✨ **Want to add a lab?** (7-segment decoder, register file, UART, simple CPU, …) — fork, add a folder following the same `design.v` + `testbench.v` + `expected_output.txt` pattern, and open a PR.
- 📖 **Improved explanations?** PRs to `docs/` are appreciated.
- 🌐 **Translations?** Place translated notes in `docs/<lang>/` (e.g. `docs/en/`, `docs/bn/`).

---

## Author

**Md. Makshedul Islam** — [@MaksBloxX](https://github.com/MaksBloxX)

Built as teaching material for a Computer Architecture sessional course. If these labs helped your coursework, a ⭐ on the repo is always appreciated!

---

## License

This project is licensed under the **MIT License** — see [`LICENSE`](LICENSE) for the full text. You're free to use, modify, and share this for educational or personal projects.

<div align="center">
<br>
<sub>Made with ❤️ for digital design students.</sub>
<br><br>
<img alt="Digital Logic" src="https://img.shields.io/badge/Digital%20Logic-1%2B1%3D10-blueviolet?style=flat-square">
<img alt="Verilog" src="https://img.shields.io/badge/Verilog-%E2%8C%82%EF%B8%8F-blue?style=flat-square">
<img alt="Hardware" src="https://img.shields.io/badge/Tapeout-ready-success?style=flat-square">
</div>
