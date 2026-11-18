# Lab 02 — Full Adder

> **অধ্যায়:** Arithmetic Combinational Circuit  
> **পূর্বশর্ত:** Lab 01 শেষ করা — module/assign/testbench pattern জানা  
> **ফাইল:** `design.v` + `testbench.v`

---

## 🎯 লক্ষ্য (Objective)

১-বিট পূর্ণ যোগক (Full Adder) বানানো। Half Adder শুধু দুই বিট যোগ করে; Full Adder তৃতীয় একটা **carry-in** ইনপুটও নেয়, তাই multi-bit adder-এর বিল্ডিং ব্লক (Ripple Carry Adder-এর প্রতিটা stage)।

**ইনপুট:** `a`, `b`, `cin` (carry in from previous stage)  
**আউটপুট:** `sum` (1-bit result), `cout` (carry out to next stage)

### Boolean Equations
- `sum  = a ⊕ b ⊕ cin`
- `cout = (a & b) | (a & cin) | (b & cin)`

### Truth Table (সব 8টা combination)
| a | b | cin | cout | sum | দশমিক (a+b+cin) |
|---|---|-----|------|-----|-----------------|
| 0 | 0 | 0   | 0    | 0   | 0 |
| 0 | 0 | 1   | 0    | 1   | 1 |
| 0 | 1 | 0   | 0    | 1   | 1 |
| 0 | 1 | 1   | 1    | 0   | 2 |
| 1 | 0 | 0   | 0    | 1   | 1 |
| 1 | 0 | 1   | 1    | 0   | 2 |
| 1 | 1 | 0   | 1    | 0   | 2 |
| 1 | 1 | 1   | 1    | 1   | 3 |

### শিখা যাবে
- Multi-input module
- XOR operator `^`
- Bus/concatenation `{cout, sum}`
- `for` loop দিয়ে test case iterate করা
- Reference model দিয়ে self-checking (addition operator ব্যবহার করে expected value compute)

---

## 🔌 সার্কিট ডায়াগ্রাম

```
a  ──┬──────[XOR]───┬──[XOR]───► sum
    │              │
b  ──┼──────[XOR]───┘
    ├──[AND]────┐
    ├──[AND]────┼──[OR]──[OR]──► cout
    ├──[AND]────┘
    │
cin┘
    (a&b)|(a&cin)|(b&cin)
```

অর্থাৎ sum হলো তিনটা ইনপুটের odd parity, cout হলো majority function (2 বা 3 টা 1 থাকলে carry)।

---

## 💻 Design Code — `design.v`

```verilog
`timescale 1ns/1ps

