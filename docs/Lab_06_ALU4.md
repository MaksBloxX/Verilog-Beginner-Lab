# Lab 06 — 4-bit ALU (Arithmetic Logic Unit)

> **অধ্যায়:** Combinational Datapath Component — CPU core  
> **পূর্বশর্ত:** Lab 01–05 (এটা combinational; clock নাই)  
> **ফাইল:** `design.v` + `testbench.v`

---

## 🎯 লক্ষ্য (Objective)

৪-বিট **ALU (Arithmetic Logic Unit)** বানানো — CPU-এর সবচেয়ে গুরুত্বপূর্ণ কম্পোনেন্ট যেখানে arithmetic (+, −) এবং logical (&, |) অপারেশন করা হয়।

**ইনপুট:**
- `a[3:0]`, `b[3:0]` — 4-bit operands
- `op[1:0]` — 2-bit operation select

**আউটপুট:**
- `result[3:0]` — 4-bit operation result

### Operation Table
| op | অপারেশন | description |
|----|---------|-------------|
| 00 | ADD | `a + b` (low 4 bits; carry discarded) |
| 01 | SUB | `a − b` (unsigned 4-bit result) |
| 10 | AND | `a & b` (bitwise) |
| 11 | OR  | `a \| b` (bitwise) |

### শিখা যাবে
- `always @(*)` দিয়ে combinational logic (behavioral)
- `case` statement (multiplexer-style operation selection)
- `default` case দিয়ে latch inference প্রতিরোধ
- Arithmetic overflow (4-bit result truncation)
- Two's complement subtraction in unsigned context
- Register + MUX + Adder = ALU concept

---

## 🔌 ALU block diagram

```
a[3:0] ──┬─────────┐
          │  ADD    │
b[3:0] ──┬┤         ├────┐
          │  SUB    │    │    ┌──────────┐
          │         ├────┼───►│          │
          │  AND    │    │    │  4-to-1  │ result[3:0]
          │         ├────┼───►│   MUX    ├────────────►
          │  OR     │    │    │(op-sel)  │
          │         ├────┘    └────┬─────┘
          └─────────┘              │
                                   ▲
                              op[1:0]
```

অর্থাৎ: চারটা function unit (ADD, SUB, AND, OR) সবসময় গণনা করছে; `op` দিয়ে 4-to-1 MUX-এর সিলেক্ট লাইন বেছে নেয় কোনটা result-এ যাবে।

---

## 💻 Design Code — `design.v`

```verilog
`timescale 1ns/1ps

// Four operations, selected by op. Only the low four result bits are kept.
module alu4(
    input  [3:0] a, b,
    input  [1:0] op,
    output reg [3:0] result
);
    always @* begin
        case (op)
            2'b00: result = a + b;
            2'b01: result = a - b;
            2'b10: result = a & b;
            2'b11: result = a | b;
            default: result = 4'b0000;
        endcase
    end
endmodule
```

### লাইন বাই লাইন ব্যাখ্যা (নতুন কনসেপ্ট)

| লাইন | ব্যাখ্যা |
|------|---------|
| `input [3:0] a, b,` | 4-bit দুই operand — a এবং b |
| `input [1:0] op,` | 2-bit opcode — 4টা অপারেশন সিলেক্ট করে (00, 01, 10, 11) |
| `output reg [3:0] result` | 4-bit output; `reg` কারণ আমরা `always` ব্লকে assign করছি (though it's combinational) |
| `always @* begin` | **Combinational always block**। `@*` মানে "সব ইনপুট (a, b, op) পরিবর্তনে trigger" — sensitivity list automatic। Sequential-এ `@(posedge clk)` ছিল; combinational-এ `@*` (or `@(*)`) ব্যবহার হয়। |
| `case (op)` | `op`-এর মান অনুযায়ী branch। এটা 4-to-1 MUX-এর মতো কাজ করছে। |
| `2'b00: result = a + b;` | Binary 00 = ADD (blocking `=` because combinational!) |
| `2'b01: result = a - b;` | SUB |
| `2'b10: result = a & b;` | Bitwise AND |
| `2'b11: result = a \| b;` | Bitwise OR |
| `default: result = 4'b0000;` | **Latch প্রতিরোধ:** যদি কোনো কারণে op 4-state (X/Z) হয়, তখন যেন result একটা নির্দিষ্ট মান পায়। এটা না দিলে synthesis টুল latch তৈরি করবে (যা combinational circuit-এ অবাঞ্ছিত)। |

