# Lab 03 — 2-to-1 Multiplexer (MUX)

> **অধ্যায়:** Data Selection / Steering Logic  
> **পূর্বশর্ত:** Lab 01 (module, assign)  
> **ফাইল:** `design.v` + `testbench.v`

---

## 🎯 লক্ষ্য (Objective)

২-থেকে-১ মাল্টিপ্লেক্সার (2:1 MUX) বানানো। MUX হলো একটা ডিজিটাল সুইচ — সিলেক্ট লাইনের মান অনুযায়ী দুইটা ইনপুটের যেকোনো একটাকে আউটপুটে পাঠায়। CPU-এ register selection, ALU input routing, bus sharing ইত্যাদি কাজে MUX ব্যবহার হয়।

**ইনপুট:** `a` (data 0), `b` (data 1), `sel` (select line)  
**আউটপুট:** `y`

### Function Table
| sel | y |
|-----|---|
| 0   | a (pass channel 0) |
| 1   | b (pass channel 1) |

### Boolean Equation
`y = (¬sel & a) | (sel & b)`  বা Verilog-এ `y = sel ? b : a;`

### শিখা যাবে
- Ternary operator (`?:`)
- Behavioral dataflow — শর্ত অনুযায়ী select
- Edge cases: same inputs (a=b=0/1) — output control-dependent না data-dependent
- MUX-এর বাস্তব ব্যবহার

---

## 🔌 সার্কিট ডায়াগ্রাম

```
a ───────┬─[AND with ~sel]──┐
         │                   ├──[OR]──► y
b ────┬──┴─[AND with  sel]──┘
     │
     └[NOT]──► ~sel
     │
sel─►┘
```

দুইটা AND gate (decoder) + একটা OR gate = 2:1 MUX।

---

## 💻 Design Code — `design.v`

```verilog
`timescale 1ns/1ps

module mux2(
    input  a, b, sel,
    output y
);
    assign y = sel ? b : a;
endmodule
```

### বিস্তারিত ব্যাখ্যা

| লাইন | ব্যাখ্যা |
|------|---------|
| `input a, b, sel,` | দুই ডেটা ইনপুট (a, b) + একটা সিলেক্ট ইনপুট (sel) |
| `output y` | এক-বিট আউটপুট |
| `` assign y = sel ? b : a; `` | **Ternary (conditional) operator** — C/Java-এর মতো। যদি `sel` সত্য (non-zero) হয়, তবে `y = b`; না হয় `y = a`। |

### Equivalent লেখা শৈলী
এই একই circuit তিনভাবে লেখা যায়:

**(1) Ternary operator (সংক্ষিপ্ত, সবচেয়ে পাঠযোগ্য):**
```verilog
assign y = sel ? b : a;
```

**(2) Boolean equation (gate level):**
```verilog
assign y = (~sel & a) | (sel & b);
```

**(3) always @* সহ if-else (behavioral):**
```verilog
reg y;
always @* begin
    if (sel)
        y = b;
    else
        y = a;
