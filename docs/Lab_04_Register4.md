# Lab 04 — 4-bit Register

> **অধ্যায়:** Sequential Logic (Clocked Circuit)  
> **পূর্বশর্ত:** Lab 01–03 (Combinational logic); এখন clock-ভিত্তিক circuit-এ প্রবেশ  
> **ফাইল:** `design.v` + `testbench.v`

---

## 🎯 লক্ষ্য (Objective)

৪-বিট রেজিস্টার বানানো — এটা আমাদের প্রথম **sequential circuit**। Register হলো 1 clock cycle-এর জন্য data সংরক্ষণকারী memory element। CPU register (like `$t0`, `$s0` in MIPS) এই ধরনের circuit দিয়ে বানানো হয়।

**ইনপুট:**
- `clk` — ঘড়ি সংকেত (clock)
- `reset` — Active-high synchronous reset (1 হলে register clear হয়)
- `enable` — 1 হলে নতুন data load হবে, 0 হলে আগের মান hold করবে
- `d[3:0]` — 4-bit data input (what to store)

**আউটপুট:**
- `q[3:0]` — 4-bit registered output (stored value)

### শিখা যাবে
- **Sequential vs Combinational logic** পার্থক্য
- `always @(posedge clk)` — clocked always block
- **Non-blocking assignment** `<=` (sequential-এ ব্যবহার)
- Synchronous reset vs asynchronous reset
- Clock generator (`always #5 clk = ~clk`)
- `@(posedge clk)` / `@(negedge clk)` — event-based waiting in testbench
- Setup/hold time concept (testbench data change at negedge to avoid race)

---

## 🔌 সার্কিট ডায়াগ্রাম (conceptual)

```
          ┌─────────────┐
d[3:0] ──►│  D inputs   │
          │             │
enable ──►│   4-bit     ├─────► q[3:0] (stored value)
          │  Register   │
reset ───►│             │
          │  posedge clk│
clk ─────►│             │
          └─────────────┘
```

প্রতিটি rising clock edge-এ:
1. যদি `reset = 1` → `q <= 0`
2. না হয় যদি `enable = 1` → `q <= d`
3. না হয় (reset=0, enable=0) → `q` আগের মান ধরে রাখে

---

## 💻 Design Code — `design.v`

```verilog
`timescale 1ns/1ps

