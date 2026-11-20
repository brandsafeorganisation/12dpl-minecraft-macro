#!/bin/bash
# Run scenario scripts against build/game, or build/test for a scenario
# with the line "# build: test" (run ./build.sh first).
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
. "$HERE/find_python.sh"
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

[ $KEEP -eq 1 ] || rm -rf "$HERE/run/cubeland_worlds" "$HERE/run/remote"   # remote: "the other PC" of the LAN helper
rm -rf "$HERE/run/out"
mkdir -p "$HERE/run/out"
# The folders the pickers read: the test pack (zip and folder, from
# make_test_pack.py) and a file that isn't a pack; the supplied skin
# and a file that isn't a skin; the test fonts (make_test_fonts.py)
rm -rf "$HERE/run/resourcepacks" "$HERE/run/skins" "$HERE/run/fonts"
mkdir -p "$HERE/run/resourcepacks" "$HERE/run/skins" "$HERE/run/fonts"
[ -f "$HERE/packs/test_pack.zip" ] && cp "$HERE/packs/test_pack.zip" "$HERE/run/resourcepacks/"
[ -d "$HERE/packs/test_pack" ] && cp -r "$HERE/packs/test_pack" "$HERE/run/resourcepacks/"
echo "not a zip" > "$HERE/run/resourcepacks/broken.zip"
cp "$HERE/../../release/skins/purple.png" "$HERE/run/skins/"
echo "not a png" > "$HERE/run/skins/broken.png"
for f in test_font.ttf test_mac.otf test_collection.ttc not_a_font.ttf; do
  [ -f "$HERE/packs/$f" ] && cp "$HERE/packs/$f" "$HERE/run/fonts/"
done
cd "$HERE/run"
for script in "${SCRIPTS[@]}"; do
  echo "=== $(basename "$script")"
  # a scenario with the line "# build: test" drives the test build
  if grep -q '^# build: test' "$script"; then
    "$HERE/build/test" "$script"
  else
    "$HERE/build/game" "$script"
  fi
done
if ls out/*.ppm >/dev/null 2>&1; then
  "$PYTHON" "$HERE/topng.py" out >/dev/null 2>&1 || echo "(install Pillow to get .png snapshots)"
fi
