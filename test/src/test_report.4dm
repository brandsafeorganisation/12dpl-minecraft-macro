#ifndef TEST_REPORT_4DM_INCLUDED
#define TEST_REPORT_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/records.h"
#include "../../include/core/util.h"
#include "../include/test.h"
#include "../include/test_registry.h"
#include "test_report_page.4dm"

// ----------------------------------------------------------------
// The HTML report. The page itself (styles, tabs, sortable tables,
// charts, the panel that shows one function) is fixed: it is in
// test_report_page.4dm, written from test/report/report_page.html.
// This file writes the run's numbers into it as a script, R = {...}:
//
//   title, started, seconds, clock, note   the run
//   checks   [group, check, wanted, got, passed] per unit test check
//   runs     one per function and data set: times in microseconds,
//            histogram, returned range, sample calls, input domains
//   fns      what each function is (signature, file, lines, calls)
//   skipped  registry numbers of the functions left out
//
// and each function's code as a hidden <pre id='code<n>'>. Written to
// report_<time>.html in the report folder (cubeland_worlds\test_reports
// unless the panel says otherwise). Strings in the script use single
// quotes, so the macro never needs a double quote mark.
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

Text test_js(Text p_text)
// ----------------------------------------------------------------
// p_text as a JavaScript string in single quotes (backslashes,
// quote marks and < escaped, so it can't end the script)
// ----------------------------------------------------------------
{
  Integer l_length = Text_length(p_text);
  Integer l_at     = 0;
  Integer l_code   = 0;
  Text    l_char   = "";
  Text    l_out    = "";

  if (Find_text(p_text, "\\") == 0 && Find_text(p_text, "'") == 0 && Find_text(p_text, "<") == 0 && Find_text(p_text, test_quote()) == 0) {
    return "'" + p_text + "'";
  }
  for (l_at = 1; l_at <= l_length; ++l_at) {
    l_char = Get_subtext(p_text, l_at, l_at);
    Get_char(l_char, 1, l_code);
    if (l_char == "\\") {
      l_out = l_out + "\\\\";
    } else if (l_char == "'") {
      l_out = l_out + "\\x27";
    } else if (l_char == "<") {
      l_out = l_out + "\\x3c";
    } else if (l_code == 34) {
      l_out = l_out + "\\x22";
    } else {
      l_out = l_out + l_char;
    }
  }
  return "'" + l_out + "'";
}

Text test_js_number(Real p_value)
// ----------------------------------------------------------------
// A number for the script (6 decimals); NaN and infinities as the
// script spells them (a function given edge values can return them)
// ----------------------------------------------------------------
{
  if (p_value != p_value) return "NaN";
  if (p_value >  1.0e308) return "Infinity";
  if (p_value < -1.0e308) return "-Infinity";
  return To_text(p_value, 6);
}

Text test_report_path(Text p_folder)
// ----------------------------------------------------------------
// A new report file name in p_folder from the time (seconds since
// 1970, so the names sort in order), with _2, _3 ... for more in the
// same second
// ----------------------------------------------------------------
{
  Integer l_now    = 0;
  Integer l_number = 1;
  Text    l_path   = "";

  Get_time(l_now);
  l_path = p_folder + "\\report_" + To_text(l_now) + ".html";
  while (File_exists(l_path) && l_number < 1000) {
    ++l_number;
    l_path = p_folder + "\\report_" + To_text(l_now) + "_" + To_text(l_number) + ".html";
  }
  return l_path;
}

Text test_last_report()
// ----------------------------------------------------------------
// The report written last (by this run of the panel or an earlier
// one), "" if there is none
// ----------------------------------------------------------------
{
  File l_file;
  Text l_line = "";

  if (!File_exists(TEST_LAST_REPORT_FILE)) return "";
  if (safe_file_open(TEST_LAST_REPORT_FILE, "r", l_file) != 0) return "";
  File_read_line(l_file, l_line);
  File_close(l_file);
  if (!File_exists(l_line)) return "";
  return l_line;
}

Integer test_write_source(File &p_file, Text p_source_folder, Attributes &p_info, Integer p_id)
// ----------------------------------------------------------------
// Write a function's code from its source file as a hidden block the
// page shows with the function (id 'code<p_id>'), if it can be found
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

  File_write_line(p_file, "<pre id='code" + To_text(p_id) + "' hidden>");
  for (l_at = 1; l_at <= l_last; ++l_at) {
    if (File_read_line(l_source, l_line) != 0) break;
    if (l_at >= l_first) File_write_line(p_file, test_html(l_line));
  }
  File_write_line(p_file, "</pre>");
  File_close(l_source);
  return TRUE;
}

