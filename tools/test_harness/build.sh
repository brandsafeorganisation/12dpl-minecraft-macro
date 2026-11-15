#!/bin/bash
# Translate the Cubeland macro into C++ and compile it with the test harness.
# Usage: ./build.sh            (output: build/game and build/test)
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
MACRO=$(cd "$HERE/../.." && pwd)
mkdir -p "$HERE/build"

# 0. The test build's function registry must match the source
python3 "$MACRO/tools/make_test_registry.py" --check

build_one() {   # build_one <entry file> <name> [compiler flags]
  local ENTRY=$1 NAME=$2 FLAGS=$3
  # 1. Preprocess and translate; prints any 12dPL lint warnings
  python3 "$HERE/translate.py" "$MACRO" "$ENTRY" "$HERE/build/$NAME.cpp"

  # 2. Append the macro's #defines (the hooks use them), the test hooks
  #    and an entry point
  (cd "$MACRO" && cpp -dM -undef -nostdinc -x c -w "$ENTRY") \
    | grep -vE '^#define (TRUE|FALSE|RELEASE|DEBUG|__)' \
    | grep -vE '_INCLUDED|_4DM_INCLUDED' > "$HERE/build/macros_$NAME.h"
  echo "#include \"macros_$NAME.h\"" >> "$HERE/build/$NAME.cpp"
  cat "$HERE/hooks.cpp" >> "$HERE/build/$NAME.cpp"
  cat >> "$HERE/build/$NAME.cpp" <<'X'
extern void load_script_public(const char*);
int main(int argc,char**argv){ register_hooks(); load_script_public(argv[1]); macro_main(); return 0; }
X

  # 3. Compile with address and undefined-behaviour checks
  g++ -O1 -g -std=c++17 -w $FLAGS -fsanitize=address,undefined -I "$HERE" -I "$HERE/build" \
      -o "$HERE/build/$NAME" "$HERE/build/$NAME.cpp" "$HERE/harness.cpp"
  echo "built $HERE/build/$NAME"
}

# the game (cubeland.4dm) and the test build (test/cubeland_test.4dm)
build_one cubeland.4dm game
build_one test/cubeland_test.4dm test -DCUBELAND_REAL_CLOCK
