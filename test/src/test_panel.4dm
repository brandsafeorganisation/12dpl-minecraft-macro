#ifndef TEST_PANEL_4DM_INCLUDED
#define TEST_PANEL_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/records.h"
#include "../../include/program/game.h"
#include "../../include/ui/panels.h"
#include "../include/test.h"
#include "../include/test_registry.h"

// ----------------------------------------------------------------
// The test panel (controller of the test build)
//
//   Find / Filter       narrow the list of functions (part of a name,
//                       a part of the game such as "world", or
//                       "library" for the library calls)
//   Run selected        call the selected function Runs times and
//                       write a report on it
//   Run all once        call every function a few times with each data set
//   Unit tests          run the checks in test_cases.4dm
//   Everything          the unit tests, then every function once
//   Make test world     generate the world the functions work on again
//   Open last report    open the newest report in the web browser
//
// Data sets says which inputs the calls get (typical values, random
// ones, the ends of each range, or all three, compared in the report).
//
// It names the global records and reads the clock, as controllers do.
// ----------------------------------------------------------------

void test_panel_fill_list(List_Box p_list, Text p_filter, Integer &p_ids_count)
// ----------------------------------------------------------------
// List the functions whose name, part or kind contains p_filter
// (all of them when it is blank); the registry numbers of the rows
// go in g_test_record_3 (field "id", numbered by row)
// ----------------------------------------------------------------
{
  Integer l_existing = 0;
  Integer l_row      = 0;
  Integer l_id       = 0;
  Text    l_filter   = Text_lower(Text_justify(p_filter));
  Text    l_name     = "";

  Get_number_of_items(p_list, l_existing);
  for (l_row = l_existing; l_row >= 1; --l_row) Delete_item(p_list, l_row);

  record_clear(g_test_record_3, DATATYPE_TEST_RESULTS);
  p_ids_count = 0;
  for (l_id = 1; l_id <= TEST_FUNCTION_COUNT; ++l_id) {
    test_registry_info(l_id, g_test_info);
    l_name = record_text(g_test_info, ATTR_TEST_NAME);
    if (l_filter != "") {
      if (Find_text(Text_lower(l_name), l_filter) == 0 && Find_text(record_text(g_test_info, ATTR_TEST_PART), l_filter) == 0 &&
          Find_text(record_text(g_test_info, ATTR_TEST_KIND), l_filter) == 0) continue;
    }
    ++p_ids_count;
    record_set_integer_at(g_test_record_3, ATTR_TR_ID, p_ids_count, l_id);
    Add_item(p_list, l_name);
  }
  if (p_ids_count > 0) Set_selection(p_list, 1);
}

