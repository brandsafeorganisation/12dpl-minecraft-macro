#!/bin/bash
# Build cubeland.exe (the game) and cubeland_test.exe (the test build)
# for Windows from Linux or macOS with zig as the cross compiler
# (pip install ziglang). On Windows itself use build_windows.bat instead.
#   ./build_with_zig.sh            -> build/cubeland.exe, build/cubeland_test.exe
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
MACRO=$(cd "$HERE/../.." && pwd)
HARNESS="$HERE/../test_harness"
. "$HARNESS/find_python.sh"
ZIG=${ZIG:-"$PYTHON -m ziglang"}
mkdir -p "$HERE/build"
build() {  # entry .4dm, output name
  "$PYTHON" "$HARNESS/translate.py" "$MACRO" "$1" "$HERE/build/$2.cpp"
  $ZIG c++ -target x86_64-windows-gnu -O2 -std=c++17 -w -DCUBELAND_DESKTOP \
    -I "$HARNESS" "$HERE/build/$2.cpp" "$HERE/desktop.cpp" \
    -o "$HERE/build/$2.exe" -static -lgdi32 -luser32 -lcomdlg32 -lshell32 -Wl,--subsystem,windows
  echo "built $HERE/build/$2.exe"
}
build cubeland.4dm game
mv "$HERE/build/game.exe" "$HERE/build/cubeland.exe"
build test/cubeland_test.4dm cubeland_test
