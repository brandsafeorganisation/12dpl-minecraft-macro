#ifndef TEST_H_INCLUDED
#define TEST_H_INCLUDED

#include "../../include/core/records.h"

// ----------------------------------------------------------------
// The test build (test/cubeland_test.4dm)
//
// A separate macro made from the same source: a panel that runs any
// function of the game (or one of a list of library calls) as many
// times as you like with generated inputs and times it, runs every
// function once, runs the unit tests (test_cases.4dm), and writes an
// HTML report of it all in cubeland_worlds\test_reports.
//
//   test_registry   every function by number (written by
//                   tools/make_test_registry.py)
//   test_inputs     the values each kind of parameter gets
//   test_run        running a function many times, timing, results
//   test_cases      unit tests: calls with the answers they must give
//   test_report     the HTML report
//   test_panel      the panel (the controller)
//
// Functions get the game's own records (g_player, g_info, ...) for
// their Attributes parameters, so "Make test world" first gives them
// a generated world to work on. Other records get scratch records,
// a Draw_Box the panel's drawing box and a Dynamic_Text the words of
// a typical command.
//
// 12dPL can't catch a macro error, so before each function the run
// writes its name to cubeland_worlds\test_reports\progress.txt; if
// the macro stops inside one, the panel names it the next time.
// ----------------------------------------------------------------

#define TEST_REPORT_FOLDER      "cubeland_worlds\\test_reports"
#define TEST_PROGRESS_FILE      "cubeland_worlds\\test_reports\\progress.txt"
#define TEST_LAST_REPORT_FILE   "cubeland_worlds\\test_reports\\last_report.txt"
#define TEST_WORLD_SEED         12345
#define TEST_SAMPLES            12        // runs whose inputs and outputs the report lists
#define TEST_BUCKETS            8         // time histogram: under 1 us, 1-3, 3-10, 10-30, 30-100, 100-300, 300-1000, over 1000 us
#define TEST_DEFAULT_RUNS       1000
#define TEST_MAX_RUNS           10000000
#define TEST_CLOCK_SAMPLES      2000      // clock readings averaged to find what a reading costs
#define TEST_BOX_WIDTH          320
#define TEST_BOX_HEIGHT         200
#define TEST_TYPICAL_WORDS      "give @p stone 3"

// Data sets: each function run is one data set's calls
#define TEST_SET_TYPICAL        1         // every parameter's typical value
#define TEST_SET_RANDOM         2         // random values from each range
#define TEST_SET_EDGES          3         // the ends of each range
#define TEST_SETS               3
#define TEST_ALL_CALLS          4         // calls of each data set when running every function

// Kinds of parameter (the letters in the registry's parameter lists)
#define TEST_KIND_INTEGER       1
#define TEST_KIND_REAL          2
#define TEST_KIND_TEXT          3
#define TEST_KIND_RECORD        4
#define TEST_KIND_BOX           5
#define TEST_KIND_WORDS         6
#define TEST_KIND_MESSAGE       7

// One function's parameters, worked out once before its runs
#define DATATYPE_TEST_PARAMS    ("test_params")
#define ATTR_TP_COUNT           ("count")
#define ATTR_TP_KIND            ("kind")       // TEST_KIND_*
#define ATTR_TP_NAME            ("name")
#define ATTR_TP_REF             ("ref")        // TRUE for a reference (&) parameter
#define ATTR_TP_FIELD           ("field")      // its field in the input record ("i1", "r2", ...)
#define ATTR_TP_LOW             ("low")        // Integer and Real: the range random values come from
#define ATTR_TP_HIGH            ("high")
#define ATTR_TP_TYPICAL         ("typical")    // the value of a typical call
#define ATTR_TP_RULE            ("rule")       // which rule chose the values (for the report)

// Results: one record holding every function run (numbered n) and
// every unit test check (numbered c)
#define DATATYPE_TEST_RESULTS   ("test_results")
#define ATTR_TR_COUNT           ("count")
#define ATTR_TR_ID              ("id")         // registry number of function n
#define ATTR_TR_RUNS            ("runs")       // runs asked for
#define ATTR_TR_DONE            ("done")       // runs finished
#define ATTR_TR_SET             ("set")        // the data set its inputs came from (TEST_SET_*)
#define ATTR_TR_FIRST           ("first")      // seconds of the first call (often slower: nothing cached yet)
#define ATTR_TR_TOTAL           ("total")      // seconds for all the runs, clock to clock
#define ATTR_TR_SUM             ("sum")        // sum of the timed calls (clock cost taken off)
#define ATTR_TR_SUM_SQ          ("sum_sq")
#define ATTR_TR_MIN             ("min")
#define ATTR_TR_MAX             ("max")
#define ATTR_TR_BUCKET          ("bucket")     // + "_" + (n - 1) * TEST_BUCKETS + b
#define ATTR_TR_RET_MIN         ("ret_min")    // Integer or Real return values
#define ATTR_TR_RET_MAX         ("ret_max")
#define ATTR_TR_RET_SUM         ("ret_sum")
#define ATTR_TR_SAMPLE_IN       ("sample_in")  // + "_" + (n - 1) * TEST_SAMPLES + run
#define ATTR_TR_SAMPLE_OUT      ("sample_out")
#define ATTR_TR_SAMPLE_TIME     ("sample_time")
#define ATTR_TR_DOMAINS         ("domains")    // where each parameter's values came from
#define ATTR_TR_CHECKS          ("checks")
#define ATTR_TR_CHECK_NAME      ("check_name")
#define ATTR_TR_CHECK_GROUP     ("check_group")
#define ATTR_TR_CHECK_WANT      ("check_want")
#define ATTR_TR_CHECK_GOT       ("check_got")
#define ATTR_TR_CHECK_OK        ("check_ok")
#define ATTR_TR_GROUP           ("group")      // unit test group being run
#define ATTR_TR_CLOCK           ("clock")      // seconds one clock reading takes
#define ATTR_TR_TITLE           ("title")
#define ATTR_TR_STARTED         ("started")
#define ATTR_TR_SECONDS         ("seconds")    // the whole test run
#define ATTR_TR_NOTE            ("note")       // the previous run stopped inside this function
#define ATTR_TR_SKIPPED         ("skipped")    // how many functions "Run all" left out
#define ATTR_TR_SKIPPED_ID      ("skipped_id") // registry number of the one left out n

