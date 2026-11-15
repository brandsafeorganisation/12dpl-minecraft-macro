# Testing Cubeland

There's nothing to install or compile. The test program is ready-built,
like the game.

## Run all the tests

1. Open the `release` folder of the repo.
2. Double-click **`cubeland_test.exe`**.
3. Wait a few seconds until the bottom line says how many functions there are
4. Press **Everything**.
5. When it's done, the report opens in your web browser by itself.
   **Open last report** opens it again later.

At the top, **Checks passed** should be green.

The report has tabs:

- **Overview**: charts of the slowest functions on average, the slowest
  single calls, the most time overall, the least steady, time by part of
  the game, and which functions the inputs affect most. Click a bar to
  see that function.
- **Functions**: every function in a table. Click a column heading to
  sort by it, type in the box to find one, and choose a part of the game
  or one data set.
- **Data sets**: each function's time and results with each data set
  side by side (see below).
- **Unit tests**: every check, failed ones first.
- **Left out**: the functions that weren't run, and why.

Click a function's name anywhere to see it in detail: its signature,
what it calls and what calls it, each data set's times with charts, its
first 12 calls with their inputs and outputs, and its code.

## Data sets

Every function is called with three sets of inputs, and the report
compares them:

- **typical**: each parameter's usual value;
- **random**: random values from each parameter's range;
- **edges**: the ends of each range (all low, all high, then mixed).

**Data sets** in the panel picks one of them (`typical`, `random`,
`edges`) or `all` (the default). "Suspicious" marks a function that
returned NaN, infinity, or the largest or smallest whole number, which
usually means a divide by zero or an overflow.

## Where reports go

**Report folder** says where reports are written (the default is
`cubeland_worlds\test_reports` next to the program). Set **Open the
report when it is written** to `no` to stop it opening by itself.

**Source folder** is filled in for you when the program can find the
game's code (for the code in the report).

## Run one function many times

1. In **Find function**, type part of its name (for example
   `floor_divide`), then press **Filter**.
   - Type `library` to list the 12d library calls instead.
2. Click the function in the list.
3. In **Runs**, type how many times to call it (for example `25340`).
   Each data set gets that many calls.
4. Press **Run selected**. The report opens when it's done.

For that function, the report shows:

- its signature;
- the inputs it was given and the outputs it gave;
- the average, fastest and slowest time per call;
- its code.

## If it stops with an error

Start `cubeland_test.exe` again. The bottom line names the function it
stopped in.

---

## In 12d Model instead

In 12d, compile `test\cubeland_test.4dm` instead of `cubeland.4dm`. Then
run the `.4do` it makes and use the same panel as above. The reports go
in `cubeland_worlds\test_reports` inside the 12d working folder. Set
**Source folder** to the folder that holds `src`.

## For whoever changes the code

- **Rebuild the exes:** `tools\desktop\build_windows.bat` builds both
  `cubeland.exe` and `cubeland_test.exe` (see `tools/desktop/README.md`).
  Copy them from `tools\desktop\build` into `release`.
- **After adding a function or changing its parameters:** run
  `python tools\make_test_registry.py` from the repo root.
- **New checks** go in `test/src/test_cases.4dm`, for example:

  ```
  test_expect_integer(p_results, "floor_divide(-7, 2)", floor_divide(-7, 2), -4);
  ```

- **Better inputs for a parameter:** add a rule in
  `test/src/test_inputs.4dm`.
- **`tools/test_harness`** is an extra check that only runs on Linux, for
  the automated runs. You don't need it on Windows.