void test_write_function_info(File &p_file, Attributes &p_info, Integer p_id)
// ----------------------------------------------------------------
// One entry of R.fns: what function p_id is
// ----------------------------------------------------------------
{
  Integer l_writes = 0;

  if (record_integer(p_info, ATTR_TEST_FLAGS) == TEST_FLAG_WRITES_FILES) l_writes = 1;
  File_write_line(p_file, "{id:" + To_text(p_id) + ",name:" + test_js(record_text(p_info, ATTR_TEST_NAME)) +
                  ",part:" + test_js(record_text(p_info, ATTR_TEST_PART)) + ",module:" + test_js(record_text(p_info, ATTR_TEST_MODULE)) +
                  ",kind:" + test_js(record_text(p_info, ATTR_TEST_KIND)) + ",file:" + test_js(record_text(p_info, ATTR_TEST_FILE)) +
                  ",first:" + To_text(record_integer(p_info, ATTR_TEST_FIRST)) + ",last:" + To_text(record_integer(p_info, ATTR_TEST_LAST)) +
                  ",returns:" + test_js(record_text(p_info, ATTR_TEST_RETURNS)) + ",sig:" + test_js(record_text(p_info, ATTR_TEST_SIGNATURE)) +
                  ",calls:" + test_js(record_text(p_info, ATTR_TEST_CALLS)) + ",writes:" + To_text(l_writes) +
                  ",why:" + test_js(record_text(p_info, ATTR_TEST_WHY)) + "},");
}

void test_write_run(File &p_file, Attributes &p_results, Integer p_index)
// ----------------------------------------------------------------
// One entry of R.runs: function run p_index (one data set's calls)
// ----------------------------------------------------------------
{
  Integer l_done    = record_integer_at(p_results, ATTR_TR_DONE, p_index);
  Integer l_row     = 0;
  Integer l_sample  = 0;
  Integer l_bucket  = 0;
  Integer l_has_ret = 0;
  Real    l_mean    = 0.0;
  Real    l_squares = 0.0;
  Real    l_ret_mean= 0.0;
  Text    l_line    = "";
  Text    l_returns = record_text(g_test_info, ATTR_TEST_RETURNS);

  if (l_done > 0) {
    l_mean     = record_real_at(p_results, ATTR_TR_SUM,     p_index) / l_done * 1000000.0;
    l_squares  = record_real_at(p_results, ATTR_TR_SUM_SQ,  p_index) / l_done * 1000000000000.0;
    l_ret_mean = record_real_at(p_results, ATTR_TR_RET_SUM, p_index) / l_done;
    if (l_returns == "Integer" || l_returns == "Real") l_has_ret = 1;
  }
  l_line = "{f:" + To_text(record_integer_at(p_results, ATTR_TR_ID, p_index)) + ",s:" + To_text(record_integer_at(p_results, ATTR_TR_SET, p_index)) +
           ",n:" + To_text(l_done) + ",mean:" + test_js_number(l_mean) + ",sq:" + test_js_number(l_squares) +
           ",min:" + test_js_number(record_real_at(p_results, ATTR_TR_MIN, p_index) * 1000000.0) +
           ",max:" + test_js_number(record_real_at(p_results, ATTR_TR_MAX, p_index) * 1000000.0) +
           ",first:" + test_js_number(record_real_at(p_results, ATTR_TR_FIRST, p_index) * 1000000.0) +
           ",ms:" + test_js_number(record_real_at(p_results, ATTR_TR_TOTAL, p_index) * 1000.0) +
           ",fnms:" + test_js_number(record_real_at(p_results, ATTR_TR_SUM, p_index) * 1000.0) +
           ",hasret:" + To_text(l_has_ret) + ",rmin:" + test_js_number(record_real_at(p_results, ATTR_TR_RET_MIN, p_index)) +
           ",rmax:" + test_js_number(record_real_at(p_results, ATTR_TR_RET_MAX, p_index)) + ",rmean:" + test_js_number(l_ret_mean) + ",b:[";
  for (l_bucket = 1; l_bucket <= TEST_BUCKETS; ++l_bucket) {
    if (l_bucket > 1) l_line = l_line + ",";
    l_line = l_line + To_text(record_integer_at(p_results, ATTR_TR_BUCKET, (p_index - 1) * TEST_BUCKETS + l_bucket));
  }
  File_write_line(p_file, l_line + "],dom:" + test_js(record_text_at(p_results, ATTR_TR_DOMAINS, p_index)) + ",smp:[");
  for (l_sample = 1; l_sample <= min_integer(l_done, TEST_SAMPLES); ++l_sample) {
    l_row = (p_index - 1) * TEST_SAMPLES + l_sample;
    File_write_line(p_file, "[" + test_js(record_text_at(p_results, ATTR_TR_SAMPLE_IN, l_row)) + "," +
                    test_js(record_text_at(p_results, ATTR_TR_SAMPLE_OUT, l_row)) + "," +
                    test_js_number(record_real_at(p_results, ATTR_TR_SAMPLE_TIME, l_row) * 1000000.0) + "],");
  }
  File_write_line(p_file, "]},");
}

