# Testing Cubeland

There's nothing to install or compile. The test program is ready-built,
like the game.

## Run all the tests

1. Open the `release` folder of the repo.
2. Double-click **`cubeland_test.exe`**.
3. Wait a few seconds until the bottom line says *712 functions...*
4. In **Source folder**, type `..` (so the report can show each function's
   code).
5. Press **Everything**.
6. When it's done, the bottom line gives a file name. Open
   `release\cubeland_worlds\test_reports`, then open the newest
   `report_....html`. It opens in your web browser.

At the top, **Failed checks** should be 0.

## Run one function many times

1. In **Find function**, type part of its name (for example
   `floor_divide`), then press **Filter**.
   - Type `library` to list the 12d library calls instead.
2. Click the function in the list.
3. In **Runs**, type how many times to call it (for example `25340`).
4. Press **Run selected**.
5. Open the newest report, as above.

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
