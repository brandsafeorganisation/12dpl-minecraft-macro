#!/bin/bash
# Translate the Cubeland macro into C++ and compile it with the test harness.
# Usage: ./build.sh            (output: build/game)
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
MACRO=$(cd "$HERE/../.." && pwd)
mkdir -p "$HERE/build"

# 1. Preprocess and translate; prints any 12dPL lint warnings
python3 "$HERE/translate.py" "$MACRO" cubeland.4dm "$HERE/build/game.cpp"

# 2. Append the macro's #defines (the hooks use them), the test hooks
#    and an entry point
(cd "$MACRO" && cpp -dM -undef -nostdinc -x c -w cubeland.4dm) \
  | grep -vE '^#define (TRUE|FALSE|RELEASE|DEBUG|__)' \
  | grep -vE '_INCLUDED|_4DM_INCLUDED' > "$HERE/build/macros.h"
echo '#include "macros.h"' >> "$HERE/build/game.cpp"
cat "$HERE/hooks.cpp" >> "$HERE/build/game.cpp"
cat >> "$HERE/build/game.cpp" <<'X'
extern void load_script_public(const char*);
int main(int argc,char**argv){ register_hooks(); load_script_public(argv[1]); macro_main(); return 0; }
X

# 3. Compile with address and undefined-behaviour checks
g++ -O1 -g -std=c++17 -w -fsanitize=address,undefined -I "$HERE" -I "$HERE/build" \
    -o "$HERE/build/game" "$HERE/build/game.cpp" "$HERE/harness.cpp"
echo "built $HERE/build/game"