module full_adder(
    input  a, b, cin,
    output sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule
```

### লাইন বাই লাইন ব্যাখ্যা

| লাইন | ব্যাখ্যা |
|------|---------|
| `input a, b, cin,` | ৩টা ১-বিট ইনপুট: দুই operand + carry in |
| `output sum, cout` | ২টা ১-বিট আউটপুট |
| `assign sum = a ^ b ^ cin;` | XOR তিনবার — তিনটা bit-এ মোট 1-এর সংখ্যা odd হলে sum=1 |
| `assign cout = (a & b) \| (a & cin) \| (b & cin);` | যেকোনো দুইটা ইনপুট 1 হলে carry out |

### বিকল্প (আরো সহজ) সূত্র
```verilog
assign {cout, sum} = a + b + cin;
```
Verilog-এ 1-bit addition-এও `+` কাজ করে, বরং automatic carry-সহ result দেয় — `{cout, sum}` মোট 2-bit-এ a+b+cin-এর মান বসে।
এই ল্যাবে Boolean equation-এ করা হয়েছে gate level দেখানোর জন্য; পরের ল্যাবগুলোতে `+` ব্যবহার হবে।

---

## 🧪 Testbench Code — `testbench.v`

```verilog
`timescale 1ns/1ps

module tb;
    reg a, b, cin;
    wire sum, cout;
    integer i, errors;
    reg [1:0] expected;

    full_adder dut(
        .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        $display("a b cin | cout sum");
        // i = 0 to 7 covers every combination of three input bits.
        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i;
            #10;
            // Zero extension preserves the carry in this reference sum.
            expected = {1'b0, a} + {1'b0, b} + {1'b0, cin};
            $display("%b %b  %b  |   %b   %b", a, b, cin, cout, sum);
            if ({cout, sum} !== expected) errors = errors + 1;
        end
        if (errors == 0) $display("PASS: full adder");
        else $display("FAIL: full adder, errors=%0d", errors);
        $finish;
    end
endmodule
```

### নতুন যা দেখা যাচ্ছে

| Feature | ব্যাখ্যা |
|---------|---------|
| `for (i = 0; i < 8; i = i + 1)` | 0 থেকে 7 পর্যন্ত লুপ চলবে (তিনটা ইনপুটের সব 2³=8 combinations) |
| `{a, b, cin} = i;` | Concatenation LHS — `i`-এর 3-বিটকে যথাক্রমে a, b, cin এ বাঁটাই দিচ্ছে (a=MSB, cin=LSB) |
| `reg [1:0] expected;` | 2-বিট register — expected carry+sum রাখার জন্য |
| `{1'b0, a} + {1'b0, b} + {1'b0, cin}` | প্রতিটা ইনপুটকে 2-bit-এ zero-extend করে যোগ করছে, যাতে overflow-এ `cout` তৈরি হয় |
| `if ({cout, sum} !== expected)` | DUT আউটপুটকে 2-bit bus বানিয়ে expected-এর সাথে compare |

### কেন manual truth table লিখতে হলো না?
`for` loop আর Verilog addition operator দিয়ে **reference model** তৈরি করছি — Verilog নিজেই expected value compute করছে। এতে বড় truth table হাতে লিখতে হয় না আর ভুলের সম্ভাবনা কম থাকে।

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

### Local (VS Code Terminal)
```bash
mkdir -p 02_full_adder && cd 02_full_adder
# design.v ও testbench.v রাখার পর:
iverilog -g2005 -Wall -s tb -o sim.vvp design.v testbench.v
vvp sim.vvp
```

---

## 📊 Expected Output

```
VCD info: dumpfile dump.vcd opened for output.
a b cin | cout sum
0 0  0  |   0   0
0 0  1  |   0   1
0 1  0  |   0   1
0 1  1  |   1   0
1 0  0  |   0   1
1 0  1  |   1   0
1 1  0  |   1   0
1 1  1  |   1   1
PASS: full adder
testbench.v:29: $finish called at 80000 (1ps)
```

### যাচাই
8 টা test case, সব PASS. লক্ষ করো:
- যখন শুধু একটা ইনপুট 1 → sum=1, cout=0
- যখন দুইটা ইনপুট 1 → sum=0, cout=1
- যখন তিনটাই 1 → sum=1, cout=1 (1+1+1 = 3 = 11₂)

---

## 📈 Waveform বিশ্লেষণ

Signals: `a`, `b`, `cin`, `sum`, `cout`

- প্রতি 10 ns পর interval পরিবর্তন
- Time 0-10: all zeros → sum=0, cout=0
- Time 30-40 (a=0, b=1, cin=1): sum=0, cout=1 (দুইটা 1)
- Time 70-80 (all 1s): sum=1, cout=1 (তিনটা 1 → 3 decimal)

**Key observation:** `sum` এ 1ns এর ছোট glitch দেখা যেতে পারে (যখন একাধিক gate delay mismatch করে); তারপর settle হয়। আমাদের coarse timescale-এ এটা সাধারণত দেখা যায় না কিন্তু বাস্তব হার্ডওয়্যারে হয়।

---

### 🖱️ EPWave-এ ভালোভাবে waveform দেখার টিপস
- **Ctrl + mouse wheel** দিয়ে zoom in/out; মাউস wheel এ একা scroll করলে সময় axis scroll হয়
- Toolbar-এ **Zoom to Fit** (ম্যাগ্নিফাইং glass + square) বাটন চাপলে পুরো waveform একসাথে fit হয়ে যাবে
- **Radix** dropdown → **Binary** করলে প্রতিটা 1-bit signal 0/1 দেখাবে; bus (multi-bit) signals-এর জন্য Decimal/Hex ব্যবহার করো
- Signal name-এ click করে **Drag** করলে signal-এর order পরিবর্তন (গুরুত্বপূর্ণ signals উপরে তুলে আনা যায়)
- Signal line-এ **এক ক্লিকে cursor** আসে → time point-এর মান বাম পাশে signal name-এর পাশে দেখাবে
- Cursor রেখে **time marker** দেখতে Δ বাটন ব্যবহার করো (দুই cursor-এর মাঝের সময় ব্যবধান)


## 🧠 Half Adder vs Full Adder

| | Half Adder | Full Adder |
|---|-----------|------------|
| Inputs | a, b | a, b, cin |
| Outputs | sum, cout | sum, cout |
| Sum eq | a⊕b | a⊕b⊕cin |
| Cout eq | a·b | a·b + a·cin + b·cin |
| Use | LSB stage only | সব middle stage |

**Ripple Carry Adder (4-bit):** 4টা Full Adder chain করে বানানো যায় — প্রতিটার `cout` পরেরটার `cin`-এ যায়।

```
a0,b0 a1,b1 a2,b2 a3,b3
  │     │     │     │
  ▼     ▼     ▼     ▼
 [FA0]─[FA1]─[FA2]─[FA3]── cout4
  │     │     │     │
 s0    s1    s2    s3
```

---

## ⚠️ Common Mistakes

1. **`cout = a & b & cin` (ভুল)**
   - এটা সব তিনটা 1 হলে 1 দেবে; কিন্তু দুইটা 1 হলেও cout=1 হওয়া উচিত
   - সঠিক: `(a&b) | (a&cin) | (b&cin)`

2. **`sum = a + b + cin` directly assign করলে 2-bit result হয়**
   - sum 1-bit হলে শুধু LSB পাবে; cout আলাদা লাগবে — নয়তো `{cout, sum} = a + b + cin` ব্যবহার করো

3. **Concatenation order ভুল**
   - `{cout, sum}` মানে cout = bit-1 (MSB), sum = bit-0 (LSB)
   - `{sum, cout}` লিখলে carry/sign bit ভুল place-এ যাবে

4. **for loop-এ `i`-কে `reg` না করে `integer` করা (ঠিক আছে)**
   - Verilog-এ `integer` loop counter হিসেবে ব্যবহার করা সাধারণ; integer 32-bit signed হয়

---

## 💡 Extra Practice

1. **Half Adder বানাও** (শুধু a, b — no cin)
2. **4-bit Ripple Carry Adder** বানাও 4টা full_adder instantiate করে:
   ```verilog
   module rca4(input [3:0] a, b, input cin, output [3:0] s, output cout);
       wire c1, c2, c3;
       full_adder fa0(a[0], b[0], cin, s[0], c1);
       full_adder fa1(a[1], b[1], c1, s[1], c2);
       full_adder fa2(a[2], b[2], c2, s[2], c3);
       full_adder fa3(a[3], b[3], c3, s[3], cout);
   endmodule
   ```
3. Testbench-এ manual error check যোগ করো যখন loop ব্যবহার না করে

---

## 📝 Report-এ কি লিখবে

1. **Objective**
2. **Truth table**
3. **Boolean equations** (sum, cout)
4. **Design code** (with comment)
5. **Testbench code**
6. **Simulation output** (PASS screenshot)
7. **Waveform screenshot** (a, b, cin, sum, cout একসাথে)
8. **Discussion:** Half vs Full Adder, Ripple Carry concept