/*Global variables*/ {
  Draw_Box           g_test_box;        // the panel's drawing box, for functions that draw
  Colour_Message_Box g_test_message;    // the panel's message line, for functions that report
  Dynamic_Text       g_test_words;      // for Dynamic_Text parameters
  Attributes         g_test_record;     // scratch records for Attributes parameters
  Attributes         g_test_record_2;
  Attributes         g_test_record_3;
  Attributes         g_test_params;     // the parameters of the function being run
  Attributes         g_test_info;       // what the function being run is
  Attributes         g_test_in;
  Attributes         g_test_out;
  Attributes         g_test_results;
}

// ---------------------------------------------------------------- inputs
void    test_reset_words        (Dynamic_Text &p_words, Text p_text);
Text    test_words_text         (Dynamic_Text &p_words);
Text    test_quote              ();
Integer test_name_ends          (Text p_name, Text p_end);
void    test_number_rule        (Text p_function, Integer p_kind, Text p_name, Real &p_low, Real &p_high, Real &p_typical, Text &p_rule);
Integer test_text_choices       (Text p_function, Text p_name);
Text    test_text_choice        (Text p_function, Text p_name, Integer p_pick);
void    test_params_prepare     (Attributes &p_info, Attributes &p_params);
Integer test_edge_side          (Integer p_call, Integer p_param);
Text    test_set_name           (Integer p_set);
void    test_make_inputs        (Attributes &p_info, Attributes &p_params, Integer p_set, Integer p_call, Attributes &p_random, Attributes &p_in);
Text    test_inputs_text        (Attributes &p_params, Attributes &p_in);
Text    test_outputs_text       (Attributes &p_info, Attributes &p_params, Attributes &p_out);
Text    test_domains_text       (Attributes &p_params);

// ---------------------------------------------------------------- running
Integer test_function_id        (Text p_name);
Real    test_clock_cost         ();
void    test_results_clear      (Attributes &p_results, Text p_title, Real p_clock);
Integer test_bucket             (Real p_seconds);
void    test_progress           (Text p_line);
Text    test_progress_left      ();
Integer test_runnable           (Attributes &p_info, Integer p_with_writers);
Integer test_run_function       (Integer p_id, Integer p_runs, Integer p_set, Attributes &p_random, Attributes &p_results);
void    test_make_world         (Integer p_seed);

// ---------------------------------------------------------------- unit tests
void    test_group              (Attributes &p_results, Text p_group);
void    test_check              (Attributes &p_results, Text p_name, Text p_want, Text p_got, Integer p_ok);
void    test_expect_integer     (Attributes &p_results, Text p_name, Integer p_got, Integer p_want);
void    test_expect_real        (Attributes &p_results, Text p_name, Real p_got, Real p_want, Real p_tolerance);
void    test_expect_text        (Attributes &p_results, Text p_name, Text p_got, Text p_want);
void    test_expect_true        (Attributes &p_results, Text p_name, Integer p_got);
Integer test_checks_failed      (Attributes &p_results);
void    test_cases_run          (Attributes &p_results);

// ---------------------------------------------------------------- the report
Text    test_html               (Text p_text);
Text    test_micro              (Real p_seconds);
Text    test_js                 (Text p_text);
Text    test_js_number          (Real p_value);
Text    test_report_path        (Text p_folder);
Text    test_last_report        ();
Integer test_write_source       (File &p_file, Text p_source_folder, Attributes &p_info, Integer p_id);
void    test_write_function_info(File &p_file, Attributes &p_info, Integer p_id);
void    test_write_run          (File &p_file, Attributes &p_results, Integer p_index);
Integer test_write_report       (Attributes &p_results, Text p_source_folder, Text p_folder, Text &p_path);
void    test_report_page_start  (File &p_file);
void    test_report_page_end    (File &p_file);

// ---------------------------------------------------------------- the panel
void    test_panel_fill_list    (List_Box p_list, Text p_filter, Integer &p_ids_count);
Integer test_panel_run          ();

#endif
