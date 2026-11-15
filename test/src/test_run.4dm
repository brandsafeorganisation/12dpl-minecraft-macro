#ifndef TEST_RUN_4DM_INCLUDED
#define TEST_RUN_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/records.h"
#include "../../include/core/util.h"
#include "../../include/program/game.h"
#include "../../include/world/world.h"
#include "../../include/world/mesh.h"
#include "../../include/player/player.h"
#include "../../include/mobs/cows.h"
#include "../include/test.h"
#include "../include/test_registry.h"

// ----------------------------------------------------------------
// Running functions: many calls with generated inputs, each timed
// between two clock readings inside the registry, with the cost of
// a clock reading taken off. The results record keeps, per function
// run, the times (total, fastest, slowest, sum and sum of squares
// for the spread, a histogram), the range of numbers returned, and
// the inputs and outputs of the first TEST_SAMPLES calls.
// ----------------------------------------------------------------

Integer test_function_id(Text p_name)
// ----------------------------------------------------------------
// Registry number of the function called p_name (the first of that
// name), 0 if there is none
// ----------------------------------------------------------------
{
  Integer l_id = 0;

  for (l_id = 1; l_id <= TEST_FUNCTION_COUNT; ++l_id) {
    test_registry_info(l_id, g_test_info);
    if (record_text(g_test_info, ATTR_TEST_NAME) == p_name) return l_id;
  }
  return 0;
}

Real test_clock_cost()
// ----------------------------------------------------------------
// Seconds between two clock readings with nothing between them
// (averaged): what each timed call is charged for being timed
// ----------------------------------------------------------------
{
  Integer l_sample = 0;
  Real    l_start  = 0.0;
  Real    l_end    = 0.0;
  Real    l_sum    = 0.0;

  for (l_sample = 1; l_sample <= TEST_CLOCK_SAMPLES; ++l_sample) {
    Get_time(l_start);
    Get_time(l_end);
    l_sum = l_sum + (l_end - l_start);
  }
  return l_sum / TEST_CLOCK_SAMPLES;
}

void test_results_clear(Attributes &p_results, Text p_title, Real p_clock)
// ----------------------------------------------------------------
// Start an empty set of results
// ----------------------------------------------------------------
{
  Text l_started = "";

  Get_time(l_started);
  record_clear      (p_results, DATATYPE_TEST_RESULTS);
  record_set_integer(p_results, ATTR_TR_COUNT,   0);
  record_set_integer(p_results, ATTR_TR_CHECKS,  0);
  record_set_text   (p_results, ATTR_TR_TITLE,   p_title);
  record_set_text   (p_results, ATTR_TR_STARTED, l_started);
  record_set_real   (p_results, ATTR_TR_CLOCK,   p_clock);
  record_set_real   (p_results, ATTR_TR_SECONDS, 0.0);
  record_set_text   (p_results, ATTR_TR_GROUP,   "");
  record_set_text   (p_results, ATTR_TR_NOTE,    "");
  record_set_integer(p_results, ATTR_TR_SKIPPED, 0);
}

Integer test_bucket(Real p_seconds)
// ----------------------------------------------------------------
// Histogram bucket (1..TEST_BUCKETS) of a call's time
// ----------------------------------------------------------------
{
  Real l_micro = p_seconds * 1000000.0;

  if (l_micro < 1.0   ) return 1;
  if (l_micro < 3.0   ) return 2;
  if (l_micro < 10.0  ) return 3;
  if (l_micro < 30.0  ) return 4;
  if (l_micro < 100.0 ) return 5;
  if (l_micro < 300.0 ) return 6;
  if (l_micro < 1000.0) return 7;
  return 8;
}

void test_progress(Text p_line)
// ----------------------------------------------------------------
// Note what the test run is doing in the progress file, so a run
// that stops with a macro error can be told about next time
// ----------------------------------------------------------------
{
  File l_file;

  if (!Directory_exists(SAFE_WRITE_FOLDER )) Directory_create(SAFE_WRITE_FOLDER);
  if (!Directory_exists(TEST_REPORT_FOLDER)) Directory_create(TEST_REPORT_FOLDER);
  if (safe_file_open(TEST_PROGRESS_FILE, "w", l_file) != 0) return;
  File_write_line(l_file, p_line);
  File_close(l_file);
}

