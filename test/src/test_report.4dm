#ifndef TEST_REPORT_4DM_INCLUDED
#define TEST_REPORT_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/records.h"
#include "../../include/core/util.h"
#include "../include/test.h"
#include "../include/test_registry.h"

// ----------------------------------------------------------------
// The HTML report: a summary, failed checks, every unit test check,
// a table of the functions run (times per call), then each function
// in detail: signature, where it is, what it calls, where its inputs
// came from, its times with a histogram, the numbers it returned,
// sample calls with their inputs and outputs, and its code (read
// from the source folder, when the panel is told where that is).
//
// Written to cubeland_worlds\test_reports\report_<time>.html and
// copied to latest.html. HTML attributes use single quotes, so the
// macro never needs a double quote mark in its own strings.
// ----------------------------------------------------------------

Text test_html(Text p_text)
// ----------------------------------------------------------------
// p_text made safe to put in HTML (& < > and quote marks)
// ----------------------------------------------------------------
{
  Integer l_length = Text_length(p_text);
  Integer l_at     = 0;
  Text    l_char   = "";
  Text    l_out    = "";
  Text    l_quote  = test_quote();

  if (Find_text(p_text, "&") == 0 && Find_text(p_text, "<") == 0 && Find_text(p_text, ">") == 0 && Find_text(p_text, l_quote) == 0) {
    return p_text;
  }
  for (l_at = 1; l_at <= l_length; ++l_at) {
    l_char = Get_subtext(p_text, l_at, l_at);
    if (l_char == "&") {
      l_out = l_out + "&amp;";
    } else if (l_char == "<") {
      l_out = l_out + "&lt;";
    } else if (l_char == ">") {
      l_out = l_out + "&gt;";
    } else if (l_char == l_quote) {
      l_out = l_out + "&quot;";
    } else {
      l_out = l_out + l_char;
    }
  }
  return l_out;
}

Text test_micro(Real p_seconds)
// ----------------------------------------------------------------
// A time in microseconds for the report ("12.345")
// ----------------------------------------------------------------
{
  return To_text(p_seconds * 1000000.0, 3);
}

Text test_report_path(Text p_started)
// ----------------------------------------------------------------
// A new report file name from the time (seconds since 1970, so the
// names sort in order), with _2, _3 ... for more in the same second
// ----------------------------------------------------------------
{
  Integer l_now    = 0;
  Integer l_number = 1;
  Text    l_folder = TEST_REPORT_FOLDER;
  Text    l_path   = "";

  Get_time(l_now);
  l_path = l_folder + "\\report_" + To_text(l_now) + ".html";
  while (File_exists(l_path) && l_number < 1000) {
    ++l_number;
    l_path = l_folder + "\\report_" + To_text(l_now) + "_" + To_text(l_number) + ".html";
  }
  return l_path;
}

Integer test_write_source(File &p_file, Text p_source_folder, Attributes &p_info)
// ----------------------------------------------------------------
// Write a function's code from its source file, if it can be found
// (in p_source_folder, or the 12d working folder when that is
// blank). Returns TRUE if it was written.
// ----------------------------------------------------------------
{
  File    l_source;
  Text    l_path  = record_text(p_info, ATTR_TEST_FILE);
  Text    l_line  = "";
  Integer l_first = record_integer(p_info, ATTR_TEST_FIRST);
  Integer l_last  = record_integer(p_info, ATTR_TEST_LAST);
  Integer l_at    = 0;

  if (l_path == "") return FALSE;
  l_path = pack_replace(l_path, "/", "\\");
  if (p_source_folder != "") l_path = p_source_folder + "\\" + l_path;
  if (!File_exists(l_path)) return FALSE;
  if (safe_file_open(l_path, "r", l_source) != 0) return FALSE;

  File_write_line(p_file, "<pre class='code'>");
  for (l_at = 1; l_at <= l_last; ++l_at) {
    if (File_read_line(l_source, l_line) != 0) break;
    if (l_at >= l_first) File_write_line(p_file, test_html(l_line));
  }
  File_write_line(p_file, "</pre>");
  File_close(l_source);
  return TRUE;
}

