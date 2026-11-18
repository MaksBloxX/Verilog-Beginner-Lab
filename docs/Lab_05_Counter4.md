# Lab 05 — 4-bit Counter

> **অধ্যায়:** Sequential Circuit — Counter / State Machine  
> **পূর্বশর্ত:** Lab 04 (register, clocked always block)  
> **ফাইল:** `design.v` + `testbench.v`

---

## 🎯 লক্ষ্য (Objective)

৪-বিট ঊর্ধ্বমুখী কাউন্টার (up counter) বানানো যা 0, 1, 2, …, 15, 0, 1, … এভাবে ঘুরতে থাকবে প্রতিটি clock এ। Counter প্রোগ্রাম কাউন্টার (PC), timer, frequency divider, state machine-এ ব্যবহার হয়।

**ইনপুট:**
- `clk` — ঘড়ি
- `reset` — Active-high synchronous reset (count=0)

**আউটপুট:**
- `count[3:0]` — 4-bit current count (0–15, তারপর wrap to 0)

### শিখা যাবে
- Register কিভাবে counter-এ পরিণত হয় (feedback = count + 1)
- Modular arithmetic (mod-16 wrap-around)
- Long simulation with for loop
- Synchronous reset behavior verification
- Clock divider concept (counter বড় করে)

---

## 🔌 সার্কিট ধারণা

একটা 4-bit register যার D input = current Q + 1:

```
        ┌──────────────────────────┐
        │                          │
        │   ┌──────┐    +1         ▼
d[3:0]──┼──►│      │  ┌──────────────┐
        │   │  4b  ├──► count[3:0] ──┤──► count
reset ──┼──►│ reg  │  └──────┬───────┘
        │   │  clk │         │
clk ────┼──►│      │         │ +1
        │   └──────┘         ▼
        │               4-bit adder
        └──────────────────── (q+1 feeds back when !reset)
```

**Reset এর সময়:** multiplexer 0 select করে  
**Normal count:** multiplexer (count+1) select করে

---

## 💻 Design Code — `design.v`

```verilog
`timescale 1ns/1ps