Text test_progress_left()
// ----------------------------------------------------------------
// The function the last run was inside when it stopped, "" if it
// finished (the progress file says "started <name>" until it ends)
// ----------------------------------------------------------------
{
  File l_file;
  Text l_line = "";

  if (!File_exists(TEST_PROGRESS_FILE)) return "";
  if (safe_file_open(TEST_PROGRESS_FILE, "r", l_file) != 0) return "";
  File_read_line(l_file, l_line);
  File_close(l_file);
  if (Find_text(l_line, "started ") == 1) return Get_subtext(l_line, 9, Text_length(l_line));
  return "";
}

Integer test_runnable(Attributes &p_info, Integer p_with_writers)
// ----------------------------------------------------------------
// TRUE if "Run all" should call this function: it can be called
// and, unless p_with_writers, doesn't write files
// ----------------------------------------------------------------
{
  if (record_text(p_info, ATTR_TEST_WHY) != "") return FALSE;
  if (!p_with_writers && record_integer(p_info, ATTR_TEST_FLAGS) == TEST_FLAG_WRITES_FILES) return FALSE;
  return TRUE;
}

Integer test_run_function(Integer p_id, Integer p_runs, Integer p_random_inputs, Attributes &p_random, Attributes &p_results)
// ----------------------------------------------------------------
// Call function p_id p_runs times (the first with typical inputs,
// the rest random ones if p_random_inputs) and add its results.
// Returns the result's number, 0 if the function can't be called.
// ----------------------------------------------------------------
{
  Integer l_index   = record_integer(p_results, ATTR_TR_COUNT) + 1;
  Integer l_run     = 0;
  Integer l_bucket  = 0;
  Integer l_row     = 0;
  Real    l_clock   = record_real(p_results, ATTR_TR_CLOCK);
  Real    l_start   = 0.0;
  Real    l_end     = 0.0;
  Real    l_seconds = 0.0;
  Real    l_sum     = 0.0;
  Real    l_sum_sq  = 0.0;
  Real    l_min     = 0.0;
  Real    l_max     = 0.0;
  Real    l_ret     = 0.0;
  Real    l_ret_min = 0.0;
  Real    l_ret_max = 0.0;
  Real    l_ret_sum = 0.0;
  Text    l_returns = "";
  Integer l_draws   = FALSE;
  Integer l_param   = 0;
  Integer l_buckets[TEST_BUCKETS];

  test_registry_info(p_id, g_test_info);
  if (record_text(g_test_info, ATTR_TEST_WHY) != "") return 0;
  l_returns = record_text(g_test_info, ATTR_TEST_RETURNS);
  for (l_bucket = 1; l_bucket <= TEST_BUCKETS; ++l_bucket) l_buckets[l_bucket] = 0;

  test_params_prepare(g_test_info, g_test_params);
  record_clear(g_test_record,   DATATYPE_TEST_INFO);
  record_clear(g_test_record_2, DATATYPE_TEST_INFO);
  record_set_integer   (p_results, ATTR_TR_COUNT,   l_index);
  record_set_integer_at(p_results, ATTR_TR_ID,      l_index, p_id);
  record_set_integer_at(p_results, ATTR_TR_RUNS,    l_index, p_runs);
  record_set_integer_at(p_results, ATTR_TR_DONE,    l_index, 0);
  record_set_integer_at(p_results, ATTR_TR_RANDOM,  l_index, p_random_inputs);
  record_set_text_at   (p_results, ATTR_TR_DOMAINS, l_index, test_domains_text(g_test_params));

  // a function that draws draws into the panel's box, in one batch
  for (l_param = 1; l_param <= record_integer(g_test_params, ATTR_TP_COUNT); ++l_param) {
    if (record_integer_at(g_test_params, ATTR_TP_KIND, l_param) == TEST_KIND_BOX) l_draws = TRUE;
  }
  if (l_draws) Start_batch_draw(g_test_box);

  test_progress("started " + record_text(g_test_info, ATTR_TEST_NAME));
  Get_time(l_start);
  for (l_run = 1; l_run <= p_runs; ++l_run) {
    test_make_inputs(g_test_info, g_test_params, p_random_inputs && l_run > 1, p_random, g_test_in);
    test_registry_call(p_id, g_test_in, g_test_out);

    l_seconds = max_real(0.0, record_real(g_test_out, ATTR_TEST_SECONDS) - l_clock);
    l_sum     = l_sum + l_seconds;
    l_sum_sq  = l_sum_sq + l_seconds * l_seconds;
    if (l_run == 1 || l_seconds < l_min) l_min = l_seconds;
    if (l_run == 1 || l_seconds > l_max) l_max = l_seconds;
    l_bucket = test_bucket(l_seconds);
    l_buckets[l_bucket] = l_buckets[l_bucket] + 1;

    if (l_returns == "Integer" || l_returns == "Real") {
      l_ret = record_integer(g_test_out, ATTR_TEST_RET_I);
      if (l_returns == "Real") l_ret = record_real(g_test_out, ATTR_TEST_RET_R);
      if (l_run == 1 || l_ret < l_ret_min) l_ret_min = l_ret;
      if (l_run == 1 || l_ret > l_ret_max) l_ret_max = l_ret;
      l_ret_sum = l_ret_sum + l_ret;
    }
    if (l_run <= TEST_SAMPLES) {
      l_row = (l_index - 1) * TEST_SAMPLES + l_run;
      record_set_text_at(p_results, ATTR_TR_SAMPLE_IN,   l_row, test_inputs_text(g_test_params, g_test_in));
      record_set_text_at(p_results, ATTR_TR_SAMPLE_OUT,  l_row, test_outputs_text(g_test_info, g_test_params, g_test_out));
      record_set_real_at(p_results, ATTR_TR_SAMPLE_TIME, l_row, l_seconds);
    }
  }
  Get_time(l_end);
  if (l_draws) End_batch_draw(g_test_box);
  test_progress("finished " + record_text(g_test_info, ATTR_TEST_NAME));

  record_set_integer_at(p_results, ATTR_TR_DONE,    l_index, p_runs);
  record_set_real_at   (p_results, ATTR_TR_TOTAL,   l_index, l_end - l_start);
  record_set_real_at   (p_results, ATTR_TR_SUM,     l_index, l_sum);
  record_set_real_at   (p_results, ATTR_TR_SUM_SQ,  l_index, l_sum_sq);
  record_set_real_at   (p_results, ATTR_TR_MIN,     l_index, l_min);
  record_set_real_at   (p_results, ATTR_TR_MAX,     l_index, l_max);
  record_set_real_at   (p_results, ATTR_TR_RET_MIN, l_index, l_ret_min);
  record_set_real_at   (p_results, ATTR_TR_RET_MAX, l_index, l_ret_max);
  record_set_real_at   (p_results, ATTR_TR_RET_SUM, l_index, l_ret_sum);
  for (l_bucket = 1; l_bucket <= TEST_BUCKETS; ++l_bucket) {
    record_set_integer_at(p_results, ATTR_TR_BUCKET, (l_index - 1) * TEST_BUCKETS + l_bucket, l_buckets[l_bucket]);
  }
  return l_index;
}

void test_make_world(Integer p_seed)
// ----------------------------------------------------------------
// Give the functions a world to work on: generate one from the seed
// and put the player at its spawn point with some cows about (the
// same as starting a new world, but nothing is saved)
// ----------------------------------------------------------------
{
  Real l_x = 0.0;
  Real l_y = 0.0;
  Real l_z = 0.0;

  game_reset_state(g_game, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_events, g_hud, g_ui);
  record_set_text(g_game, ATTR_GAME_WORLD_NAME, "zz_test");
  world_generate (g_info, p_seed);
  mesh_reset();
  world_info_spawn(g_info, l_x, l_y, l_z);
  player_reset    (g_player, l_x, l_y + COLLISION_EPSILON, l_z);
  player_set_look (g_player, HALF_PI * 3.0, -0.1);
  cows_spawn_random(g_cows, g_random, COW_TARGET_COUNT, l_x, l_z, 10.0);
  events_clear(g_events);
}

#endif
