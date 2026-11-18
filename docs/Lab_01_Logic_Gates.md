# Lab 01 — Logic Gates (AND, OR, NOT)

> **অধ্যায়:** Combinational Logic  
> **পূর্বশর্ত:** Verilog module, `assign`, dataflow modeling-এর basic ধারণা  
> **Tools:** EDA Playground (Icarus Verilog) অথবা Local Icarus Verilog  
> **ফাইল:** `design.v` (DUT) + `testbench.v` (TB)

---

## 🎯 লক্ষ্য (Objective)

এই ল্যাবে প্রথমবারের মতো Verilog মডিউল লিখবে — তিনটা মৌলিক লজিক গেট বানাবে:
1. **AND gate** (`&`): দুই ইনপুটই 1 হলে আউটপুট 1
2. **OR gate** (`|`): যেকোনো এক ইনপুট 1 হলে আউটপুট 1
3. **NOT gate** (`~`): ইনপুটকে invert করবে (1 কে 0, 0 কে 1)

### Truth Table
| a | b | AND (a&b) | OR (a\|b) | NOT a (~a) |
|---|---|-----------|-----------|------------|
| 0 | 0 | 0 | 0 | 1 |
| 0 | 1 | 0 | 1 | 1 |
| 1 | 0 | 0 | 1 | 0 |
| 1 | 1 | 1 | 1 | 0 |

### শিখা যাবে
- Verilog-এ module port declaration
- `assign` statement দিয়ে continuous assignment
- Testbench-এ DUT instantiation
- `$display`, `$dumpfile`, `$dumpvars`, `$finish` ব্যবহার
- Time delay `#10` দিয়ে input change করা
- Self-checking testbench (error count সহ PASS/FAIL)

---

## 🔌 সার্কিট ডায়াগ্রাম (conceptual)

```
a ──┬───────┐   ┌──────────┐ y_and
    ├─[AND]─┼──►│          │
b ──┼───────┘   │ logic    │ y_or
    │           │ _gates   ├──────►
    ├─[OR]─────►│          │
    │           └──────────┘ y_not
    └─[NOT(a)]──────────────────►
```

তিনটা গেট একসাথে একই মডিউলে — স্বাধীনভাবে কাজ করছে।

---

## 💻 Design Code — `design.v`

```verilog
// Three simple logic gates. y_not is the inverse of a.
`timescale 1ns/1ps

module logic_gates(
    input  a, b,
    output y_and, y_or, y_not
);
    assign y_and = a & b;
    assign y_or  = a | b;
    assign y_not = ~a;
endmodule
```

### লাইন বাই লাইন ব্যাখ্যা

| লাইন | ব্যাখ্যা |
|------|---------|
| `` `timescale 1ns/1ps `` | Simulation time unit = 1 ns, time precision = 1 ps. মানে `#10` = 10 ns delay। দুই ফাইলে (design + testbench) একই timescale দিতে হবে। |
| `module logic_gates(...);` | Module শুরু — নাম `logic_gates`। অন্য module (testbench) এই নামে এটাকে instantiate করবে। |
| `input a, b,` | ১-বিট দুইটা ইনপুট পোর্ট। |
| `output y_and, y_or, y_not` | ১-বিট তিনটা আউটপুট পোর্ট। |
| `assign y_and = a & b;` | **Continuous assignment** — `a & b`-এর মান সবসময় `y_and`-এ চালিত থাকবে। Combinational logic। `&` হলো bitwise AND। |
| `assign y_or = a \| b;` | Bitwise OR (সতর্ক: `|` pipe চিহ্ন, I অক্ষর না)। |
| `assign y_not = ~a;` | Bitwise NOT (বা unary NOT) — `a`-এর 1's complement। |
| `endmodule` | Module শেষ। |

### কি করছে এই circuit?
এটা **combinational circuit** — মানে inputs পরিবর্তনের সাথে সাথে (simulation-এ zero delay-তে) outputs পরিবর্তন হয়। Clock, register, কোনো state নেই। দুইটা input দিলে তিনটা output wire তাৎক্ষণিকভাবে উত্তর দেবে।

---