Integer test_write_report(Attributes &p_results, Text p_source_folder, Text p_folder, Text &p_path)
// ----------------------------------------------------------------
// Write the HTML report of p_results in p_folder; p_path is where it
// went. Returns SUCCESS or FAILURE.
// ----------------------------------------------------------------
{
  File       l_file;
  File       l_last;
  Attributes l_seen;
  Integer    l_count   = record_integer(p_results, ATTR_TR_COUNT);
  Integer    l_checks  = record_integer(p_results, ATTR_TR_CHECKS);
  Integer    l_skipped = record_integer(p_results, ATTR_TR_SKIPPED);
  Integer    l_index   = 0;
  Integer    l_id      = 0;
  Integer    l_ok      = 0;

  if (!Directory_exists(SAFE_WRITE_FOLDER )) Directory_create(SAFE_WRITE_FOLDER);
  if (!Directory_exists(TEST_REPORT_FOLDER)) Directory_create(TEST_REPORT_FOLDER);
  if (!Directory_exists(p_folder)) Directory_create(p_folder);
  p_path = test_report_path(p_folder);
  if (safe_file_open(p_path, "w", l_file) != 0) return FAILURE;

  test_report_page_start(l_file);

  // ---------------------------------------------------- the run
  File_write_line(l_file, "<script>");
  File_write_line(l_file, "const R = {title:" + test_js(record_text(p_results, ATTR_TR_TITLE)) + ",started:" + test_js(record_text(p_results, ATTR_TR_STARTED)) +
                  ",seconds:" + test_js_number(record_real(p_results, ATTR_TR_SECONDS)) +
                  ",clock:" + test_js_number(record_real(p_results, ATTR_TR_CLOCK) * 1000000.0) + ",note:" + test_js(record_text(p_results, ATTR_TR_NOTE)) + ",");
  File_write_line(l_file, "checks:[");
  for (l_index = 1; l_index <= l_checks; ++l_index) {
    l_ok = 0;
    if (record_integer_at(p_results, ATTR_TR_CHECK_OK, l_index) == TRUE) l_ok = 1;
    File_write_line(l_file, "[" + test_js(record_text_at(p_results, ATTR_TR_CHECK_GROUP, l_index)) + "," +
                    test_js(record_text_at(p_results, ATTR_TR_CHECK_NAME, l_index)) + "," +
                    test_js(record_text_at(p_results, ATTR_TR_CHECK_WANT, l_index)) + "," +
                    test_js(record_text_at(p_results, ATTR_TR_CHECK_GOT, l_index)) + "," + To_text(l_ok) + "],");
  }
  File_write_line(l_file, "],runs:[");
  for (l_index = 1; l_index <= l_count; ++l_index) {
    test_registry_info(record_integer_at(p_results, ATTR_TR_ID, l_index), g_test_info);
    test_write_run(l_file, p_results, l_index);
  }
  File_write_line(l_file, "],skipped:[");
  for (l_index = 1; l_index <= l_skipped; ++l_index) {
    File_write_line(l_file, To_text(record_integer_at(p_results, ATTR_TR_SKIPPED_ID, l_index)) + ",");
  }

  // ---------------------------------------------------- each function once
  record_clear(l_seen, DATATYPE_TEST_RESULTS);
  File_write_line(l_file, "],fns:[");
  for (l_index = 1; l_index <= l_count + l_skipped; ++l_index) {
    if (l_index <= l_count) {
      l_id = record_integer_at(p_results, ATTR_TR_ID, l_index);
    } else {
      l_id = record_integer_at(p_results, ATTR_TR_SKIPPED_ID, l_index - l_count);
    }
    if (record_integer_at(l_seen, ATTR_TR_ID, l_id) != 0) continue;
    record_set_integer_at(l_seen, ATTR_TR_ID, l_id, 1);
    test_registry_info(l_id, g_test_info);
    test_write_function_info(l_file, g_test_info, l_id);
  }
  File_write_line(l_file, "]};");
  File_write_line(l_file, "</script>");

  // ---------------------------------------------------- their code
  record_clear(l_seen, DATATYPE_TEST_RESULTS);
  for (l_index = 1; l_index <= l_count; ++l_index) {
    l_id = record_integer_at(p_results, ATTR_TR_ID, l_index);
    if (record_integer_at(l_seen, ATTR_TR_ID, l_id) != 0) continue;
    record_set_integer_at(l_seen, ATTR_TR_ID, l_id, 1);
    test_registry_info(l_id, g_test_info);
    test_write_source(l_file, p_source_folder, g_test_info, l_id);
  }

  test_report_page_end(l_file);
  File_close(l_file);

  // remember it for Open last report
  if (safe_file_open(TEST_LAST_REPORT_FILE, "w", l_last) == 0) {
    File_write_line(l_last, p_path);
    File_close(l_last);
  }
  return SUCCESS;
}

#endif
