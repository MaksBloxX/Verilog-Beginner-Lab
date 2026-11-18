# Setup Guide — Verilog Simulation চালানোর ৩টা উপায়

এই গাইডে Verilog কোড রান করার তিনটা পদ্ধতি বিশদভাবে দেওয়া আছে। ক্লাস ল্যাবে সবচেয়ে সহজ হলো **EDA Playground** (browser-এ চলে, কিছু ইন্সটল করতে হয় না)। বাসায় প্রাকটিস করার জন্য Icarus Verilog (VS Code terminal এ) ভালো।

---

## 📚 সূচীপত্র
1. [EDA Playground (Recommended for Class)](#-পদ্ধতি-১--eda-playground-অনলাইন--recommended-for-class)
2. [Icarus Verilog Local Install (VS Code Terminal)](#-পদ্ধতি-২--icarus-verilog-local--vs-code-terminal)
3. [VS Code + Icarus এক্সটেনশন (Optional)](#-পদ্ধতি-৩--vs-code-এ-verilog-এক্সটেনশন-optional)
4. [EDA Playground Step-by-Step (Screenshot-based)](#-eda-playground-step-by-step)
5. [সাধারণ সমস্যা ও সমাধান](#-সাধারণ-সমস্যা-ও-সমাধান-troubleshooting)

---

## 🌐 পদ্ধতি ১ : EDA Playground (Online) ⭐ Recommended for Class

EDA Playground = browser-এ চলে এমন Verilog simulator। ল্যাব ক্লাসে সবচেয়ে ঝামেলা-মুক্ত — কোনো সফটওয়্যার ইন্সটল করতে হয় না।

### প্রথমেই সেটিংস করে নাও (একবার)

**EPWave popup window-তে খুলানোর জন্য (গুরুত্বপূর্ণ!):**
1. উপরে ডানদিকে **Profile** → Profile Settings-এ যাও
2. Option টিক দাও: ☑ **"Open EPWave in a new browser window"**
3. Save করো

> ⚠️ এই setting না করলে EPWave একই tab-এ editor replace করে দেয় — তখন log দেখতে back দিতে হয় আর আগের state নষ্ট হয়। Setting on করলে EPWave ছোট popup উইন্ডো হিসেবে নিচে ডান পাশে খুলবে — log আর editor সবসময় দৃশ্যমান থাকবে।

### ধাপে ধাপে

**Step 1:** ব্রাউজারে যাও → [https://edaplayground.com](https://edaplayground.com)

**Step 2:** **"Log in"** বাটন চাপো → **Google** দিয়ে এক ক্লিকে লগইন করো (লগইন না করলে waveform দেখাবে না)।

**Step 3:** Log in হলে দুইটা editor panel দেখবে:
- **বাম প্যান (testbench.sv):** এখানে testbench.v-এর কোড পেস্ট করবে
- **ডান প্যান (design.sv — default তৈরি থাকে):** এখানে design.v-এর কোড পেস্ট করবে

> 💡 ডিফল্ট নাম `testbench.sv` / `design.sv` (SystemVerilog) — চিন্তা করো না, আমাদের Verilog-2005 কোড এখানে নির্বিঘ্নে কাজ করবে। নাম পরিবর্তন করতে চাইলে file name tab-এ click করে `.v` করে নিতে পারো।

**Step 4:** বাম পাশের **Tools & Simulators** সেকশনে dropdown-এ যাও → **Icarus Verilog 12.0** (বা latest) সিলেক্ট করো।

**Step 5:** Run Options-এ (Tools & Simulators এর নিচে) টিক দাও:
- ☑ **"Open EPWave after run"**

> Compile Options-এ `-Wall -g2012` ডিফল্ট থাকে — আমাদের কোডে কাজ করবে।

**Step 6:** উপরে **Run** ▶️ (নীল রঙের বাটন) চাপো।

**Step 7:** (গুরুত্বপূর্ণ) কি কি দেখবে:

1. **নিচের Log panel:** code panels-এর ঠিক নিচে **"Log"** নামে ট্যাব থাকবে (ডিফল্ট selected)। সেখানে scroll করলে `$display()`-এর সব output + শেষে `PASS:` / `FAIL:` message দেখাবে।
   - যদি Log panel ছোট দেখায়, code panels ও Log-এর মাঝের split bar টেনে নিচের দিকে নামিয়ে panel বড় করো

2. **EPWave popup:** ডান নিচে ছোট একটা EPWave উইন্ডো খুলবে (corner popup) — **"Waves Loaded"** popup আসবে → **Close** দাও
   - EPWave উইন্ডোটা বড় করতে title bar-এ click করে maximize করো, অথবা টেনে বড় করো
   - বাম পাশে **"Get Signals"** বাটন চাপো → একটা dialog আসবে
   - Dialog-এ বামে scope (tb, .dut) এবং ডানে signals দেখাবে → **tb** select করে **Append All** চাপো (বা একাধিক signal Ctrl+click-এ select করে **Append Selected**)
   - তারপর Close → waveform দেখা যাবে

### 📋 চেকলিস্ট (প্রতি ল্যাবে verify করো)

- [ ] Testbench code বাম panel-এ পেস্ট করা হয়েছে
- [ ] Design code ডান panel-এ পেস্ট করা হয়েছে
- [ ] Tools = Icarus Verilog
- [ ] ☑ Open EPWave after run চেক করা আছে
- [ ] Run ▶️ চাপার পর Log panel-এ `PASS:` এসেছে
- [ ] EPWave-এ signals add করা হয়েছে
- [ ] Waveform-এ input/output expected behavior মেলে

### 🎨 EPWave-এ কাজের টিপস

| কাজ | কিভাবে করবে |
|-----|------------|
| **Zoom In/Out** | **Ctrl + Mouse wheel**, অথবা toolbar-এ magnifying glass (`Q`, `Q` zoom to fit) |
| **Signal add** | Get Signals → tb → Append All (easiest) |
| **Signal delete** | Signal name-এ right click → Delete / Remove |
| **Signal reorder** | Signal name ধরে টেনে (drag) উপরে/নিচে নিয়ে যাও |
| **Value দেখা** | যেকোনো signal edge-এ click করলে cursor আসবে → time point-এর মান বাম পাশে দেখাবে |
| **Radix (base) পরিবর্তন** | "Radix" dropdown → Binary (0/1) / Decimal / Hex / Octal select; 1-bit signals-এ Binary সবচেয়ে স্পষ্ট |
| **Bus signals** | Multi-bit signals (যেমন `q[3:0]`) Radix অনুযায়ী দেখাবে; Digital waveform mode-এ উপরে number লেখা থাকবে |
| **EPWave popup বন্ধ/পুনরায় খুলা** | বন্ধ করতে X চাপো; নতুন run-এ আবার আসবে; অথবা log-এর শেষে "./dump.vcd" link-এ ক্লিক করেও খোলা যায় |

---

## 🔍 EDA Playground Step-by-Step (Visual Guide)

```
┌─────────────────────────────────────────────────────────────┐
│  New  │ Run │ Save │ Copy          ...      Profile ▼       │
├──────────────────────┬──────────────────────────────────────┤
│ Languages &          │  [testbench.sv]  │  [design.sv]       │ ← ২টা code panel
│ Libraries            │                  │                    │
│                      │  testbench code   │  design code       │
│ Testbench+Design:    │  এখানে পেস্ট      │  এখানে পেস্ট        │
│ SystemVerilog/Verilog│                  │                    │
│                      ├──────────────────┴────────────────────┤
│ Tools & Simulators   │ ◉ Log | ○ Share                      │ ← Log ট্যাব
│ ▼ Icarus Verilog 12.0├──────────────────────────────────────┤
│                      │ iverilog -Wall -g2012 ...            │
│ Compile Options:     │ VCD info: ...                        │
│ -Wall -g2012         │ a b | AND OR NOT_a                   │
│                      │ 0 0 |  0   0    1                    │
│ Run Options:         │ ...                                  │
│ ☐ Use run.bash       │ PASS: logic gates                    │ ← PASS message
│ ☑ Open EPWave after  │ Finding VCD file...                  │
│   run                │ ./dump.vcd                           │
│ ☐ Show output text   │ Opening EPWave...                    │
│ ☐ Show output SVG    │ Done                                 │
│ ☐ Download files     ├──────────────────────────────────────┤
│                      │                               ┌──────────────┐
│                      │                               │   EPWave     │
│                      │                               │ (ছোট popup   │
│                      │                               │  waveform    │
│                      │                               │  উইন্ডো)     │
│                      │                               └──────────────┘ ← EPWave popup
└─────────────────────────────────────────────────────────────┘
```

---

## 💻 পদ্ধতি ২ : Icarus Verilog (Local) + VS Code Terminal

বাসায় বা নিজের ল্যাপটপে করলে এই পদ্ধতি ভালো — offline-এ কাজ করবে, VS Code-এ সব ফাইল রেখে terminal দিয়ে কম্পাইল/রান করা যায়।

### ধাপ 1: Icarus Verilog ইন্সটল

**Windows:**
- [http://bleyer.org/icarus/](http://bleyer.org/icarus/) থেকে installer ডাউনলোড করে ইন্সটল করো
- ইন্সটলের সময় "Add to PATH" option-এ টিক দিতে ভুলো না
- অথবা MSYS2 ব্যবহার করো: `pacman -S mingw-w64-x86_64-iverilog`

**Ubuntu/Debian/WSL:**
```bash
sudo apt update
sudo apt install iverilog gtkwave
```

**macOS (Homebrew):**
```bash
brew install icarus-verilog gtkwave
```

**ইন্সটল হয়েছে কিনা চেক:**
```bash
iverilog -V
vvp -V
```
Version নাম্বার দেখালে OK।

### ধাপ 2: VS Code দিয়ে কাজ

**2a. VS Code-এ ফোল্ডার খুলো**
- File → Open Folder → একটা নতুন ফোল্ডার (যেমন `verilog_labs`) তৈরি করে খুলো
- প্রতিটা ল্যাবের জন্য subfolder বানাও: `01_logic_gates/`, `02_full_adder/` ইত্যাদি
- প্রতিটা ফোল্ডারে `design.v` আর `testbench.v` ফাইল বানাও

**2b. Extension ইন্সটল করো (optional but recommended):**
- VS Code → Extensions (Ctrl+Shift+X) → সার্চ দাও **"Verilog-HDL/SystemVerilog/Bluespec SystemVerilog"** (mshr-h) → Install
- এটা syntax highlighting দেবে, code বুঝতে সুবিধা হবে

**2c. Terminal খুলো (Ctrl+` বা Terminal → New Terminal)**

**2d. প্রতিটা ল্যাব কম্পাইল ও রান করো:**

```bash
cd 01_logic_gates
iverilog -g2005 -Wall -s tb -o sim.vvp design.v testbench.v
vvp sim.vvp
```

**কমান্ডের অপশনগুলো বুঝি:**
| অপশন | মানে |
|-------|------|
| `-g2005` | Verilog-2005 standard ব্যবহার করো |
| `-Wall` | সব warning দেখাও |
| `-s tb` | Top module হলো `tb` |
| `-o sim.vvp` | Output ফাইলের নাম `sim.vvp` |

### ধাপ 3: Waveform দেখা (GTKWave)

```bash
gtkwave dump.vcd
```

GTKWave ব্যবহার (EDA Playground-এর EPWave-এর মতো):
- বামে SST tree → `tb` এ ক্লিক
- নিচে signal list → select করে waveform panel-এ **drag & drop**
- **Ctrl + mouse wheel** দিয়ে zoom
- Time axis-এ click করে cursor

### ধাপ 4: একসাথে ৬টা ল্যাব চালানো

```bash
python3 run_all.py
```

এটা প্রতিটা ফোল্ডারে গিয়ে compile + run করবে এবং শেষে PASS/FAIL বলবে।

### VS Code-এ Terminal ব্যবহার করা যায় কি?

**হ্যাঁ, পুরোপুরি যায়।** VS Code-এর integrated terminal normal command prompt/bash এর মতো কাজ করে। `cd`, `iverilog`, `vvp`, `gtkwave` সব কমান্ড এখানে চালানো যায়।

---

## 🔌 পদ্ধতি ৩ : VS Code-এ Verilog এক্সটেনশন (Optional)

### প্রয়োজনীয় এক্সটেনশন
1. **Verilog-HDL/SystemVerilog/Bluespec SystemVerilog** (mshr-h) — syntax highlight, auto-complete
2. **TerosHDL** (optional) — HDL project management, waveform viewer (advanced)

এক্সটেনশন শুধু editing experience উন্নত করে; সিমুলেশন চালানো terminal-এ `iverilog`+`vvp` দিয়েই করতে হবে।

---

## 🔧 সাধারণ সমস্যা ও সমাধান (Troubleshooting)

### ১. EPWave same tab-এ খুলে editor replace করে দেয় (log দেখা যায় না)
**কারণ:** Profile-এ "Open EPWave in new window" setting off আছে।  
**সমাধান:** Profile → Profile Settings → ☑ "Open EPWave in a new browser window" → Save। নতুন করে Run দিলে ছোট popup-এ খুলবে।

### ২. Log panel দেখা যাচ্ছে না / খুব ছোট
**কারণ:** Code panel ও Log-এর মাঝের divider টানা আছে।  
**সমাধান:** Code panels-এর নিচে মাউস নিলে split cursor (↕) দেখাবে → টেনে নিচে নামালে Log panel বড় হবে।

### ৩. EPWave-এর "Waves Loaded" popup-এর পর কোনো signal নেই
**কারণ:** Signal add করনি।  
**সমাধান:** **Get Signals** বাটন চাপো → বাম scope-এ `tb` select → **Append All** → Close। সব signal waveform-এ যোগ হবে।

### ৪. EPWave zoom খুব কাছে / খুব দূর
**সমাধান:** **Ctrl + mouse wheel** দিয়ে zoom in/out। অথবা toolbar-এ **Zoom to Fit** (`Q` magnifying glass with square) বাটন চাপলে পুরো 40ns/80ns view fit হবে।

### ৫. EDA Playground-এ "error: Unknown module type"
**কারণ:** Design module টা testbench প্যানেলে পেস্ট করনি, বা design panel খালি আছে।  
**সমাধান:** ডান panel (design.sv) এ design code রাখো — নিশ্চিত করো যে দুই panel-এই আলাদা আলাদা কোড আছে।

### ৬. EPWave-এ signals duplicate হয়ে গেছে (বারবার Append All করলে)
**কারণ:** Append All বারবার চাপলে signal list বাড়তে থাকে।  
**সমাধান:** Signal name-এ right click করে Delete/Signal remove করো; অথবা EPWave close করে Run-এ নতুনভাবে খুলো।

### ৭. "error: Unknown identifier" / port mismatch
**কারণ:** Design module-এর নাম অথবা port name testbench-এর সাথে মিলছে না।  
**সমাধান:** নিশ্চিত করো:
- Design module name: Lab 1=`logic_gates`, Lab 2=`full_adder`, Lab 3=`mux2`, Lab 4=`register4`, Lab 5=`counter4`, Lab 6=`alu4`
- Testbench-এ `.port(signal)` সংযোগ নাম ঠিক আছে

### ৮. Local-এ `iverilog: command not found`
**কারণ:** Icarus Verilog PATH-এ নেই।  
**সমাধান:** Windows-এ System PATH-এ `C:\iverilog\bin` যোগ করো, VS Code restart করো।

### ৯. Waveform ফ্ল্যাট লাইন (সব সমান)
**কারণ:** `#10` delay নেই, বা `$finish` খুব তাড়াতাড়ি, বা `$dumpvars` নেই।  
**সমাধান:** আমাদের দেওয়া testbench-এ সবকিছু ঠিক আছে — code ঠিকমতো paste হয়েছে কিনা check করো।

### ১০. `Compile Options`-এ `-g2012` vs `-g2005`
EDA Playground default `-g2012` (SystemVerilog 2012) — আমাদের Verilog-2005 কোড এতে পুরোপুরি কাজ করবে; চিন্তা করো না।

---

## 🎯 ক্লাস ল্যাবে করার সাজেশন

| পরিস্থিতি | সেরা পদ্ধতি |
|-----------|-------------|
| ক্লাসের PC-তে (কিছু ইন্সটল নিষেধ) | **EDA Playground** (browser) |
| নিজের laptop-এ প্রাকটিস | Icarus Verilog + VS Code + GTKWave |
| Code submit | Share link (EDA Playground) / local ZIP |
| Report বানানো | EPWave screenshot (Snipping Tool দিয়ে) |

---

## 📋 প্রতিটা ল্যাবে Run করার স্ট্যান্ডার্ড workflow (EDA Playground)

```
1. New চাপো (নতুন clean playground)
2. বাম panel-এ testbench code paste
3. ডান panel-এ design code paste
4. Tools: Icarus Verilog (12.0)
5. ☑ Open EPWave after run
6. Run ▶️
7. নিচে Log panel scroll করে "PASS: ..." দেখো
8. EPWave popup-এ:
   - "Waves Loaded" → Close
   - Get Signals → tb → Append All → Close
   - Ctrl+wheel zoom করে waveform স্পষ্ট করো
   - সময়/মান cursor দিয়ে চেক করো
9. Next ল্যাব: New → repeat
```

---

> **Next:** প্রতিটা ল্যাবের জন্য আলাদা আলাদা বিশদ markdown ফাইল খুলো — `Lab_01_Logic_Gates.md` থেকে শুরু করে `Lab_06_ALU4.md` পর্যন্ত। ওখানে লাইন বাই লাইন কোড ব্যাখ্যা, waveform বিশ্লেষণ, common mistakes দেওয়া আছে।