// Active-high synchronous reset. The four-bit count wraps after 15.
module counter4(
    input clk, reset,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (reset)
            count <= 4'b0000;
        else
            count <= count + 4'b0001;
    end
endmodule
```

### লাইন বাই লাইন ব্যাখ্যা

| লাইন | ব্যাখ্যা |
|------|---------|
| `input clk, reset,` | Clock + synchronous reset |
| `output reg [3:0] count` | 4-bit register output — register-এর মতো `reg` type, কারণ `always` ব্লকে assign হবে |
| `always @(posedge clk)` | Clock rising edge triggered |
| `if (reset) count <= 4'b0000;` | Reset হলে count 0 করো |
| `else count <= count + 4'b0001;` | অন্যথায় count বাড়াও 1 করে |

### এটা register-এর সাথে কিভাবে relate করে?
- Lab 04-এ register-এর ছিল `enable`, `d` — `q <= d` (বাহ্যিক ডেটা load)
- এই counter-এ `d` internally তৈরি হচ্ছে `count+1` দিয়ে
- মূলত এটা একটা register যার feedback path-এ একটা incrementer (+1) যুক্ত

### Wrap-around (overflow)
- 4-bit unsigned 0–15 range; 15+1 = 16 → binary 10000
- 4-bit-এ শুধু low 4 bit সংরক্ষণ হয় → 0000 → স্বয়ংক্রিয়ভাবে wrap
- Extra carry bit সংরক্ষণ হয় না; overflow হারিয়ে যায় (এটাই এখানে কাঙ্ক্ষিত)

### বাস্তবে synthesis হলে কি হবে?
4-bit register + 4-bit incrementer (half-adder chain)। LUT/FPGA-এ প্রায় 4টা flip-flop + কয়েকটা LUT।

---

## 🧪 Testbench Code — `testbench.v`

```verilog
`timescale 1ns/1ps

module tb;
    reg clk, reset;
    wire [3:0] count;
    integer i, errors;
    reg [3:0] expected;

    counter4 dut(.clk(clk), .reset(reset), .count(count));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        reset = 1;
        @(posedge clk); #1;
        if (count !== 4'd0) errors = errors + 1;
        $display("Reset: count=%0d", count);

        @(negedge clk);
        reset = 0;
        for (i = 1; i <= 18; i = i + 1) begin
            @(posedge clk); #1;
            expected = i % 16;
            $display("Clock %0d: count=%0d (expected %0d)", i, count, expected);
            if (count !== expected) errors = errors + 1;
        end

        // Reset must wait for a rising clock edge.
        @(negedge clk);
        reset = 1;
        #1;
        if (count !== 4'd2) errors = errors + 1;
        @(posedge clk); #1;
        if (count !== 4'd0) errors = errors + 1;

        if (errors == 0) $display("PASS: counter");
        else $display("FAIL: counter, errors=%0d", errors);
        $finish;
    end
endmodule
```

### Test sequence বুঝি

**Phase 1 — Reset verification:**
- Start: `reset = 1`
- প্রথম posedge-এর পর count হবে 0 (reset-এর জন্য)

**Phase 2 — Counting for 18 clock cycles:**
- Nedge-এ reset 0 করছি, তারপর 18 posedge count করবো
- কেন 18? কারণ 16 clock-এ 0→15→0 হবে (wrap-around দেখাতে); 17-18 clock-এ 1, 2 দেখাবো যে wrap-এর পর আবার স্বাভাবিক গণনা চলছে
- Reference: `expected = i % 16` (mod-16)

**Phase 3 — Synchronous reset verification:**
- Nedge-এ reset=1 করছি; তারপর `#1` — count এখনো আগের মান (2) থাকা উচিত (reset synchronous!)
- পরের posedge-এ count 0 হয়ে যাবে

### Clock timing reference (10 ns period, rising at t = 5, 15, 25, ..., 195 ns)

| Clock # (i) | Time (ns) | expected |
|---|---|---|
| (reset)  | 5 | 0 |
| 1 | 15 | 1 |
| 2 | 25 | 2 |
| ... | ... | ... |
| 15 | 155 | 15 |
| 16 | 165 | 0 (wrap) |
| 17 | 175 | 1 |
| 18 | 185 | 2 |

মোট 18 clocks = 180 ns of counting (15 ns → 195 ns)। তাই simulation 196 ns-এ শেষ হয় (expected_output এ দেখানো)।

---

## ▶️ কিভাবে রান করবে

### EDA Playground-এ (সবচেয়ে সহজ)
1. https://edaplayground.com খুলে **Google দিয়ে Login** করো
2. প্রথমবার হলে **Profile → Settings**-এ গিয়ে ☑ **"Open EPWave in a new browser window"** টিক দিয়ে Save (একবার করলেই হবে)
3. **বাম panel (testbench.sv)** এ testbench.v-এর কোড পেস্ট করো
4. **ডান panel (design.sv)** এ design.v-এর কোড পেস্ট করো (design.sv tab না থাকলে New File বাটন চেপে বানাও)
5. বামে Tools-এ **Icarus Verilog 12.0** সিলেক্ট করো
6. Run Options-এ ☑ **"Open EPWave after run"** টিক দাও
7. **Run ▶️** চাপ দাও
8. **Log panel দেখো (code panels-এর নিচে):** নিচে scroll করলে PASS: message দেখাবে
9. **EPWave popup (ডান নিচে):**
   - "Waves Loaded" popup-এ **Close** দাও
   - **Get Signals** বাটন চাপো → scope-এ tb select → **Append All** → **Close**
   - সব signal waveform-এ আসবে
   - **Ctrl + mouse wheel** দিয়ে zoom; Radix dropdown binary/decimal-এ change
   - signal line-এ click করে cursor আনলে সময় ও মান দেখা যাবে
10. **Next ল্যাবে যেতে:** **New** বাটন চাপো → নতুন code paste → Run

### Local
```bash
mkdir -p 05_counter4 && cd 05_counter4
iverilog -g2005 -Wall -s tb -o sim.vvp design.v testbench.v
vvp sim.vvp
```

---

## 📊 Expected Output

```
VCD info: dumpfile dump.vcd opened for output.
Reset: count=0
Clock 1: count=1 (expected 1)
Clock 2: count=2 (expected 2)
Clock 3: count=3 (expected 3)
Clock 4: count=4 (expected 4)
Clock 5: count=5 (expected 5)
Clock 6: count=6 (expected 6)
Clock 7: count=7 (expected 7)
Clock 8: count=8 (expected 8)
Clock 9: count=9 (expected 9)
Clock 10: count=10 (expected 10)
Clock 11: count=11 (expected 11)
Clock 12: count=12 (expected 12)
Clock 13: count=13 (expected 13)
Clock 14: count=14 (expected 14)
Clock 15: count=15 (expected 15)
Clock 16: count=0 (expected 0)   ← wrap!
Clock 17: count=1 (expected 1)
Clock 18: count=2 (expected 2)
PASS: counter
testbench.v:42: $finish called at 196000 (1ps)
```

**লক্ষণীয়:** Clock 16-তে count 15 থেকে সরাসরি 0-তে wrap করছে (overflow/carry)। এটাই 4-bit counter-এর modulo-16 behavior।

---

## 📈 Waveform বিশ্লেষণ

Signals: `clk`, `reset`, `count[3:0]` (bus হিসেবে দেখো, অথবা binary হিসেবে)

কি দেখবে:
1. **count** শুধু rising clock edge-এ increment হয় (1→2→3…)
2. Clock 16-এ (t ≈ 165 ns) — count 15 → 0 transition (সব 4 bits একসাথে flip: 1111 → 0000)
3. Reset প্রথমে 1 → count 0 থাকে; reset 0 করার পর counting শুরু
4. Phase 3-এ reset=1 negedge-এ করা হয় — count তখন posedge অপেক্ষা করছে

Bus হিসেবে count দেখলে analog/ramp-like ধাপ দেখাবে (1,2,3,…15,0,1,2)। Binary হিসেবে দেখলে প্রতিটা bit-এর frequency different — `count[0]` half-এর frequency-এ toggle, `count[1]` quarter, etc.

### Clock Divider হিসেবে Counter
`count[3]` (MSB) 16 clock cycle-এ 1 cycle পূর্ণ করে (8 high, 8 low) — এটা clk frequency-কে 16 দিয়ে ভাগ করছে। যেকোনো bit `count[k]` frequency = `clk_freq / 2^(k+1)`।

| bit | division factor |
|-----|----------------|
| count[0] | ÷2 |
| count[1] | ÷4 |
| count[2] | ÷8 |
| count[3] | ÷16 |

---

### 🖱️ EPWave-এ ভালোভাবে waveform দেখার টিপস
- **Ctrl + mouse wheel** দিয়ে zoom in/out; মাউস wheel এ একা scroll করলে সময় axis scroll হয়
- Toolbar-এ **Zoom to Fit** (ম্যাগ্নিফাইং glass + square) বাটন চাপলে পুরো waveform একসাথে fit হয়ে যাবে
- **Radix** dropdown → **Binary** করলে প্রতিটা 1-bit signal 0/1 দেখাবে; bus (multi-bit) signals-এর জন্য Decimal/Hex ব্যবহার করো
- Signal name-এ click করে **Drag** করলে signal-এর order পরিবর্তন (গুরুত্বপূর্ণ signals উপরে তুলে আনা যায়)
- Signal line-এ **এক ক্লিকে cursor** আসে → time point-এর মান বাম পাশে signal name-এর পাশে দেখাবে
- Cursor রেখে **time marker** দেখতে Δ বাটন ব্যবহার করো (দুই cursor-এর মাঝের সময় ব্যবধান)


## 🔄 Counter variants

### Down Counter (count down)
```verilog
always @(posedge clk) begin
    if (reset) count <= 0;
    else count <= count - 1;   // 0-1 = 15 (wrap under)
end
```

### Up/Down Counter (direction input)
```verilog
input up_down;  // 1 = up, 0 = down
always @(posedge clk) begin
    if (reset) count <= 0;
    else count <= up_down ? count + 1 : count - 1;
end
```

### Loadable Counter (initial value লোড করা যায়)
```verilog
input load;
input [3:0] load_val;
always @(posedge clk) begin
    if (reset) count <= 0;
    else if (load) count <= load_val;
    else count <= count + 1;
end
```
এটা প্রায় Program Counter (PC) — branch/jump-এ target address load হয়, না হলে PC+4 (or PC+1)।

### Enable সহ Counter (count করা বন্ধ/চালু)
```verilog
input en;
always @(posedge clk) begin
    if (reset) count <= 0;
    else if (en) count <= count + 1;
    // else hold
end
```

---

## ⚠️ Common Mistakes

1. **4'b001 লিখে 4'b0001 না লিখা (bit count কম)**
   - Verilog-এ 4'b001 হলেও 3 bits; 4'b0001 লেখো স্পষ্টতার জন্য

2. **`count + 1` — width mismatch চিন্তা**
   - `count` 4-bit; `1` unsized integer (অন্তত 32-bit)
   - Verilog-এ self-determined size অনুযায়ী কাজ করে; count-এ assign হচ্ছে বলে 4-bit-এ truncate হবে — wrap automatic

3. **Combinational loop বানিয়ে ফেলা**
   ```verilog
   assign count = count + 1;  // ভুল! sequential না হয়ে combinational loop
   ```
   - সবসময় `always @(posedge clk)` আর non-blocking assignment-এ রাখো

4. **Internal carry-out প্রয়োজন**
   - যদি counter-কে larger counter-এ chain করতে চাও, `cout = (count == 4'd15)` পোর্ট যোগ করো

5. **Reset-কে negedge-এ assert করলে তাৎক্ষণিক count change আশা করা**
   - Synchronous reset-এ clock অপেক্ষা করতে হবে

---

## 💡 Extra Practice

1. **0–9 BCD Counter** বানাও (10 পর্যন্ত count করে 0-তে ফিরবে)
   ```verilog
   else count <= (count == 4'd9) ? 4'd0 : count + 1;
   ```
2. **Mod-N counter** (N=12 ঘণ্টার ঘড়ির মতো)
3. **4-bit down counter** (15,14,...,0,15)
4. **Two-digit BCD counter** (00–99) — 2টা BCD counter cascade করে
5. **PWM generator** — counter + comparator দিয়ে
6. **Clock divider** — 50 MHz clock-কে 1 Hz-এ নামানোর জন্য 26-bit counter

---

## 🧠 Counter-এর প্রয়োগ (Real Uses)
- **Program Counter (PC):** instruction address increment করে
- **Timer/Counter:** microcontroller-এ delay generation, baud rate generator
- **Frequency divider:** PLL/clock synthesizer
- **State machine counter:** game/FSM-এ step count
- **Memory address generator:** DMA, burst access

---

## 📝 Report-এ কি লিখবে

1. **Objective**
2. **Functional description** — clock-by-clock behavior, wrap
3. **Design code** (synchronous reset, feedback incrementer ব্যাখ্যা)
4. **Expected sequence table** (0–15, wrap)
5. **Testbench code**
6. **Simulation output** (PASS, 18 clock cycles)
7. **Waveform screenshot** — count bus দেখাও
8. **Discussion:**
   - Counter vs register (feedback ইনক্রিমেন্টের ভূমিকা)
   - Modular counting / wrap-around
   - Synchronous reset verification (reset assert but no immediate effect)
   - Clock divider concept
