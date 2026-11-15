#!/usr/bin/env python3
"""Turn test/report/report_page.html into test/src/test_report_page.4dm.

The test build's HTML report is a fixed page (styles, layout and the
script that draws the tables and charts) with the run's numbers put in
at <!--DATA-->. Editing the page as HTML is much easier than editing
hundreds of File_write_line calls, so this script writes those calls:

    test_report_page_start(File &p_file)   everything before <!--DATA-->
    test_report_page_end  (File &p_file)   everything after it

12dPL strings can't hold a double quote here (the code avoids \\"), so
the page must use single quotes. Backslashes are doubled. Characters
outside ASCII become \\uXXXX in the script and \\XXXX in the styles, so
the macro source stays plain ASCII.

    python3 tools/make_report_page.py           write the .4dm
    python3 tools/make_report_page.py --check   only say if it is stale
"""
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PAGE = os.path.join(ROOT, "test", "report", "report_page.html")
OUT = os.path.join(ROOT, "test", "src", "test_report_page.4dm")
MARK = "<!--DATA-->"


def ascii_line(line, in_style):
    out = []
    for c in line:
        if ord(c) < 128:
            out.append(c)
        elif in_style:
            out.append("\\%X " % ord(c))
        else:
            out.append("\\u%04x" % ord(c))
    return "".join(out)


def function(name, lines, what):
    body = ["void %s(File &p_file)" % name,
            "// ----------------------------------------------------------------",
            "// Write %s" % what,
            "// ----------------------------------------------------------------",
            "{"]
    for line in lines:
        body.append('  File_write_line(p_file, "%s");' % line.replace("\\", "\\\\"))
    body.append("}")
    return body


def build():
    text = open(PAGE, encoding="utf-8").read()
    if MARK not in text:
        sys.exit("make_report_page: %s has no %s" % (PAGE, MARK))
    lines, in_style = [], False
    for number, raw in enumerate(text.split("\n"), 1):
        line = raw.rstrip()
        if '"' in line:
            sys.exit("make_report_page: line %d has a double quote (use single quotes)" % number)
        if "??" in line:
            sys.exit("make_report_page: line %d has ?? (a trigraph to the preprocessor)" % number)
        if "<style" in line:
            in_style = True
        lines.append(ascii_line(line, in_style))
        if "</style>" in line:
            in_style = False
    while lines and lines[-1] == "":
        lines.pop()
    split = lines.index(MARK)
    out = ["#ifndef TEST_REPORT_PAGE_4DM_INCLUDED",
           "#define TEST_REPORT_PAGE_4DM_INCLUDED",
           "",
           "// ----------------------------------------------------------------",
           "// The report page around the run's numbers. Written by",
           "// tools/make_report_page.py from test/report/report_page.html:",
           "// edit that file and run the script, not this one.",
           "// ----------------------------------------------------------------",
           ""]
    out += function("test_report_page_start", lines[:split], "the report page up to the run's numbers (styles and layout)")
    out.append("")
    out += function("test_report_page_end", lines[split + 1:], "the rest of the report page (the script that draws it)")
    out += ["", "#endif", ""]
    return "\n".join(out)


def main():
    text = build()
    old = open(OUT, encoding="utf-8").read() if os.path.exists(OUT) else ""
    if "--check" in sys.argv:
        if old != text:
            sys.exit("test/src/test_report_page.4dm is out of date: run python3 tools/make_report_page.py")
        return
    if old != text:
        with open(OUT, "w", encoding="utf-8", newline="\n") as f:
            f.write(text)
        print("wrote", os.path.relpath(OUT, ROOT))


if __name__ == "__main__":
    main()
