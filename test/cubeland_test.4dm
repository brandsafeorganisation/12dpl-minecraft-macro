//------------------------------------------------------------
// Cubeland test build
//
// Compile this file (not cubeland.4dm) for a macro that tests the
// game's code instead of playing it: a panel that runs any function
// of the game, or one of a list of 12d library calls, as many times
// as you like with generated inputs and times every call; runs every
// function once; runs the unit tests in test/src/test_cases.4dm; and
// writes an HTML report of the results in
// cubeland_worlds\test_reports (report_<time>.html).
//
// The list of functions is written by tools/make_test_registry.py:
// run it again after adding, removing or changing functions.
//
// Structure
//   test/cubeland_test.4dm    this file: main()
//   test/src/test_build.4dm   the game's src/build.4dm, then the
//                             test sources
//   test/src/, test/include/  the test code (see test/include/test.h)
//------------------------------------------------------------

#ifdef CUBELAND_TEST_BASE_FILE_4DM_INCLUDED
#error Do not include the base file!
#endif
#define CUBELAND_TEST_BASE_FILE_4DM_INCLUDED

#include "src/test_build.4dm"

void main()
// --------------------------------------------------------
// Entry point: the test panel
// --------------------------------------------------------
{
  test_panel_run();
}