end
```

তিনটাই একই সার্কিট তৈরি করবে (synthesis-এর পর)। আমরা প্রথমটা (ternary) ব্যবহার করছি কারণ এটা সংক্ষিপ্ত।

### ⚠️ Ternary-এ order গুরুত্বপূর্ণ
`sel ? b : a`  মানে:
- sel=1 → select `b` (input 1)
- sel=0 → select `a` (input 0)

`sel ? a : b` লিখলে উল্টো কাজ করবে (channel swap)।

---

## 🧪 Testbench Code — `testbench.v`

```verilog
`timescale 1ns/1ps

module tb;
    reg a, b, sel;
    wire y;
    integer errors;

    mux2 dut(.a(a), .b(b), .sel(sel), .y(y));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        $display("a b sel | y");

        a = 0; b = 1; sel = 0; #10;
        $display("%b %b  %b  | %b", a, b, sel, y);
        if (y !== 1'b0) errors = errors + 1;

        sel = 1; #10;
        $display("%b %b  %b  | %b", a, b, sel, y);
        if (y !== 1'b1) errors = errors + 1;

        a = 1; b = 0; sel = 0; #10;
        $display("%b %b  %b  | %b", a, b, sel, y);
        if (y !== 1'b1) errors = errors + 1;

        sel = 1; #10;
        $display("%b %b  %b  | %b", a, b, sel, y);
        if (y !== 1'b0) errors = errors + 1;

        a = 0; b = 0; sel = 0; #10;
        if (y !== 1'b0) errors = errors + 1;
        sel = 1; #10;
        if (y !== 1'b0) errors = errors + 1;

        a = 1; b = 1; sel = 0; #10;
        if (y !== 1'b1) errors = errors + 1;
        sel = 1; #10;
        if (y !== 1'b1) errors = errors + 1;

        if (errors == 0) $display("PASS: multiplexer");
        else $display("FAIL: multiplexer, errors=%0d", errors);
        $finish;
    end
endmodule
```

### Test Pattern বুঝি

Testbench-এ 4টা দৃশ্য test করা হয়েছে (মোট 6টা check):

| পর্ব | a | b | sel | Expected y | ব্যাখ্যা |
|------|---|---|-----|-----------|---------|
| 1 | 0 | 1 | 0 | 0 | sel=0 → select a (which is 0) |
| 2 | 0 | 1 | 1 | 1 | sel=1 → select b (which is 1) |
| 3 | 1 | 0 | 0 | 1 | sel=0 → select a (which is 1) |
| 4 | 1 | 0 | 1 | 0 | sel=1 → select b (which is 0) |
| 5 | 0 | 0 | 0→1 | 0 | দুই channel-এই 0, sel যাই হোক output 0 |
| 6 | 1 | 1 | 0→1 | 1 | দুই channel-এই 1, sel যাই হোক output 1 |

### কেন a=0,b=0 এবং a=1,b=1 case গুরুত্বপূর্ণ?
এগুলো দিয়ে test করা হয় যে sel-এর জন্য gate glitch বা অন্য কোনো bug output খারাপ করছে কিনা। যখন দুই ইনপুট একই, তখন y অবশ্যই সেই মান হবে sel যাই হোক। যদি কোনো কারণে a বা b ভুলভাবে wire করা হয় (a=b short circuit ইত্যাদি), এই case-গুলো ধরবে।

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
mkdir -p 03_mux2 && cd 03_mux2
iverilog -g2005 -Wall -s tb -o sim.vvp design.v testbench.v
vvp sim.vvp
```

---

## 📊 Expected Output

```
VCD info: dumpfile dump.vcd opened for output.
a b sel | y
0 1  0  | 0
0 1  1  | 1
1 0  0  | 1
1 0  1  | 0
PASS: multiplexer
```

**Note:** শেষের 4টা check (a=b=0 এবং a=b=1 case) `$display` দিয়ে print করা হয়নি কারণ সেগুলোর result transitional states; তবে সেগুলো self-check এ count হয়েছে — সব pass করলেই `PASS` আসছে।

---

## 📈 Waveform বিশ্লেষণ

Signals আনো: `a`, `b`, `sel`, `y`

- Time 0-10 ns: a=0, b=1, sel=0 → y=0 (a selected)
- Time 10-20 ns: sel switches to 1 → y switches to 1 (b selected)
- Time 20-30 ns: a=1, b=0, sel=0 → y=1 (a selected)
- Time 30-40 ns: sel=1 → y=0 (b selected)

**লক্ষণীয়:** `y` সবসময় `sel`-দ্বারা selected channel-এর মান অনুসরণ করছে। Non-selected channel-এর মান পরিবর্তনে `y`-এর উপর প্রভাব নেই (ideal MUX-এ)।

---

### 🖱️ EPWave-এ ভালোভাবে waveform দেখার টিপস
- **Ctrl + mouse wheel** দিয়ে zoom in/out; মাউস wheel এ একা scroll করলে সময় axis scroll হয়
- Toolbar-এ **Zoom to Fit** (ম্যাগ্নিফাইং glass + square) বাটন চাপলে পুরো waveform একসাথে fit হয়ে যাবে
- **Radix** dropdown → **Binary** করলে প্রতিটা 1-bit signal 0/1 দেখাবে; bus (multi-bit) signals-এর জন্য Decimal/Hex ব্যবহার করো
- Signal name-এ click করে **Drag** করলে signal-এর order পরিবর্তন (গুরুত্বপূর্ণ signals উপরে তুলে আনা যায়)
- Signal line-এ **এক ক্লিকে cursor** আসে → time point-এর মান বাম পাশে signal name-এর পাশে দেখাবে
- Cursor রেখে **time marker** দেখতে Δ বাটন ব্যবহার করো (দুই cursor-এর মাঝের সময় ব্যবধান)


## 🏗️ বৃহত্তর MUX

### 4-to-1 MUX (using 2:1 MUX tree)
2-বিট select লাইন থাকলে 4টা ইনপুট থেকে 1টা select করা যায়:

```verilog
module mux4(
    input  a, b, c, d,
    input  [1:0] sel,
    output y
);
    wire lo, hi;
    mux2 m0(a, b, sel[0], lo);   // first pair
    mux2 m1(c, d, sel[0], hi);   // second pair
    mux2 m2(lo, hi, sel[1], y);  // select pair
