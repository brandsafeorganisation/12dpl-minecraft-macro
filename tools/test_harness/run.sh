#!/bin/bash
# Run scenario scripts against build/game (run ./build.sh first).
#
#   ./run.sh scenarios/02_crafting_and_tools.txt   one scenario, fresh worlds
#   ./run.sh --keep scenarios/06_*.txt            keep the saved worlds
#   ./run.sh --all                                every scenario, in order
#
# Worlds are saved in run/cubeland_worlds, snapshots go to run/out as .ppm
# (and .png when Python's Pillow is installed). The output shows "[dump]"
# lines from the scenario's "call dump" steps and a sanitizer report if
# the macro reads or writes outside an array.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
KEEP=0
SCRIPTS=()
for arg in "$@"; do
  case "$arg" in
    --keep) KEEP=1 ;;
    --all)  SCRIPTS+=("$HERE"/scenarios/*.txt) ;;
    *)      SCRIPTS+=("$(cd "$(dirname "$arg")" && pwd)/$(basename "$arg")") ;;
  esac
done
if [ ${#SCRIPTS[@]} -eq 0 ]; then sed -n '2,12p' "$0"; exit 1; fi

[ $KEEP -eq 1 ] || rm -rf "$HERE/run/cubeland_worlds"
rm -rf "$HERE/run/out"
mkdir -p "$HERE/run/out"
cd "$HERE/run"
for script in "${SCRIPTS[@]}"; do
  echo "=== $(basename "$script")"
  "$HERE/build/game" "$script"
done
if ls out/*.ppm >/dev/null 2>&1; then
  python3 "$HERE/topng.py" out >/dev/null 2>&1 || echo "(install Pillow to get .png snapshots)"
fi
