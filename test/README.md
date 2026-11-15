# The Cubeland test build: step by step

The test build is a second macro made from the same code as the game.
Instead of the game it opens a **Cubeland - test build** panel that can:

- run any function of the game, or one of 32 library calls, as many times as
  you like;
- run every function once;
- run the unit tests in `test/src/test_cases.4dm`.

Every run writes an HTML report. There are two ways to run it:

- **In 12d Model** (A below): the real thing.
- **On Linux without 12d** (B below): the same macro translated to C++ by
  `tools/test_harness`, driven by a script.

Neither changes the game: `cubeland.4dm` still compiles the normal game.

---

## A. In 12d Model

### 1. Get the files into place

1. Copy the whole repository folder to the Windows machine with 12d, for
   example to `C:\Cubeland`. You need at least `cubeland.4dm`, `include\`,
   `src\` and `test\`.
2. Decide on a 12d **working folder** (the folder of the project you open
   in 12d). The test build writes its reports into
   `cubeland_worlds\test_reports` inside that folder, the same place the
   game keeps its worlds. It creates both folders itself.

### 2. Compile the test build

1. In 12d, open the macro compiler (Utilities, Macros, Compile, or however
   your version names it).
2. Compile **`C:\Cubeland\test\cubeland_test.4dm`**. Don't compile
   `cubeland.4dm`; that's the game.
   - The test build pulls in the whole game through `src\build.4dm` and then
     the files in `test\src\`.
   - Two `#warning` lines about the safety switches in `build.4dm` are
     normal if you've turned those switches on.
3. You get **`cubeland_test.4do`** next to the `.4dm`.

### 3. Run it

1. Run `cubeland_test.4do` (Utilities, Macros, Run).
2. The panel opens. The message line at the bottom says *Loading textures and
   making the test world...*. Wait until it says *712 functions. Pick one
   and press Run selected, or run them all.*
   - The functions work on a world made from seed 12345. It is never saved.
3. Optional: fill in **Source folder** with the folder that holds `src`
   (`C:\Cubeland` in the example). The report then shows each function's
   code. Leave it empty if you don't want the code.

### 4. Run everything once (the basic "does it all work" check)

1. Press **Everything**.
2. Wait. The message line shows which function is running. It takes from
   a few seconds up to a minute or so.
3. When it finishes, the message line says how many unit test checks
   passed and how many functions ran, then gives the report path, for
   example `cubeland_worlds\test_reports\report_1763190000.html`.
4. Open that file in a web browser. Look at:
   - **Failed checks** at the top. There should be none (101/101 at the
     time of writing).
   - **Left out**: the functions that weren't run, and why.

You can also run each half on its own:

- **Unit tests** runs only the checks.
- **Run all once** runs only the functions.

### 5. Run one function many times

1. Type part of its name in **Find function** (for example `floor_divide`)
   and press **Filter**. You can also type:
   - a part of the game: `world`, `render`, `player`, ...
   - `library`, to list the 12d library calls (`Get_subtext`, `Sqrt`, ...).
   - nothing at all, to list everything again.
2. Click the function in the **Functions** list.
3. Type the number of calls in **Runs** (1 to 10,000,000; the default is
   1000).
4. Choose your inputs in **Random inputs**:
   - `yes` (the default): the first call gets typical inputs and the rest
     get random ones in a sensible range.
   - `no`: every call gets the typical inputs.
5. Press **Run selected**.
6. Open the report the message line names. For the function, it shows:
   - its signature, file and lines, and the functions it calls;
   - where each input came from;
   - the mean, fastest and slowest time a call, the spread, calls a second,
     and a histogram of call times;
   - the range of numbers it returned;
   - its first 12 calls with their inputs and outputs;
   - its code, if you filled in Source folder.

### 6. Functions that write files

**Run all once** leaves out the 21 functions that write files (saving,
settings, multiplayer) unless you set **Run all includes functions that
write files** to `yes`. You can always run one of them yourself with **Run
selected**.

Everything they write is inside `cubeland_worlds` and named `zz_test...`,
so they can't overwrite a saved world.

### 7. If 12d stops the macro with an error

12dPL can't catch errors. Before each function, the run writes its name to
`cubeland_worlds\test_reports\progress.txt`.

1. Run `cubeland_test.4do` again.
2. The message line says *The last test run stopped inside <function>*.
3. The next report names that function too. That's the bug to look at.

**Make test world** remakes the test world if a function has messed it
up (for example by filling it with blocks).

---

## B. On Linux, without 12d (the test harness)

This runs the same test build headless, translated to C++ under
AddressSanitizer, and is what checks the test build itself.

### 1. One-time setup

You need `g++`, Python 3, and optionally Pillow
(`pip install pillow`) for PNG snapshots. Then run:

```bash
cd tools/test_harness
```

### 2. Build

```bash
./build.sh
```

This builds two programs, `build/game` and `build/test`. Before building, it
checks that the function list (`test/src/test_registry.4dm`) is up to date
and stops if it isn't (see C). It should print `lint problems: 0`.

### 3. Run the test build scenario

```bash
./run.sh scenarios/26_test_build.txt
```

The scenario does the following:

1. presses Everything;
2. runs `floor_divide` 500 times with the source folder set;
3. runs the library call `Get_subtext`;
4. tries `menu_panel_run`, which can't be run;
5. checks that a report was written each time.

It must end with `type errors 0` and no sanitizer report.

The reports are in `tools/test_harness/run/cubeland_worlds/test_reports/`.
Open the newest `report_*.html` in a browser.

To run every scenario (the game ones too):

```bash
./run.sh --all
```

### 4. Your own script

Copy `scenarios/26_test_build.txt` and change the steps. The line
`# build: test` at the top makes `run.sh` use the test build. The steps
type into the panel by the box names shown above, for example:

- `input Runs|25340`
- `select_name <function>`
- `button run`

`tools/test_harness/README.md` lists every step.

---

## C. After you change the game's code

Whenever you add or remove a function, or change a function's parameters,
regenerate the function list:

```bash
python3 tools/make_test_registry.py
```

Run it from the repository root. It rewrites `test/include/test_registry.h`
and `test/src/test_registry.4dm`. Commit both.

If you forget, the harness build stops and tells you. To only check without
writing anything:

```bash
python3 tools/make_test_registry.py --check
```

Then recompile `test\cubeland_test.4dm` in 12d (A2).

## D. Adding a unit test

1. Open `test/src/test_cases.4dm`.
2. Find the group it belongs in, or start one with
   `test_group(p_results, "name");`.
3. Add a check:

   ```
   test_expect_integer(p_results, "floor_divide(-7, 2)", floor_divide(-7, 2), -4);
   test_expect_real   (p_results, "...", got, want, 0.0001);
   test_expect_text   (p_results, "...", got, want);
   test_expect_true   (p_results, "...", condition);
   ```

4. Recompile and press **Unit tests**, or run scenario 26 (B3).

## E. Giving a function better inputs

Each parameter gets its values by its name (for example `p_x` is a cell
across the world, 0 to 127). The rules are in `test/src/test_inputs.4dm`:

- `test_number_rule` for numbers;
- `test_text_choice` for text.

If a function gets nonsense inputs, add a rule there for its parameter
name. The report's "where each input came from" line shows which rule
was used.
