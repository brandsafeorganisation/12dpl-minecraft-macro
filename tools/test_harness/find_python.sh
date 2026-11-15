# Sets PYTHON to a Python 3 that really runs. On Windows "python3" is
# often only the Microsoft Store shortcut, which prints "Python was not
# found", so each name is tried by running it, not just looked up.
PYTHON=""
for l_try in python3 python py; do
  if "$l_try" -c "import sys; sys.exit(0 if sys.version_info[0] == 3 else 1)" >/dev/null 2>&1; then
    PYTHON="$l_try"
    break
  fi
done
if [ -z "$PYTHON" ]; then
  echo "Python 3 was not found (tried python3, python and py)." >&2
  exit 1
fi
