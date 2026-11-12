#!/bin/bash
# Build cubeland.exe for Windows from Linux or macOS with zig as the
# cross compiler (pip install ziglang). On Windows itself use
# build_windows.bat instead.
#   ./build_with_zig.sh            -> build/cubeland.exe
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
MACRO=$(cd "$HERE/../.." && pwd)
HARNESS="$HERE/../test_harness"
ZIG=${ZIG:-"python3 -m ziglang"}
mkdir -p "$HERE/build"
python3 "$HARNESS/translate.py" "$MACRO" cubeland.4dm "$HERE/build/game.cpp"
$ZIG c++ -target x86_64-windows-gnu -O2 -std=c++17 -w -DCUBELAND_DESKTOP \
  -I "$HARNESS" "$HERE/build/game.cpp" "$HERE/desktop.cpp" \
  -o "$HERE/build/cubeland.exe" -static -lgdi32 -luser32 -lcomdlg32 -Wl,--subsystem,windows
echo "built $HERE/build/cubeland.exe"