endmodule
```

### N-bit wide MUX (bus MUX)
1-bit না করে পুরো N-bit bus select করতে চাইলে:

```verilog
module mux2_N #(parameter N=4)(
    input  [N-1:0] a, b,
    input  sel,
    output [N-1:0] y
);
    assign y = sel ? b : a;
endmodule
```

### CPU-এ MUX-এর ব্যবহার
- **Register file** — read register select
- **ALU operand selection** — immediate vs register
- **PC next source** — PC+4 vs branch target vs jump target
- **Memory write data select** — which register to store

---

## ⚠️ Common Mistakes

1. **Ternary-এ order উল্টানো**
   - `sel ? a : b` (ভুল) vs `sel ? b : a` (সঠিক যদি sel=1 তে b চাও)
   - সবসময় truth table দিয়ে verify করো

2. **Inferred latch (when using always)**
   - যদি `always @*` ব্যবহার করো, নিশ্চিত করো সব case-এ y assign হচ্ছে
   - `if/else` লেখলে `else` অবশ্যই দিতে হবে

3. **sel-কে 1-bit না করে bus বানানো ভুলে**
   - 2:1 MUX-এ sel শুধু 1-বিট

4. **Testbench-এ দুই ইনপুট same হলে test না করা**
   - Border case গুলো bug ধরার সবচেয়ে ভালো উপায়

---

## 💡 Extra Practice

1. **4-to-1 MUX** বানাও 2-bit `sel`, 4টা ইনপুট নিয়ে
   ```verilog
   always @* begin
       case (sel)
           2'b00: y = a;
           2'b01: y = b;
           2'b10: y = c;
           2'b11: y = d;
       endcase
   end
   ```
2. 8-to-1 MUX বানানোর চেষ্টা করো
3. 4-bit wide 2-to-1 MUX বানাও (N-bit parameter দিয়ে)
4. Gate-level (AND/OR/NOT) দিয়ে একই MUX বানিয়ে দেখো

---

## 📝 Report-এ কি লিখবে

1. **Objective** — 2:1 MUX function verification
2. **Function table**
3. **Boolean equation + gate diagram**
4. **Design code** (তিনটা equivalent form দেখাতে পারো)
5. **Testbench code**
6. **Simulation output screenshot**
7. **Waveform screenshot**
8. **Discussion:** MUX-এর ব্যবহার — CPU-এ কিভাবে ব্যবহার হয়
