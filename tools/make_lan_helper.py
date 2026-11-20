#!/usr/bin/env python3
"""Turn src/net/lan_helper.ps1 into include/core/safe_lan_script.h.

The LAN helper is a PowerShell script that the macro writes into
cubeland_worlds\\lan and starts (safe_run_helper in safety.h). The macro
keeps its text as File_write_line calls, written by this script, so the
file that runs is always the macro's own.

12dPL strings can't hold a double quote here, so the script must use
single quotes only. Backslashes are doubled. Only ASCII is allowed.

    python3 tools/make_lan_helper.py           write the header
    python3 tools/make_lan_helper.py --check   only say if it is stale
"""
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPT = os.path.join(ROOT, "src", "net", "lan_helper.ps1")
OUT = os.path.join(ROOT, "include", "core", "safe_lan_script.h")


def build():
    lines = []
    for number, raw in enumerate(open(SCRIPT, encoding="ascii").read().split("\n"), 1):
        line = raw.rstrip()
        if '"' in line:
            sys.exit("make_lan_helper: line %d has a double quote (use single quotes)" % number)
        if "??" in line:
            sys.exit("make_lan_helper: line %d has ?? (a trigraph to the preprocessor)" % number)
        if "\t" in line:
            sys.exit("make_lan_helper: line %d has a tab" % number)
        lines.append(line)
    while lines and lines[-1] == "":
        lines.pop()
    out = ["#ifndef SAFE_LAN_SCRIPT_H_INCLUDED",
           "#define SAFE_LAN_SCRIPT_H_INCLUDED",
           "",
           "// ----------------------------------------------------------------",
           "// The LAN helper script (safety.h writes it before starting it).",
           "// Written by tools/make_lan_helper.py from src/net/lan_helper.ps1:",
           "// edit that file and run the script, not this one.",
           "// ----------------------------------------------------------------",
           "",
           "void safe_lan_script_write(File &p_file)",
           "// ----------------------------------------------------------------",
           "// Write the LAN helper script",
           "// ----------------------------------------------------------------",
           "{"]
    for line in lines:
        out.append('  File_write_line(p_file, "%s");' % line.replace("\\", "\\\\"))
    out += ["}", "", "#endif", ""]
    return "\n".join(out)


def main():
    text = build()
    current = open(OUT).read() if os.path.exists(OUT) else ""
    if "--check" in sys.argv:
        if current != text:
            sys.exit("LAN helper script is out of date: run python3 tools/make_lan_helper.py")
        return
    if current != text:
        open(OUT, "w").write(text)
        print("wrote", OUT)


if __name__ == "__main__":
    main()