// Active-high synchronous reset. Reset has priority over enable.
module register4(
    input clk, reset, enable,
    input [3:0] d,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else if (enable)
            q <= d;
        // With enable = 0, q keeps its previous value.
    end
endmodule
```

### লাইন বাই লাইন ব্যাখ্যা (বিশেষ করে sequential নতুন কনসেপ্ট)

| লাইন | ব্যাখ্যা |
|------|---------|
| `input clk, reset, enable,` | 1-bit control signals |
| `input [3:0] d,` | **4-bit bus** `d[3], d[2], d[1], d[0]` |
| `output reg [3:0] q` | ⚠️ **নতুন:** আউটপুট `reg` type, কারণ আমরা এটাকে `always` ব্লকের ভিতর assign করছি। Combinational module-এ `wire` ছিল; sequential-এ clocked block-এ assign করলে `output reg` লাগে। |
| `always @(posedge clk)` | **সংবেদনশীলতা তালিকায় শুধু clk-এর rising edge।** মানে এই ব্লকের ভিতরের কোড শুধুমাত্র clock-এর rising edge এ execute হবে — other signal changes (d, enable, reset) স্বয়ংক্রিয়ভাবে কিছু করবে না। |
| `if (reset)` | **Synchronous reset:** reset=1 হলেও পরবর্তী clock edge পর্যন্ত অপেক্ষা করবে — তাৎক্ষণিক নয়। |
| `q <= 4'b0000;` | ⚠️ **Non-blocking assignment (`<=`)!** Sequential logic এ সবসময় `<=` ব্যবহার করতে হবে। এতে একই clock edge-এর সব assignment একসাথে (parallel) effect হয়। |
| `else if (enable)` | reset=0 এবং enable=1 হলে load |
| `q <= d;` | d-এর মান q-তে copy |
| (কিছু না) | যখন reset=0, enable=0 — কোনো assignment না করলে `q` synthesizer-এ flip-flop-এর feedback তৈরি করে → আগের মান hold করে। |

### 🚨 `=` vs `<=` (Blocking vs Non-blocking) — সবচেয়ে গুরুত্বপূর্ণ নিয়ম

| | Blocking `=` | Non-blocking `<=` |
|---|---|---|
| ব্যবহার | Combinational `always @*` | Sequential `always @(posedge clk)` |
| কাজ | লাইনটা execute করার সাথে সাথে assignment complete হয় | সব statement read old value, সব শেষে একসাথে assign |
| কেন sequential এ `<=` | একই clock edge-এ একাধিক register update করলে race এড়ায় (e.g., shift register) |

**সহজ নিয়ম:**
- Clock-টাইপ always block-এ → সবসময় `<=`
- Combinational always block-এ → সবসময় `=`
- `assign` বাইরে (continuous) → `=`

### Synchronous vs Asynchronous Reset

**আমরা যা বানিয়েছি — Synchronous Reset:**
```verilog
always @(posedge clk) begin
    if (reset) q <= 0;    // reset ঘড়ির edge-এ কাজ করে
    ...
end
```

**Asynchronous Reset (তাৎক্ষণিক):**
```verilog
always @(posedge clk or posedge reset) begin
    if (reset) q <= 0;    // reset=1 হলে clock না-ও আসুক reset হয়ে যায়
    ...
end
```

### Synchronous reset কেন প্রথম?
- FPGA-এ native flip-flop-এ সাধারণত synchronous reset ভালো সংশ্লেষণ হয়
- Simulation race কম হয়
- Timing analysis সহজ

---

## 🧪 Testbench Code — `testbench.v`

```verilog
`timescale 1ns/1ps

module tb;
    reg clk, reset, enable;
    reg [3:0] d;
    wire [3:0] q;
    integer errors;

    register4 dut(
        .clk(clk), .reset(reset), .enable(enable), .d(d), .q(q)
    );

    // A 10 ns clock period: rising edges at 5, 15, 25, ... ns.
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        reset = 1; enable = 1; d = 4'd15;

        // Check after the rising edge, allowing <= updates to complete.
        @(posedge clk); #1;
        if (q !== 4'd0) errors = errors + 1;
        $display("Reset overrides enable: q=%0d (expected 0)", q);

        // Change data and controls at falling edges to avoid clock-edge races.
        @(negedge clk);
        reset = 0; enable = 1; d = 4'd10;
        #1;
        if (q !== 4'd0) errors = errors + 1;
        @(posedge clk); #1;
        if (q !== 4'd10) errors = errors + 1;
        $display("Load 10: q=%0d (expected 10)", q);

        @(negedge clk);
        enable = 0; d = 4'd3;
        @(posedge clk); #1;
        if (q !== 4'd10) errors = errors + 1;
        $display("Hold: q=%0d (expected 10)", q);

        @(negedge clk);
        enable = 1;
        @(posedge clk); #1;
        if (q !== 4'd3) errors = errors + 1;
        $display("Load 3: q=%0d (expected 3)", q);

        @(negedge clk);
        reset = 1;
        #1;
        if (q !== 4'd3) errors = errors + 1;
        @(posedge clk); #1;
        if (q !== 4'd0) errors = errors + 1;
        $display("Synchronous reset: q=%0d (expected 0)", q);

        if (errors == 0) $display("PASS: register");
        else $display("FAIL: register, errors=%0d", errors);
        $finish;
    end
endmodule
```

### Testbench-এ নতুন কনসেপ্ট

| Feature | ব্যাখ্যা |
|---------|---------|
| `initial clk = 0;` | Time 0-এ clock 0-এ শুরু |
| `always #5 clk = ~clk;` | প্রতি 5 ns পর clk toggle করবে (matching `=`, not `<=` — clock generator concurrent process) |
| **Clock period** | 10 ns (0→5 ns: clk=0; 5→15 ns: clk=1; তারপর repeat)। Rising edges: 5, 15, 25, 35, ... ns |
| `@(posedge clk);` | পরের rising edge পর্যন্ত wait করো |
| `@(negedge clk);` | পরের falling edge পর্যন্ত wait করো |
| `#1;` (after posedge) | 1 ns অপেক্ষা করো যাতে non-blocking assignment settle হয় (q update হতে সময় দাও) |

### Test sequence (5টা ধাপ)

| Time region | reset | enable | d | expected q | Test |
|-------------|-------|--------|---|-----------|------|
| 0→5 ns setup; @5ns posedge | 1 | 1 | 15 | 0 | Reset (enable=1 সত্ত্বেও reset প্রায়োরিটি পায়) |
| @10ns negedge: control change | 0 | 1 | 10 | 0 (immediately after negedge) | Data setup; posedge-এর আগে q unchanged |
| @15ns posedge | 0 | 1 | 10 | 10 | Load 10 |
| @20ns negedge: enable=0, d=3 | 0 | 0 | 3 | 10 (after @25ns posedge) | Hold: d=3 এ পরিবর্তন হয় কিন্তু enable=0 বলে load হবে না |
| @30ns negedge: enable=1 | 0 | 1 | 3 | 3 (after @35ns posedge) | Load 3 (d=3 আগেই setup) |
| @40ns negedge: reset=1 | 1 | 1 | 3 | 3 (just after negedge) | Synchronous reset: negedge-এ reset=1 দিলে সাথে সাথে q zero হবে না |
| @45ns posedge | 1 | 1 | 3 | 0 | Reset clock-এর সাথে প্রযোজ্য হয় |

### Data কেন falling edge-এ change করা হয়? (setup time)
বাস্তব ফ্লিপ-ফ্লপ-এর **setup time** নামে একটা requirement থাকে — clock rising edge-এর আগে data কিছুক্ষণ stable থাকতে হয়। Testbench-এ falling edge-এ data change করে (clock period-এর মাঝামাঝি time-এ), আমরা নিশ্চিত করছি যে পরের posedge-এর আগে data পুরোপুরি stable — setup/hold violation নেই।

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
mkdir -p 04_register4 && cd 04_register4
iverilog -g2005 -Wall -s tb -o sim.vvp design.v testbench.v
vvp sim.vvp
```

---

## 📊 Expected Output

```
VCD info: dumpfile dump.vcd opened for output.
Reset overrides enable: q=0 (expected 0)
Load 10: q=10 (expected 10)
Hold: q=10 (expected 10)
Load 3: q=3 (expected 3)
Synchronous reset: q=0 (expected 0)
PASS: register
testbench.v:59: $finish called at 46000 (1ps)
```

---

## 📈 Waveform বিশ্লেষণ (গুরুত্বপূর্ণ!)

এই ল্যাবটা waveform বুঝলে অনেক কিছু শেখা যায়। Signals আনো: `clk`, `reset`, `enable`, `d[3:0]`, `q[3:0]`।

কি দেখবে:
- **clk** 10 ns period-এ square wave (0↔1 toggle)
- **reset** প্রথমে 1, পরে 0, শেষে 1
- **q** শুধুমাত্র clk rising edge এ পরিবর্তন হবে — middle এ কখনো না
- @5ns: q 0→0 (reset, no visible change)
- @15ns: q 0→10 (load)
- @25ns: q unchanged @10 (hold, enable=0) — d=3 হয়েছে কিন্তু q-তে আসেনি
- @35ns: q 10→3 (load)
- @45ns: q 3→0 (sync reset)

**গুরুত্বপূর্ণ পর্যবেক্ষণ:** `d` বা `enable` পরিবর্তন হলেও clock না আসা পর্যন্ত `q`-তে কোনো প্রভাব নেই। এটাই sequential circuit-এর সংজ্ঞা।

---

### 🖱️ EPWave-এ ভালোভাবে waveform দেখার টিপস
- **Ctrl + mouse wheel** দিয়ে zoom in/out; মাউস wheel এ একা scroll করলে সময় axis scroll হয়
- Toolbar-এ **Zoom to Fit** (ম্যাগ্নিফাইং glass + square) বাটন চাপলে পুরো waveform একসাথে fit হয়ে যাবে
- **Radix** dropdown → **Binary** করলে প্রতিটা 1-bit signal 0/1 দেখাবে; bus (multi-bit) signals-এর জন্য Decimal/Hex ব্যবহার করো
- Signal name-এ click করে **Drag** করলে signal-এর order পরিবর্তন (গুরুত্বপূর্ণ signals উপরে তুলে আনা যায়)
- Signal line-এ **এক ক্লিকে cursor** আসে → time point-এর মান বাম পাশে signal name-এর পাশে দেখাবে
- Cursor রেখে **time marker** দেখতে Δ বাটন ব্যবহার করো (দুই cursor-এর মাঝের সময় ব্যবধান)


## ⚠️ Common Mistakes

1. **Sequential block-এ `=` ব্যবহার করা**
   - সবসময় `<=` ব্যবহার করো clocked always-এ
   
2. **`output reg [3:0] q` লিখতে ভুলে যাওয়া**
   - `always` ব্লকে assign করা আউটপুট অবশ্যই `reg` type হবে
   
3. **Sensitivity list-এ অন্য signal রাখা**
   - `always @(posedge clk or posedge reset)` → এটা async reset (আমাদের নয়)
   - শুধু `@(posedge clk)` দিলেই synchronous
   
4. **Testbench-এ `@(posedge clk)`র পর `#1` না দিয়ে সাথে সাথে q check করা**
   - Non-blocking assignment-এর জন্য simulation-এ q update হতে একটু delta-delay লাগে
   - `#1` delay দিয়ে নিশ্চিত হও যে আউটপুট settle হয়েছে

5. **enable=0 অবস্থায় else clause না থাকা — এখানে "no else" ই hold করায়, কিন্তু কখনো কখনু latch warning দিতে পারে**
   - আমাদের code ঠিক আছে; আমরা শুধু reset আর enable শাখা দিয়েছি, অন্যথায় (no assignment) → hold

---

## 💡 Extra Practice

1. **Asynchronous reset** দিয়ে একটা register বানাও (sensitivity list-এ `posedge reset` যোগ করে)
2. **8-bit register** বানাও — `[3:0]` কে `[7:0]` করলেই হবে
3. **4-bit register file** বানাও: 4টা register, read/write address সহ
4. **Shift register** বানাও (each clock bit shifts: q <= {q[2:0], serial_in})

---

## 🧠 CPU-এ register-এর ভূমিকা
- MIPS/RISC-V-এর 32টা register (x0–x31) প্রতিটা এ ধরনের flip-flop/register
- Pipeline register (IF/ID, ID/EX, EX/MEM, MEM/WB) — clock edge-এ instruction-এর ডেটা next stage-এ pass করে
- Program Counter (PC) — প্রতি clock-এ next address load হয়
- Status register (flags: zero, carry, overflow)

---

## 📝 Report-এ কি লিখবে

1. **Objective**
2. **Functional description** — reset/enable truth table
3. **Design code** — বিশেষ করে `always @(posedge clk)` আর `<=` বর্ণনা করো
4. **Timing diagram (কাগজে আঁকো)** — clk, reset, enable, d, q — expected behavior
5. **Testbench code**
6. **Simulation output** (PASS screenshot)
7. **Waveform screenshot** — clock edge-এ q change হচ্ছে সেটা নোট করো
8. **Discussion:**
   - Sequential vs Combinational পার্থক্য
   - Synchronous vs Asynchronous reset
   - `=` vs `<=` কেন গুরুত্বপূর্ণ