Integer test_panel_run()
// ----------------------------------------------------------------
// Show the test panel until it is closed
// ----------------------------------------------------------------
{
  Panel              l_panel        = Create_panel("Cubeland - test build");
  Vertical_Group     l_vgroup       = Create_vertical_group(0);
  Colour_Message_Box l_message      = Create_colour_message_box("");
  Input_Box          l_find_box     = Create_input_box("Find function", l_message);
  List_Box           l_list         = Create_list_box("Functions", l_message, 12);
  Input_Box          l_runs_box     = Create_input_box("Runs", l_message);
  Input_Box          l_sets_box     = Create_input_box("Data sets (typical, random, edges or all)", l_message);
  Input_Box          l_writers_box  = Create_input_box("Run all includes functions that write files (yes or no)", l_message);
  Input_Box          l_source_box   = Create_input_box("Source folder (holds src, for code in the report)", l_message);
  Input_Box          l_folder_box   = Create_input_box("Report folder", l_message);
  Input_Box          l_open_box     = Create_input_box("Open the report when it is written (yes or no)", l_message);
  Draw_Box           l_box          = Create_draw_box(TEST_BOX_WIDTH, TEST_BOX_HEIGHT, 0);
  Horizontal_Group   l_buttons      = Create_button_group();
  Button             l_filter_button= Create_button("&Filter", "filter");
  Button             l_run_button   = Create_button("&Run selected", "run");
  Button             l_all_button   = Create_button("Run &all once", "run_all");
  Button             l_unit_button  = Create_button("&Unit tests", "unit");
  Horizontal_Group   l_buttons_2    = Create_button_group();
  Button             l_every_button = Create_button("&Everything", "everything");
  Button             l_world_button = Create_button("Make test &world", "world");
  Button             l_open_button  = Create_button("&Open last report", "open");
  Button             l_quit_button  = Create_finish_button("Quit", "quit");
  Integer            l_running      = TRUE;
  Integer            l_result       = 0;
  Integer            l_rows         = 0;
  Integer            l_selected     = 0;
  Integer            l_id           = 0;
  Integer            l_runs         = 0;
  Integer            l_set          = 0;
  Integer            l_set_first    = TEST_SET_TYPICAL;
  Integer            l_set_last     = TEST_SETS;
  Integer            l_open         = TRUE;
  Integer            l_written      = FALSE;
  Integer            l_writers      = FALSE;
  Integer            l_index        = 0;
  Integer            l_ran          = 0;
  Integer            l_skipped      = 0;
  Integer            l_time_seed    = 0;
  Integer            l_do_units     = FALSE;
  Integer            l_do_all       = FALSE;
  Integer64          l_event_id     = 0;
  Real               l_start        = 0.0;
  Real               l_end          = 0.0;
  Real               l_clock        = 0.0;
  Text               l_cmd          = "";
  Text               l_msg          = "";
  Text               l_text         = "";
  Text               l_source       = "";
  Text               l_path         = "";
  Text               l_left         = "";
  Text               l_title        = "";
  Text               l_folder       = TEST_REPORT_FOLDER;
  Text               l_last_report  = "";

  Append(l_filter_button, l_buttons);
  Append(l_run_button   , l_buttons);
  Append(l_all_button   , l_buttons);
  Append(l_unit_button  , l_buttons);
  Append(l_every_button , l_buttons_2);
  Append(l_world_button , l_buttons_2);
  Append(l_open_button  , l_buttons_2);
  Append(l_quit_button  , l_buttons_2);
  Append(l_find_box     , l_vgroup);
  Append(l_list         , l_vgroup);
  Append(l_runs_box     , l_vgroup);
  Append(l_sets_box     , l_vgroup);
  Append(l_writers_box  , l_vgroup);
  Append(l_source_box   , l_vgroup);
  Append(l_folder_box   , l_vgroup);
  Append(l_open_box     , l_vgroup);
  Append(l_buttons      , l_vgroup);
  Append(l_buttons_2    , l_vgroup);
  Append(l_box          , l_vgroup);
  Append(l_message      , l_vgroup);
  Append(l_vgroup       , l_panel);
  Show_widget(l_panel);

  g_test_box     = l_box;
  g_test_message = l_message;
  Set_data(l_runs_box,    To_text(TEST_DEFAULT_RUNS));
  Set_data(l_sets_box,    "all");
  Set_data(l_folder_box,  l_folder);
  Set_data(l_open_box,    "yes");
  Set_data(l_writers_box, "no");
  // the code for the report: next to the working folder (12d), or one
  // folder up (release\cubeland_test.exe in the repository)
  Set_data(l_source_box,  "");
  if (!File_exists("src\\build.4dm") && File_exists("..\\src\\build.4dm")) Set_data(l_source_box, "..");

  // the same start as the game, then a world for the functions
  Set_data(l_message, "Loading textures and making the test world...");
  Get_time(l_time_seed);
  game_init_once(g_game, g_book, g_settings, g_random, l_time_seed);
  test_make_world(TEST_WORLD_SEED);
  l_clock = test_clock_cost();
  test_panel_fill_list(l_list, "", l_rows);

  l_left = test_progress_left();
  if (l_left != "") {
    Set_data(l_message, "The last test run stopped inside " + l_left + " (see the next report).");
  } else {
    Set_data(l_message, To_text(TEST_FUNCTION_COUNT) + " functions. Pick one and press Run selected, or run them all.");
  }

  while (l_running) {
    l_event_id = 0;
    l_cmd      = "";
    l_msg      = "";
    if (Wait_on_events(l_event_id, l_cmd, l_msg) != 0) continue;
    if (l_cmd == "keystroke" || l_cmd == "set_focus" || l_cmd == "kill_focus") continue;

    if (l_cmd == "CodeShutdown") {
      Set_exit_code(l_cmd);
      l_result  = SHUTDOWN_CODE;
      l_running = FALSE;
      continue;
    }
    if (l_cmd == "Panel Quit" || l_cmd == "quit") {
      l_running = FALSE;
      continue;
    }

    // the settings boxes, read for every command
    Get_data(l_runs_box, l_text);
    l_runs = TEST_DEFAULT_RUNS;
    if (From_text(Text_justify(l_text), l_runs) != 0) l_runs = TEST_DEFAULT_RUNS;
    l_runs = clamp_integer(l_runs, 1, TEST_MAX_RUNS);
    Get_data(l_sets_box, l_text);
    l_text      = Text_lower(Text_justify(l_text));
    l_set_first = TEST_SET_TYPICAL;
    l_set_last  = TEST_SETS;
    if (l_text == "typical") l_set_last  = TEST_SET_TYPICAL;
    if (l_text == "random" ) {
      l_set_first = TEST_SET_RANDOM;
      l_set_last  = TEST_SET_RANDOM;
    }
    if (l_text == "edges"  ) {
      l_set_first = TEST_SET_EDGES;
      l_set_last  = TEST_SET_EDGES;
    }
    Get_data(l_open_box, l_text);
    l_open = Text_lower(Text_justify(l_text)) != "no";
    Get_data(l_folder_box, l_folder);
    l_folder = Text_justify(l_folder);
    if (l_folder == "") l_folder = TEST_REPORT_FOLDER;
    Get_data(l_writers_box, l_text);
    l_writers = Text_lower(Text_justify(l_text)) == "yes";
    Get_data(l_source_box, l_source);
    l_source = Text_justify(l_source);

    if (l_cmd == "filter" || l_cmd == "text selected") {
      Get_data(l_find_box, l_text);
      test_panel_fill_list(l_list, l_text, l_rows);
      Set_data(l_message, To_text(l_rows) + " functions listed.");

    } else if (l_cmd == "world") {
      Set_data(l_message, "Making the test world...");
      test_make_world(TEST_WORLD_SEED);
      Set_data(l_message, "Made the test world (seed " + To_text(TEST_WORLD_SEED) + ").");

    } else if (l_cmd == "open") {
      if (l_last_report == "") l_last_report = test_last_report();
      if (l_last_report == "") {
        Set_data(l_message, "No report yet in " + l_folder + ".");
      } else if (safe_open_html(l_panel, l_last_report) != 0) {
        Set_data(l_message, "Could not open " + l_last_report + ".");
      }

    } else if (l_cmd == "run") {
      l_selected = 0;
      Get_selection(l_list, l_selected);
      l_id = 0;
      if (l_selected >= 1 && l_selected <= l_rows) l_id = record_integer_at(g_test_record_3, ATTR_TR_ID, l_selected);
      if (l_id == 0) {
        Set_data(l_message, "Select a function in the list first.");
        continue;
      }
      test_registry_info(l_id, g_test_info);
      if (record_text(g_test_info, ATTR_TEST_WHY) != "") {
        Set_data(l_message, record_text(g_test_info, ATTR_TEST_NAME) + " can not be run here: it " + record_text(g_test_info, ATTR_TEST_WHY) + ".");
        continue;
      }
      Set_data(l_message, "Running " + record_text(g_test_info, ATTR_TEST_NAME) + " " + To_text(l_runs) + " times...");
      test_results_clear(g_test_results, record_text(g_test_info, ATTR_TEST_NAME) + " x " + To_text(l_runs), l_clock);
      record_set_text(g_test_results, ATTR_TR_NOTE, test_progress_left());
      Get_time(l_start);
      for (l_set = l_set_first; l_set <= l_set_last; ++l_set) test_run_function(l_id, l_runs, l_set, g_random, g_test_results);
      Get_time(l_end);
      record_set_real(g_test_results, ATTR_TR_SECONDS, l_end - l_start);
      l_written = test_write_report(g_test_results, l_source, l_folder, l_path) == SUCCESS;
      if (l_written) {
        l_last_report = l_path;
        Set_data(l_message, "Ran " + record_text(g_test_info, ATTR_TEST_NAME) + " " + To_text(l_runs) + " times a data set in " +
                 To_text(l_end - l_start, 3) + " s. Report: " + l_path);
        if (l_open) safe_open_html(l_panel, l_path);
      } else {
        Set_data(l_message, "Ran it, but could not write the report in " + l_folder + ".");
      }

    } else if (l_cmd == "run_all" || l_cmd == "unit" || l_cmd == "everything") {
      l_do_units = l_cmd == "unit" || l_cmd == "everything";
      l_do_all   = l_cmd == "run_all" || l_cmd == "everything";
      l_title    = "Every function";
      if (l_cmd == "unit") l_title = "Unit tests";
      if (l_cmd == "everything") l_title = "Unit tests and every function";
      test_results_clear(g_test_results, l_title, l_clock);
      record_set_text(g_test_results, ATTR_TR_NOTE, test_progress_left());
      Get_time(l_start);
      // a fresh world, so what one test changed doesn't move the next
      test_make_world(TEST_WORLD_SEED);
      if (l_do_units) {
        Set_data(l_message, "Running the unit tests...");
        test_progress("started the unit tests");
        test_cases_run(g_test_results);
        test_progress("finished the unit tests");
      }
      l_ran     = 0;
      l_skipped = 0;
      if (l_do_all) {
        test_make_world(TEST_WORLD_SEED);
        for (l_index = 1; l_index <= TEST_FUNCTION_COUNT; ++l_index) {
          test_registry_info(l_index, g_test_info);
          if (!test_runnable(g_test_info, l_writers)) {
            ++l_skipped;
            record_set_integer   (g_test_results, ATTR_TR_SKIPPED,    l_skipped);
            record_set_integer_at(g_test_results, ATTR_TR_SKIPPED_ID, l_skipped, l_index);
            continue;
          }
          if (positive_mod(l_ran, 25) == 0) Set_data(l_message, "Running " + record_text(g_test_info, ATTR_TEST_NAME) + "...");
          for (l_set = l_set_first; l_set <= l_set_last; ++l_set) test_run_function(l_index, TEST_ALL_CALLS, l_set, g_random, g_test_results);
          ++l_ran;
        }
        // whatever the functions did to the game's records, start clean
        test_make_world(TEST_WORLD_SEED);
      }
      Get_time(l_end);
      record_set_real(g_test_results, ATTR_TR_SECONDS, l_end - l_start);
      l_text = "";
      if (l_do_units) {
        l_text = To_text(record_integer(g_test_results, ATTR_TR_CHECKS) - test_checks_failed(g_test_results)) + " of " +
                 To_text(record_integer(g_test_results, ATTR_TR_CHECKS)) + " checks passed. ";
      }
      if (l_do_all) l_text = l_text + "Ran " + To_text(l_ran) + " functions (" + To_text(l_skipped) + " left out). ";
      l_written = test_write_report(g_test_results, l_source, l_folder, l_path) == SUCCESS;
      if (l_written) {
        l_last_report = l_path;
        Set_data(l_message, l_text + "Report: " + l_path);
        if (l_open) safe_open_html(l_panel, l_path);
      } else {
        Set_data(l_message, l_text + "Could not write the report in " + l_folder + ".");
      }
    }
  }

  Hide_widget(l_panel);
  return l_result;
}

#endif