Integer test_write_report(Attributes &p_results, Text p_source_folder, Text &p_path)
// ----------------------------------------------------------------
// Write the HTML report of p_results; p_path is where it went.
// Returns SUCCESS or FAILURE.
// ----------------------------------------------------------------
{
  File    l_file;
  Integer l_count    = record_integer(p_results, ATTR_TR_COUNT);
  Integer l_checks   = record_integer(p_results, ATTR_TR_CHECKS);
  Integer l_failed   = test_checks_failed(p_results);
  Integer l_index    = 0;
  Integer l_check    = 0;
  Integer l_row      = 0;
  Integer l_bucket   = 0;
  Integer l_most     = 0;
  Integer l_in_bucket= 0;
  Integer l_done     = 0;
  Integer l_total_runs = 0;
  Integer l_pass     = 0;
  Real    l_mean     = 0.0;
  Real    l_spread   = 0.0;
  Real    l_total    = 0.0;
  Real    l_width    = 0.0;
  Text    l_name     = "";
  Text    l_class    = "";
  Text    l_group    = "";
  Text    l_returns  = "";
  Text    l_bucket_name = "";
  Text    l_note     = record_text(p_results, ATTR_TR_NOTE);

  if (!Directory_exists(SAFE_WRITE_FOLDER )) Directory_create(SAFE_WRITE_FOLDER);
  if (!Directory_exists(TEST_REPORT_FOLDER)) Directory_create(TEST_REPORT_FOLDER);
  p_path = test_report_path(record_text(p_results, ATTR_TR_STARTED));
  if (safe_file_open(p_path, "w", l_file) != 0) return FAILURE;

  for (l_index = 1; l_index <= l_count; ++l_index) l_total_runs = l_total_runs + record_integer_at(p_results, ATTR_TR_DONE, l_index);

  // ---------------------------------------------------- head and summary
  File_write_line(l_file, "<!doctype html>");
  File_write_line(l_file, "<html><head><meta charset='utf-8'><title>Cubeland test report</title>");
  File_write_line(l_file, "<style>");
  File_write_line(l_file, "body{font-family:Segoe UI,Arial,sans-serif;margin:24px;color:#1d1f23;background:#f6f7f9}");
  File_write_line(l_file, "h1{margin:0 0 4px}h2{margin-top:32px;border-bottom:2px solid #ccd;padding-bottom:4px}");
  File_write_line(l_file, "table{border-collapse:collapse;background:#fff;margin:8px 0}");
  File_write_line(l_file, "td,th{border:1px solid #d5d8de;padding:4px 8px;text-align:left;vertical-align:top;font-size:13px}");
  File_write_line(l_file, "th{background:#e9ecf1}td.num{text-align:right;font-family:Consolas,monospace}");
  File_write_line(l_file, ".pass{color:#17803d;font-weight:600}.fail{color:#c0262d;font-weight:600}");
  File_write_line(l_file, ".box{background:#fff;border:1px solid #d5d8de;border-radius:6px;padding:12px 16px;margin:12px 0}");
  File_write_line(l_file, ".sig{font-family:Consolas,monospace;font-size:14px;background:#eef1f6;padding:6px 8px;border-radius:4px}");
  File_write_line(l_file, ".code{background:#1e2127;color:#d8dee9;padding:10px;border-radius:4px;font-size:12px;overflow:auto}");
  File_write_line(l_file, ".bar{display:inline-block;height:12px;background:#4a7bd0;vertical-align:middle}");
  File_write_line(l_file, ".note{background:#fff4d6;border:1px solid #e6c35c;padding:8px 12px;border-radius:4px}");
  File_write_line(l_file, ".small{color:#5b6270;font-size:12px}");
  File_write_line(l_file, "</style></head><body>");
  File_write_line(l_file, "<h1>Cubeland test report</h1>");
  File_write_line(l_file, "<div class='small'>" + test_html(record_text(p_results, ATTR_TR_TITLE)) + " &middot; started " +
                  test_html(record_text(p_results, ATTR_TR_STARTED)) + "</div>");
  if (l_note != "") {
    File_write_line(l_file, "<p class='note'>The previous test run stopped inside <b>" + test_html(l_note) +
                    "</b> (a macro error, or 12d was closed). It may not handle the inputs it was given there.</p>");
  }
  File_write_line(l_file, "<div class='box'><table>");
  File_write_line(l_file, "<tr><th>Functions run</th><td class='num'>" + To_text(l_count) + "</td></tr>");
  File_write_line(l_file, "<tr><th>Calls made</th><td class='num'>" + To_text(l_total_runs) + "</td></tr>");
  if (l_checks > 0) {
    l_class = "pass";
    if (l_failed > 0) l_class = "fail";
    File_write_line(l_file, "<tr><th>Unit test checks</th><td class='num'>" + To_text(l_checks) + "</td></tr>");
    File_write_line(l_file, "<tr><th>Failed checks</th><td class='num " + l_class + "'>" + To_text(l_failed) + "</td></tr>");
  }
  File_write_line(l_file, "<tr><th>Whole run</th><td class='num'>" + To_text(record_real(p_results, ATTR_TR_SECONDS), 3) + " s</td></tr>");
  File_write_line(l_file, "<tr><th>One clock reading</th><td class='num'>" + test_micro(record_real(p_results, ATTR_TR_CLOCK)) +
                  " &micro;s (taken off every timed call)</td></tr>");
  File_write_line(l_file, "</table></div>");

  // ---------------------------------------------------- unit tests
  if (l_checks > 0) {
    if (l_failed > 0) {
      File_write_line(l_file, "<h2>Failed checks</h2><table><tr><th>Group</th><th>Check</th><th>Wanted</th><th>Got</th></tr>");
      for (l_check = 1; l_check <= l_checks; ++l_check) {
        if (record_integer_at(p_results, ATTR_TR_CHECK_OK, l_check) == TRUE) continue;
        File_write_line(l_file, "<tr><td>" + test_html(record_text_at(p_results, ATTR_TR_CHECK_GROUP, l_check)) + "</td><td>" +
                        test_html(record_text_at(p_results, ATTR_TR_CHECK_NAME, l_check)) + "</td><td>" +
                        test_html(record_text_at(p_results, ATTR_TR_CHECK_WANT, l_check)) + "</td><td class='fail'>" +
                        test_html(record_text_at(p_results, ATTR_TR_CHECK_GOT, l_check)) + "</td></tr>");
      }
      File_write_line(l_file, "</table>");
    }
    File_write_line(l_file, "<h2>Unit tests</h2><table><tr><th>Group</th><th>Check</th><th>Wanted</th><th>Got</th><th></th></tr>");
    for (l_check = 1; l_check <= l_checks; ++l_check) {
      l_group = record_text_at(p_results, ATTR_TR_CHECK_GROUP, l_check);
      l_pass  = record_integer_at(p_results, ATTR_TR_CHECK_OK, l_check) == TRUE;
      l_class = "fail";
      l_name  = "fail";
      if (l_pass) {
        l_class = "pass";
        l_name  = "pass";
      }
      File_write_line(l_file, "<tr><td>" + test_html(l_group) + "</td><td>" + test_html(record_text_at(p_results, ATTR_TR_CHECK_NAME, l_check)) +
                      "</td><td>" + test_html(record_text_at(p_results, ATTR_TR_CHECK_WANT, l_check)) + "</td><td>" +
                      test_html(record_text_at(p_results, ATTR_TR_CHECK_GOT, l_check)) + "</td><td class='" + l_class + "'>" + l_name + "</td></tr>");
    }
    File_write_line(l_file, "</table>");
  }

  // ---------------------------------------------------- functions: overview
  if (l_count > 0) {
    File_write_line(l_file, "<h2>Functions</h2>");
    File_write_line(l_file, "<p class='small'>Times are per call, in microseconds, measured around the call alone. Calls a second counts the whole loop, inputs included.</p>");
    File_write_line(l_file, "<table><tr><th>Function</th><th>Part</th><th>Calls</th><th>Mean</th><th>Fastest</th><th>Slowest</th><th>Spread (sd)</th><th>All calls (ms)</th><th>Calls a second</th></tr>");
    for (l_index = 1; l_index <= l_count; ++l_index) {
      test_registry_info(record_integer_at(p_results, ATTR_TR_ID, l_index), g_test_info);
      l_done = record_integer_at(p_results, ATTR_TR_DONE, l_index);
      l_mean = 0.0;
      l_spread = 0.0;
      if (l_done > 0) {
        l_mean   = record_real_at(p_results, ATTR_TR_SUM, l_index) / l_done;
        l_spread = Sqrt(max_real(0.0, record_real_at(p_results, ATTR_TR_SUM_SQ, l_index) / l_done - l_mean * l_mean));
      }
      l_total = record_real_at(p_results, ATTR_TR_TOTAL, l_index);
      l_width = 0.0;
      if (l_total > 0.0) l_width = l_done / l_total;
      File_write_line(l_file, "<tr><td><a href='#f" + To_text(l_index) + "'>" + test_html(record_text(g_test_info, ATTR_TEST_NAME)) +
                      "</a></td><td>" + test_html(record_text(g_test_info, ATTR_TEST_PART)) + "</td><td class='num'>" + To_text(l_done) +
                      "</td><td class='num'>" + test_micro(l_mean) + "</td><td class='num'>" + test_micro(record_real_at(p_results, ATTR_TR_MIN, l_index)) +
                      "</td><td class='num'>" + test_micro(record_real_at(p_results, ATTR_TR_MAX, l_index)) + "</td><td class='num'>" +
                      test_micro(l_spread) + "</td><td class='num'>" + To_text(l_total * 1000.0, 3) + "</td><td class='num'>" +
                      To_text(floor_integer(l_width)) + "</td></tr>");
    }
    File_write_line(l_file, "</table>");
  }

  // ---------------------------------------------------- functions left out
  if (record_integer(p_results, ATTR_TR_SKIPPED) > 0) {
    File_write_line(l_file, "<h2>Left out</h2><table><tr><th>Function</th><th>Part</th><th>Why</th></tr>");
    for (l_row = 1; l_row <= record_integer(p_results, ATTR_TR_SKIPPED); ++l_row) {
      test_registry_info(record_integer_at(p_results, ATTR_TR_SKIPPED_ID, l_row), g_test_info);
      l_name = record_text(g_test_info, ATTR_TEST_WHY);
      if (l_name == "") l_name = "writes files (set the panel to include them)";
      File_write_line(l_file, "<tr><td>" + test_html(record_text(g_test_info, ATTR_TEST_NAME)) + "</td><td>" +
                      test_html(record_text(g_test_info, ATTR_TEST_PART)) + "</td><td>" + test_html(l_name) + "</td></tr>");
    }
    File_write_line(l_file, "</table>");
  }

  // ---------------------------------------------------- functions: detail
  for (l_index = 1; l_index <= l_count; ++l_index) {
    test_registry_info(record_integer_at(p_results, ATTR_TR_ID, l_index), g_test_info);
    l_done    = record_integer_at(p_results, ATTR_TR_DONE, l_index);
    l_returns = record_text(g_test_info, ATTR_TEST_RETURNS);
    l_mean    = 0.0;
    l_spread  = 0.0;
    if (l_done > 0) {
      l_mean   = record_real_at(p_results, ATTR_TR_SUM, l_index) / l_done;
      l_spread = Sqrt(max_real(0.0, record_real_at(p_results, ATTR_TR_SUM_SQ, l_index) / l_done - l_mean * l_mean));
    }
    File_write_line(l_file, "<h2 id='f" + To_text(l_index) + "'>" + test_html(record_text(g_test_info, ATTR_TEST_NAME)) + "</h2>");
    File_write_line(l_file, "<div class='sig'>" + test_html(record_text(g_test_info, ATTR_TEST_SIGNATURE)) + "</div>");
    File_write_line(l_file, "<table>");
    if (record_text(g_test_info, ATTR_TEST_KIND) == "library") {
      File_write_line(l_file, "<tr><th>Where</th><td>12d library call</td></tr>");
    } else {
      File_write_line(l_file, "<tr><th>Where</th><td>" + test_html(record_text(g_test_info, ATTR_TEST_FILE)) + ", lines " +
                      To_text(record_integer(g_test_info, ATTR_TEST_FIRST)) + " to " + To_text(record_integer(g_test_info, ATTR_TEST_LAST)) +
                      " (" + To_text(record_integer(g_test_info, ATTR_TEST_LAST) - record_integer(g_test_info, ATTR_TEST_FIRST) + 1) + " lines)</td></tr>");
    }
    if (record_text(g_test_info, ATTR_TEST_CALLS) != "") {
      File_write_line(l_file, "<tr><th>Calls</th><td>" + test_html(record_text(g_test_info, ATTR_TEST_CALLS)) + "</td></tr>");
    }
    if (record_integer(g_test_info, ATTR_TEST_FLAGS) == TEST_FLAG_WRITES_FILES) {
      File_write_line(l_file, "<tr><th>Note</th><td>writes files (in cubeland_worlds)</td></tr>");
    }
    if (record_text_at(p_results, ATTR_TR_DOMAINS, l_index) != "") {
      File_write_line(l_file, "<tr><th>Inputs</th><td>" + test_html(record_text_at(p_results, ATTR_TR_DOMAINS, l_index)) + "</td></tr>");
    }
    l_name = "typical values every call";
    if (record_integer_at(p_results, ATTR_TR_RANDOM, l_index) == TRUE) l_name = "typical values, then random ones";
    File_write_line(l_file, "<tr><th>Calls</th><td>" + To_text(l_done) + " (" + l_name + ")</td></tr>");
    File_write_line(l_file, "<tr><th>Time a call</th><td>mean " + test_micro(l_mean) + " &micro;s, fastest " +
                    test_micro(record_real_at(p_results, ATTR_TR_MIN, l_index)) + ", slowest " +
                    test_micro(record_real_at(p_results, ATTR_TR_MAX, l_index)) + ", spread " + test_micro(l_spread) + "</td></tr>");
    File_write_line(l_file, "<tr><th>All calls</th><td>" + To_text(record_real_at(p_results, ATTR_TR_TOTAL, l_index) * 1000.0, 3) +
                    " ms with making the inputs, " + To_text(record_real_at(p_results, ATTR_TR_SUM, l_index) * 1000.0, 3) + " ms in the function</td></tr>");
    if ((l_returns == "Integer" || l_returns == "Real") && l_done > 0) {
      File_write_line(l_file, "<tr><th>Returned</th><td>" + To_text(record_real_at(p_results, ATTR_TR_RET_MIN, l_index), 4) + " to " +
                      To_text(record_real_at(p_results, ATTR_TR_RET_MAX, l_index), 4) + ", mean " +
                      To_text(record_real_at(p_results, ATTR_TR_RET_SUM, l_index) / l_done, 4) + "</td></tr>");
    }
    File_write_line(l_file, "</table>");

    // time histogram
    l_most = 1;
    for (l_bucket = 1; l_bucket <= TEST_BUCKETS; ++l_bucket) {
      l_most = max_integer(l_most, record_integer_at(p_results, ATTR_TR_BUCKET, (l_index - 1) * TEST_BUCKETS + l_bucket));
    }
    File_write_line(l_file, "<table><tr><th>Time a call</th><th>Calls</th><th></th></tr>");
    for (l_bucket = 1; l_bucket <= TEST_BUCKETS; ++l_bucket) {
      l_in_bucket = record_integer_at(p_results, ATTR_TR_BUCKET, (l_index - 1) * TEST_BUCKETS + l_bucket);
      if (l_bucket == 1) l_bucket_name = "under 1 &micro;s";
      if (l_bucket == 2) l_bucket_name = "1 to 3 &micro;s";
      if (l_bucket == 3) l_bucket_name = "3 to 10 &micro;s";
      if (l_bucket == 4) l_bucket_name = "10 to 30 &micro;s";
      if (l_bucket == 5) l_bucket_name = "30 to 100 &micro;s";
      if (l_bucket == 6) l_bucket_name = "100 to 300 &micro;s";
      if (l_bucket == 7) l_bucket_name = "0.3 to 1 ms";
      if (l_bucket == 8) l_bucket_name = "over 1 ms";
      File_write_line(l_file, "<tr><td>" + l_bucket_name + "</td><td class='num'>" + To_text(l_in_bucket) +
                      "</td><td><span class='bar' style='width:" + To_text(floor_integer(300.0 * l_in_bucket / l_most)) + "px'></span></td></tr>");
    }
    File_write_line(l_file, "</table>");

    // sample calls
    File_write_line(l_file, "<table><tr><th>Call</th><th>Inputs</th><th>Outputs</th><th>&micro;s</th></tr>");
    for (l_row = 1; l_row <= min_integer(l_done, TEST_SAMPLES); ++l_row) {
      l_check = (l_index - 1) * TEST_SAMPLES + l_row;
      File_write_line(l_file, "<tr><td class='num'>" + To_text(l_row) + "</td><td>" + test_html(record_text_at(p_results, ATTR_TR_SAMPLE_IN, l_check)) +
                      "</td><td>" + test_html(record_text_at(p_results, ATTR_TR_SAMPLE_OUT, l_check)) + "</td><td class='num'>" +
                      test_micro(record_real_at(p_results, ATTR_TR_SAMPLE_TIME, l_check)) + "</td></tr>");
    }
    File_write_line(l_file, "</table>");

    if (!test_write_source(l_file, p_source_folder, g_test_info) && record_text(g_test_info, ATTR_TEST_KIND) != "library") {
      File_write_line(l_file, "<p class='small'>Code not shown: set the source folder in the panel to the folder holding src\\.</p>");
    }
  }

  File_write_line(l_file, "</body></html>");
  File_close(l_file);
  return SUCCESS;
}

#endif
