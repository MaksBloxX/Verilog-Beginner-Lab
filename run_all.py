"""Run the six independent labs with Icarus Verilog and keep their waveforms."""
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent


def main():
    if not shutil.which("iverilog") or not shutil.which("vvp"):
        print("Install Icarus Verilog first; iverilog and vvp must be on PATH.")
        return 1
    failed = []
    for folder in sorted(ROOT.glob("[0-9][0-9]_*")):
        print(f"\n{folder.name}", flush=True)
        compile_result = subprocess.run(
            ["iverilog", "-g2005", "-Wall", "-s", "tb", "-o", "sim.vvp",
             "design.v", "testbench.v"],
            cwd=folder, capture_output=True, text=True,
        )
        if compile_result.stdout:
            print(compile_result.stdout, end="")
        if compile_result.stderr:
            print(compile_result.stderr, end="")
        if compile_result.returncode:
            failed.append(folder.name)
            continue
        try:
            run_result = subprocess.run(
                ["vvp", "sim.vvp"], cwd=folder, capture_output=True,
                text=True, timeout=15,
            )
        except subprocess.TimeoutExpired:
            print("FAIL: simulation did not finish within 15 seconds.")
            failed.append(folder.name)
            continue
        print(run_result.stdout, end="")
        if run_result.stderr:
            print(run_result.stderr, end="")
        (folder / "simulation.log").write_text(
            run_result.stdout + run_result.stderr, encoding="utf-8"
        )
        if run_result.returncode or "FAIL:" in run_result.stdout or "PASS:" not in run_result.stdout:
            failed.append(folder.name)
    if failed:
        print("\nFailed labs: " + ", ".join(failed))
        return 1
    print("\nAll six labs passed. Each folder now contains dump.vcd and simulation.log.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
