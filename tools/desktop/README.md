# Cubeland on Windows, without 12d

`desktop.cpp` is a small Win32 program that plays the Cubeland macro outside
12d Model. It turns the macro into C++ with the test harness's translator
(`../test_harness/translate.py`), and it provides the 12d calls the macro uses
for real: panels, buttons, list boxes, file boxes, the `Draw_Box` and the
mouse and keyboard. The game code is identical. Any change to the `.4dm`
files shows up in the exe the next time you build it.

## Playing

1. Get `cubeland.exe`: a ready-built copy is in `release/` in the repo
   (on GitHub, open the file and click **Download raw file**), or build it
   yourself (below). Put it in a folder of its own, for example `Documents\Cubeland`.
2. Double-click it. The **Cubeland - worlds** panel opens, just as it does in 12d.
3. Worlds are saved to `cubeland_worlds` next to the exe, and settings to
   `cubeland_worlds\cubeland_settings.txt`. To move or back up your worlds,
   copy that folder.

The controls are the same as in 12d (press **H** in game). Click the game view
to capture the mouse, and press **Esc** or **Q** to free it and pause. The
window can be resized or maximised, and the view grows with it.

The exe isn't signed, so Windows SmartScreen may say "Windows protected your
PC". Click **More info** and then **Run anyway**. It needs Windows 10 or
newer, 64-bit. It doesn't install anything or need admin rights, and it only
writes inside its own folder.

## Building it yourself

**On Windows.** Install:
- Python 3 (python.org; tick "Add to PATH").
- A MinGW-w64 compiler that has `g++` and `cpp`. Either use
  [w64devkit](https://github.com/skeeto/w64devkit) (unzip it and add its `bin`
  folder to PATH) or MSYS2's `mingw-w64-x86_64-gcc`.

Then double-click `build_windows.bat`, or run it from a command prompt. The
result is `build\cubeland.exe`.

**On Linux or macOS (cross-compiling).** Use Zig as the Windows compiler:

```bash
python3 -m pip install ziglang
```

```bash
./build_with_zig.sh
```

Set `ZIG` if Zig isn't available as `python3 -m ziglang`. The script still
needs the system `cpp` for the translation step.

## Troubleshooting

- **Keys stop working.** Click the game view. Keys go to whichever window has
  focus, so they stop working when a panel or another program has it.
- **Something odd happens.** Start it from a command prompt with logging on:
  `set CUBELAND_LOG=1` and then `cubeland.exe`. It writes `cubeland_log.txt`
  next to the exe, listing every panel shown and every event that isn't a
  mouse move.

## How it works

- Panels are top-level windows, laid out top to bottom like 12d's vertical
  groups. Button groups sit on one row. The `Draw_Box` fills the space that's
  left.
- The view draws into an off-screen bitmap. Polygons are filled by a small
  software rasteriser (the same one the test harness uses for snapshots).
  Text is drawn with GDI, and the bitmap is copied to the window once per frame.
- The macro's main loop runs on the steady stream of mouse-move events the
  game gets while it holds the cursor. When no real event is waiting, the
  host makes up a `mouse_move` every few milliseconds, so the game ticks just
  as it does in 12d.
- File access goes through the harness's `runtime.h`, which uses the C
  standard library, so the save files are the same format as in 12d.

This was tested under Wine, not on a real Windows PC. If something looks
wrong on real Windows, a `cubeland_log.txt` will help.
