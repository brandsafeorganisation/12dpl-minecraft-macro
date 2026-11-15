#ifndef TEST_BUILD_4DM_INCLUDED
#define TEST_BUILD_4DM_INCLUDED

// The test build: the whole game (src/build.4dm, which includes the
// safety header first), then the test code. The game's main() is in
// cubeland.4dm, which this build doesn't include.

#include "../../src/build.4dm"

#include "test_inputs.4dm"
#include "test_registry.4dm"
#include "test_run.4dm"
#include "test_cases.4dm"
#include "test_report.4dm"
#include "test_panel.4dm"

#else
#error Do not include test_build.4dm more than once
#endif