## 🧪 Testbench Code — `testbench.v`

```verilog
`timescale 1ns/1ps

module tb;
    reg a, b;
    wire y_and, y_or, y_not;
    integer errors;

    logic_gates dut(
        .a(a), .b(b),
        .y_and(y_and), .y_or(y_or), .y_not(y_not)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        $display("a b | AND OR NOT_a");

        a = 0; b = 0; #10;
        $display("%b %b |  %b   %b    %b", a, b, y_and, y_or, y_not);
        if ({y_and, y_or, y_not} !== 3'b001) errors = errors + 1;

        a = 0; b = 1; #10;
        $display("%b %b |  %b   %b    %b", a, b, y_and, y_or, y_not);
        if ({y_and, y_or, y_not} !== 3'b011) errors = errors + 1;

        a = 1; b = 0; #10;
        $display("%b %b |  %b   %b    %b", a, b, y_and, y_or, y_not);
        if ({y_and, y_or, y_not} !== 3'b010) errors = errors + 1;

        a = 1; b = 1; #10;
        $display("%b %b |  %b   %b    %b", a, b, y_and, y_or, y_not);
        if ({y_and, y_or, y_not} !== 3'b110) errors = errors + 1;

        if (errors == 0) $display("PASS: logic gates");
        else $display("FAIL: logic gates, errors=%0d", errors);
        $finish;
    end
endmodule
```

### Testbench গঠন বুঝি

**Testbench = circuit test করার জন্য wrapper।** এটাতে কখনোই port থাকে না (module-এর `()` খালি থাকে) — এটা simulation-এর top-level।

| অংশ | কি করছে |
|------|---------|
| `reg a, b;` | Testbench-এর inputs যা আমরা manually drive করব — **reg** (registers-এ value assign করা যায়)। |
| `wire y_and, y_or, y_not;` | DUT-এর outputs আসবে এই wires-এ। `wire` driven signal। |
| `integer errors;` | Error count রাখার integer variable। |
| `logic_gates dut( .a(a), .b(b), ... );` | **DUT (Device Under Test) instantiation**। নাম দিয়েছি `dut`। `.port(wire)` সিনট্যাক্স = named port connection। |
| `initial begin ... end` | একবার (time 0 এ) শুরু হয়ে শেষ হয় এমন প্রসিডিউরাল ব্লক। |
| `$dumpfile("dump.vcd");` | VCD (Value Change Dump) waveform ফাইলের নাম। |
| `$dumpvars(0, tb);` | `tb` মডিউলের নিচের সব signal-কে dump করো (0 = সব depth)। |
| `a = 0; b = 0; #10;` | Time 0-এ inputs set করলাম, তারপর 10 ns wait করলাম (যাতে DUT output settle হয়)। |
| `$display("%b %b \| %b %b %b", ...);` | Binary format (`%b`) এ console-এ print করো। |
| `` {y_and, y_or, y_not} !== 3'b001 `` | Concatenation: তিনটা আউটপুটকে 3-বিট bus বানিয়ে expected value-এর সাথে compare। `!==` (case inequality) দিয়ে X/Z state-ও check হয়। |
| `errors = errors + 1;` | Mismatch হলে error counter বাড়াও। |
| `$finish;` | Simulation শেষ করো। |

### Test pattern
চারটা (a,b) combination দেওয়া হয়েছে: (0,0), (0,1), (1,0), (1,1) — সব সম্ভাব্য 2-input combination। প্রতিটার পর 10 ns delay, output check। শেষে PASS/FAIL report।

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

### Local-এ (VS Code Terminal)

```bash
mkdir -p 01_logic_gates
cd 01_logic_gates
# design.v ও testbench.v এই folder-এ রাখার পর:
iverilog -g2005 -Wall -s tb -o sim.vvp design.v testbench.v
vvp sim.vvp
gtkwave dump.vcd   # waveform দেখতে
```

---

## 📊 Expected Output

```
VCD info: dumpfile dump.vcd opened for output.
a b | AND OR NOT_a
0 0 |  0   0    1
0 1 |  0   1    1
1 0 |  0   1    0
1 1 |  1   1    0
PASS: logic gates
```

### Output বুঝি
- প্রতি লাইনে ১০ ns পর পর input change করা হয়েছে → output সাথে সাথে change হয়
- শেষ লাইনে `PASS: logic gates` আসলে সব 4 টা combination সঠিক
- কোথাও mismatch হলে `FAIL: logic gates, errors=N` দেখাবে

---

## 📈 Waveform-এ কি দেখবে (GTKWave / EPWave)

নিচের signals drag করে waveform panel-এ আনো: `a`, `b`, `y_and`, `y_or`, `y_not`।

কি দেখতে পাবে:
- Time 0–10 ns: a=0, b=0 → y_and=0, y_or=0, y_not=1
- Time 10–20 ns: a=0, b=1 → y_and=0, y_or=1, y_not=1
- Time 20–30 ns: a=1, b=0 → y_and=0, y_or=1, y_not=0
- Time 30–40 ns: a=1, b=1 → y_and=1, y_or=1, y_not=0

**লক্ষণীয়:** `y_not` শুধু `a`-এর উপর নির্ভরশীল — `b` পরিবর্তন হলেও `y_not` একই থাকে যতক্ষণ না `a` পরিবর্তন হয়।

---

### 🖱️ EPWave-এ ভালোভাবে waveform দেখার টিপস
- **Ctrl + mouse wheel** দিয়ে zoom in/out; মাউস wheel একা scroll করলে সময় axis scroll হয়
- Toolbar-এ **Zoom to Fit** (ম্যাগ্নিফাইং glass + square) বাটন চাপলে পুরো waveform একসাথে fit হয়ে যাবে
- **Radix** dropdown → **Binary** করলে প্রতিটা 1-bit signal 0/1 দেখাবে
- Signal name-এ click করে **Drag** করলে signal-এর order পরিবর্তন
- Signal line-এ **এক ক্লিকে cursor** আসে → time point-এর মান বাম পাশে দেখাবে
- Δ বাটন ব্যবহার করে দুই cursor-এর মাঝের সময় ব্যবধান মাপা যায়


## ⚠️ Common Mistakes (সাধারণ ভুল)

1. **`=` vs `==` vs `===` confusion**
   - Assignment: `a = 0;`
   - Comparison: `if (y_and == 1'b0)`
   - Testbench-এ `!==` ব্যবহার করা ভালো (4-state compare: 0/1/X/Z)

2. **Port connection-এ `,` ভুলে যাওয়া**
   ```verilog
   logic_gates dut(
       .a(a),   // <-- এই comma চাই
       .b(b)
   );
   ```

3. **Output port-কে testbench-এ `reg` declare করা**
   - DUT-এর output সবসময় testbench-এ `wire` type হবে (কারণ `reg` কে অন্য module drive করতে পারে না)।

4. **`$dumpfile("dump.vcd")` না লেখা**
   - Waveform দেখাবে না।

5. **`#10` delay না দিয়ে check করা**
   - Zero-delay race condition হতে পারে; একটু delay দিলে output settle হয়।

6. **EDA Playground-এ design file না বানানো**
   - সব কোড testbench panel-এ রাখলে `logic_gates` module পাবে না।

---

## 💡 Extra Practice (নিজে practice করার জন্য)

1. আরেকটা আউটপুট যোগ করো `y_nand = ~(a & b)` (NAND gate)
2. XOR gate যোগ করো `y_xor = a ^ b`
3. `if` ব্যবহার না করে শুধু `$display` print করেই manually check করো
4. 3-input AND gate বানানোর চেষ্টা করো: `input a,b,c; output y; assign y = a & b & c;`

---

## 📝 Report-এ কি লিখবে

1. **Objective** — 3-input AND/OR/NOT behavior verifications
2. **Truth table** — উপরের টেবিলটা
3. **Design code** — `design.v` কপি করে লাগাও
4. **Testbench code** — `testbench.v` কপি করে লাগাও
5. **Simulation output screenshot** — log panel-এর PASS message screenshot
6. **Waveform screenshot** — GTKWave/EPWave থেকে
7. **Conclusion** — সব test case pass করেছে, combinational logic যথাযথ কাজ করছে