### 🚨 Blocking `=` কেন?
এটা **combinational** circuit (clock নাই), তাই blocking assignment `=` ব্যবহার করা হয়। Non-blocking `<=` sequential-এর জন্য। মনে রাখো:

| Block type | Assignment |
|-----------|-----------|
| `always @(posedge clk)` (clocked) | `<=` non-blocking |
| `always @*` (combinational) | `=` blocking |
| `assign` (continuous) | `=` |

### 🧮 4-bit result truncation
Verilog-এ `a + b` করলে 4-bit + 4-bit = 5-bit result (extra carry) হতে পারে (যেমন 15+1=16 → 10000)। কিন্তু যেহেতু result শুধু 4-bit wide, assignment এর সময় upper bit (carry-out) truncate হয়ে যায়। এটাই আমাদের কাঙ্ক্ষিত ("only the low four result bits are kept")।

### ➕ ADD বিস্তারিত (a + b)
- 6 + 3 = 9 (0110 + 0011 = 1001) ✓
- 15 + 1 = 0 (1111 + 0001 = 10000 → low 4 bits 0000) overflow

### ➖ SUB বিস্তারিত (a − b)
Unsigned 4-bit arithmetic এ a − b when a < b দেখলে underflow হয়।
- 6 − 3 = 3 (0110 − 0011 = 0011) ✓
- 3 − 5 = 14 (0011 − 0101): 3 − 5 = −2, কিন্তু unsigned 4-bit এ দেখালে two's complement wrap: −2 ≡ 14 (mod 16) → 1110

Two's complement ব্যাখ্যা:
- −2 এর 4-bit two's complement = 2⁴ − 2 = 14 → 1110
- Verilog unsigned subtraction-এ স্বয়ংক্রিয়ভাবে modulo-16 হয়

### & AND বিস্তারিত
- 6 (0110) AND 3 (0011) = 0010 = 2 (bitwise)

### | OR বিস্তারিত
- 6 (0110) OR 3 (0011) = 0111 = 7 (bitwise)

---

## 🧪 Testbench Code — `testbench.v`

```verilog
`timescale 1ns/1ps

module tb;
    reg [3:0] a, b;
    reg [1:0] op;
    wire [3:0] result;
    integer errors;

    alu4 dut(.a(a), .b(b), .op(op), .result(result));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        a = 4'd6; b = 4'd3;

        op = 2'b00; #10;
        $display("6 + 3 = %0d (expected 9)", result);
        if (result !== 4'd9) errors = errors + 1;

        op = 2'b01; #10;
        $display("6 - 3 = %0d (expected 3)", result);
        if (result !== 4'd3) errors = errors + 1;

        op = 2'b10; #10;
        $display("6 AND 3 = %0d (expected 2)", result);
        if (result !== 4'd2) errors = errors + 1;

        op = 2'b11; #10;
        $display("6 OR 3 = %0d (expected 7)", result);
        if (result !== 4'd7) errors = errors + 1;

        a = 4'd15; b = 4'd1; op = 2'b00; #10;
        $display("15 + 1 = %0d (expected 0 in four bits)", result);
        if (result !== 4'd0) errors = errors + 1;

        a = 4'd3; b = 4'd5; op = 2'b01; #10;
        $display("3 - 5 = %0d (expected 14 in unsigned four bits)", result);
        if (result !== 4'd14) errors = errors + 1;

        if (errors == 0) $display("PASS: ALU");
        else $display("FAIL: ALU, errors=%0d", errors);
        $finish;
    end
endmodule
```

### Test cases কেন এইগুলো বেছে নেওয়া হয়েছে?

| Test | Inputs | Expected | কি যাচাই করছে |
|------|--------|----------|--------------|
| 1 | a=6, b=3, op=00 | 9 | সাধারণ addition (no overflow) |
| 2 | a=6, b=3, op=01 | 3 | সাধারণ subtraction (positive result) |
| 3 | a=6, b=3, op=10 | 2 | Bitwise AND (6=0110, 3=0011 → 0010=2) |
| 4 | a=6, b=3, op=11 | 7 | Bitwise OR (0110\|0011=0111=7) |
| 5 | a=15, b=1, op=00 | 0 | Addition overflow (4-bit truncation) |
| 6 | a=3, b=5, op=01 | 14 | Subtraction underflow (unsigned wrap) |

প্রথম 4টা দিয়ে basic functionality (opcode সঠিক কাজ করছে কিনা), শেষ 2টা দিয়ে edge case (overflow/underflow) check করা হচ্ছে।

### ⏱️ প্রতিটার পর 10 ns delay কেন?
যদিও ALU combinational (zero delay), testbench-এ input/op change-এর মধ্যে 10 ns ফাঁক দেওয়া waveform-এ স্পষ্ট আলাদা আলাদা phase দেখায়।

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
mkdir -p 06_alu4 && cd 06_alu4
iverilog -g2005 -Wall -s tb -o sim.vvp design.v testbench.v
vvp sim.vvp
```

---

## 📊 Expected Output

```
VCD info: dumpfile dump.vcd opened for output.
6 + 3 = 9 (expected 9)
6 - 3 = 3 (expected 3)
6 AND 3 = 2 (expected 2)
6 OR 3 = 7 (expected 7)
15 + 1 = 0 (expected 0 in four bits)
3 - 5 = 14 (expected 14 in unsigned four bits)
PASS: ALU
testbench.v:43: $finish called at 60000 (1ps)
```

### যাচাই
- 6+3=9 ✓ (binary 1001)
- 6−3=3 ✓ (0011)
- 6 AND 3 = 2 (0010) — common set bits only
- 6 OR 3 = 7 (0111) — any set bit
- 15+1=0 — overflow truncation (carry হারিয়েছে)
- 3−5=14 — underflow two's complement wrap (−2 ≡ 14 mod 16)

---

## 📈 Waveform বিশ্লেষণ

Signals: `a[3:0]`, `b[3:0]`, `op[1:0]`, `result[3:0]`

কি দেখবে:
- Phase 0–10 ns: a=6, b=3, op=00 → result=9 (ADD)
- 10–20 ns: op=01 → result=3 (SUB)
- 20–30 ns: op=10 → result=2 (AND)
- 30–40 ns: op=11 → result=7 (OR)
- 40–50 ns: a=15, b=1, op=00 → result=0 (ADD overflow)
- 50–60 ns: a=3, b=5, op=01 → result=14 (SUB underflow)

**Combinational observation:** `a`, `b`, বা `op` যেকোনোটা পরিবর্তনের সাথে সাথে (zero delay) `result` update হয় — clock edge অপেক্ষা করে না।

---

### 🖱️ EPWave-এ ভালোভাবে waveform দেখার টিপস
- **Ctrl + mouse wheel** দিয়ে zoom in/out; মাউস wheel এ একা scroll করলে সময় axis scroll হয়
- Toolbar-এ **Zoom to Fit** (ম্যাগ্নিফাইং glass + square) বাটন চাপলে পুরো waveform একসাথে fit হয়ে যাবে
- **Radix** dropdown → **Binary** করলে প্রতিটা 1-bit signal 0/1 দেখাবে; bus (multi-bit) signals-এর জন্য Decimal/Hex ব্যবহার করো
- Signal name-এ click করে **Drag** করলে signal-এর order পরিবর্তন (গুরুত্বপূর্ণ signals উপরে তুলে আনা যায়)
- Signal line-এ **এক ক্লিকে cursor** আসে → time point-এর মান বাম পাশে signal name-এর পাশে দেখাবে
- Cursor রেখে **time marker** দেখতে Δ বাটন ব্যবহার করো (দুই cursor-এর মাঝের সময় ব্যবধান)


## 🚀 বৃহত্তর ALU — একটু সামনের ধারণা

বাস্তব CPU-এর ALU-তে আরো অনেক কিছু থাকে:

### Flags (status bits)
```verilog
output zero;      // result == 0
output carry;     // unsigned overflow
output overflow;  // signed overflow
output neg;       // result < 0
```

`zero = (result == 4'b0000)` — branch-if-zero instruction-এ ব্যবহার হয়।

### আরো operations
| op | operation |
|----|-----------|
| 000 | ADD |
| 001 | SUB |
| 010 | AND |
| 011 | OR  |
| 100 | XOR |
| 101 | Shift Left Logical (SLL) |
| 110 | Shift Right Logical (SRL) |
| 111 | SLT (set on less than) |

### ALU নিয়ন্ত্রণ (ALU Control)
MIPS/RISC-V প্রসেসরে instruction-এর funct field আর ALUOp signal থেকে `op` (ALU control) generate করা হয় (ALU Control নামে আলাদা কম্বিনেশনাল সার্কিট)।

### Datapath-এ ALU
```
registerA ──►┌─────┐
             │ ALU ├─── result ──► register (write back)
registerB ──►│     │
             └──▲──┘
                │
            op (control)
```
Add/sub/and/or instruction-এর জন্য এই datapath কাজ করে।

---

## ⚠️ Common Mistakes

1. **`always @(a or b or op)` sensitivity list অসম্পূর্ণ**
   - সবসময় `always @(*)` ব্যবহার করো — সব input স্বয়ংক্রিয়ভাবে sensitivity-এ যাবে
   - পুরানো Verilog স্টাইলে প্রতিটা signal ম্যানুয়ালি লিখতে হতো, কিন্তু তাতে কোনো signal বাদ পড়লে simulation-synthesis mismatch হয়

2. **`default` case না দেওয়া**
   - X/Z input-এ latch inferred হবে
   - সংশ্লেষণ টুল warning দেবে "inferred latch for result"

3. **Sequential block-এ করে ফেলা**
   - ALU combinational — `always @(posedge clk)` দিয়ে করলে clocked register হয়ে যাবে
   - `always @*` ব্যবহার করো

4. **`=` vs `<=` ভুল**
   - Combinational always-এ `=` (blocking) ব্যবহার করো

5. **Overflow carry আলাদা পোর্টে না বের করা যদি দরকার হয়**
   - এই ল্যাবে carry discarded; চাইলে internal 5-bit sum রেখে MSB-কে carry port-এ বের করা যায়

6. **op encoding ভুল**
   - ADD=00, SUB=01, AND=10, OR=11 — নোট রেখো; testbench এই encoding অনুযায়ী লেখা

---

## 💡 Extra Practice

1. **Zero flag যোগ করো:**
   ```verilog
   wire zero;
   assign zero = (result == 4'b0000);
   ```
   ADD 15+1-এ zero=1 হবে

2. **XOR ও NOT অপারেশন যোগ করো** (3-bit op লাগবে):
   ```verilog
   3'b100: result = a ^ b;
   3'b101: result = ~a;   // NOT a (4-bit)
   ```

3. **Carry-out যোগ করো:**
   ```verilog
   reg cout;
   // ADD-এ: {cout, result} = a + b;
   // SUB-এ: {cout, result} = a - b;
   ```

4. **8-bit ALU** বানাও (বাসের প্রস্থ বাড়াও)

5. **N-bit parameterized ALU:**
   ```verilog
   module alu #(parameter N=4)(
       input  [N-1:0] a, b,
       input  [1:0] op,
       output reg [N-1:0] result
   );
   ```

---

## 🧠 CPU-এ ALU-এর ভূমিকা
- **Arithmetic:** add, sub, increment (addi), address calculation (lw/sw address = base + offset)
- **Logic:** and, or, xor, not — bit manipulation
- **Comparison:** subtract করে zero flag দেখে beq/bne branch decision
- **Shift:** logical/arithmetic shift for multiplication by 2

ALU ছাড়া প্রসেসর কোনো computation করতে পারে না — প্রতিটা arithmetic/logical instruction ALU-র মাধ্যমে যায়।

---

## 📝 Report-এ কি লিখবে

1. **Objective** — 4-operation 4-bit ALU
2. **Operation Table** (opcode map)
3. **Block diagram** (opcode-controlled 4:1 MUX with 4 function units)
4. **Design code** — `always @*`, `case`, `default` ব্যাখ্যা করো
5. **Test cases table** (6টা test, edge cases including overflow/underflow)
6. **Testbench code**
7. **Simulation output**
8. **Waveform screenshot**
9. **Discussion:**
   - Combinational vs sequential (ALU কেন combinational)
   - Blocking vs non-blocking (which one used, why)
   - Overflow truncation (15+1=0)
   - Two's complement subtraction (3−5=14)
   - Real ALU extensions (flags, more ops)

---

## 🎉 ছয় ল্যাব শেষ! এখন কি?

এই ছয়টা বিল্ডিং ব্লক জানলে এখন তুমি বানাতে পারবে:
- **Ripple Carry Adder** (multiple Full Adders)
- **Register File** (multiple registers + read/write mux)
- **Simple CPU Datapath** (register + ALU + mux + program counter)
- **State machine** (counter + combinational next-state logic)

Computer architecture সামনে এগুলো দিয়েই বানানো — gates → adder → mux → register → counter → ALU → control unit → CPU।
