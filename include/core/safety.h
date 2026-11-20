#ifndef INCLUDE_SAFETY_H
#define INCLUDE_SAFETY_H

//------------------------------------------------------------
// Safety
//
// Blocks every 12dPL library call that could harm the computer, the
// 12d project or the user's files. Each blocked call is replaced by
// "illegal_call", which isn't defined anywhere, so a macro that uses
// one doesn't compile. That proves what the macro can't do without
// anyone reading the rest of the source:
//
//   - start programs, run shell commands or other macros and chains
//     (the one exception: with SAFE_ALLOW_LAN_HELPER, Windows
//     PowerShell running the LAN helper script that this file writes,
//     only through safe_run_helper() below)
//   - delete, copy, rename or overwrite files outside the worlds
//     folder, or delete folders
//   - delete or change models, tins, elements, views, functions or
//     project settings, or save the project
//   - use the clipboard, databases or network services (Synergy,
//     ODBC, web links)
//
// Files: File_open is blocked too. The only way to open a file is
// safe_file_open() below, which opens any file for reading but only
// opens files inside SAFE_WRITE_FOLDER for writing.
//
// build.4dm includes this file before anything else, so the blocks
// cover every source file. Do not include anything before it, and
// never #undef one of these names. It depends on no other header.
//------------------------------------------------------------

#define SAFE_WRITE_FOLDER  "cubeland_worlds"
#define SAFE_SHARE_FOLDER  "cubeland_mp"   // see SAFE_ALLOW_SHARE_FOLDER

// Two switches, set in build.4dm before it includes this file. Each
// prints a #warning when the macro compiles, so it is never on by
// accident (no apostrophes in #warning text: the preprocessor reads
// one as the start of an unterminated character).
//
//   SAFE_ALLOW_SHARE_FOLDER  multiplayer across PCs: files may also be
//                            written in any folder named cubeland_mp,
//                            such as \\other-pc\share\cubeland_mp
//   SAFETY_OFF               the blocked calls below are not blocked
//   SAFE_ALLOW_LAN_HELPER    real LAN play: safe_run_helper() may start
//                            Windows PowerShell (no window) with the LAN
//                            helper script, written from this file into
//                            cubeland_worlds\lan, and nothing else
//   SAFE_ALLOW_TEST_REPORTS  the test build (test/cubeland_test.4dm):
//                            .html files may be written in any folder,
//                            and safe_open_html() may open one in the
//                            web browser
#ifdef SAFE_ALLOW_TEST_REPORTS
#warning Safety: test reports (.html files) may be written in any folder and opened (SAFE_ALLOW_TEST_REPORTS)
#endif
#ifdef SAFE_ALLOW_SHARE_FOLDER
#warning Safety: files may be written in any folder named cubeland_mp (SAFE_ALLOW_SHARE_FOLDER)
#endif
#ifdef SAFE_ALLOW_LAN_HELPER
#warning Safety: the LAN helper may be started (Windows PowerShell running cubeland_worlds\lan\cubeland_lan.ps1) (SAFE_ALLOW_LAN_HELPER)
#endif
#ifdef SAFETY_OFF
#warning Safety is off: dangerous 12d calls are not blocked (SAFETY_OFF)
#endif
#define SAFE_OPEN_REFUSED  (-1)
#define SAFE_YES           (1)
#define SAFE_NO            (0)

#define SAFE_HELPER_FOLDER  "cubeland_worlds\\lan"
#define SAFE_HELPER_SCRIPT  "cubeland_lan.ps1"
#define SAFE_CREATE_NO_WINDOW 134217728   // CREATE_NO_WINDOW (0x08000000)


// ---------------------------------------------------------------- the one way to open a file

Integer safe_is_html(Text p_path)
// ----------------------------------------------------------------
// SAFE_YES if p_path names an .html file (any case)
// ----------------------------------------------------------------
{
  Integer l_length = Text_length(p_path);

  if (l_length < 6) return SAFE_NO;
  if (Text_lower(Get_subtext(p_path, l_length - 4, l_length)) != ".html") return SAFE_NO;
  return SAFE_YES;
}

Integer safe_path_is_writable(Text p_path)
// ----------------------------------------------------------------
// SAFE_YES if p_path is a file inside SAFE_WRITE_FOLDER (relative to the
// 12d working folder), with no ".." or drive letter that could
// climb out of it; with SAFE_ALLOW_SHARE_FOLDER, also a file in any
// folder named SAFE_SHARE_FOLDER (still no "..")
// ----------------------------------------------------------------
{
  Text    l_folder = SAFE_WRITE_FOLDER;
  Text    l_prefix = "";
  Integer l_length = 0;

  l_prefix = l_folder + "\\";
  l_length = Text_length(l_prefix);

  if (Find_text(p_path, "..") > 0)                       return SAFE_NO;
#ifdef SAFE_ALLOW_TEST_REPORTS
  if (safe_is_html(p_path))                              return SAFE_YES;
#endif
#ifdef SAFE_ALLOW_SHARE_FOLDER
  l_folder = SAFE_SHARE_FOLDER;
  if (Find_text(p_path, "\\" + l_folder + "\\") > 0)  return SAFE_YES;
  l_folder = SAFE_WRITE_FOLDER;
#endif
  if (Text_length(p_path) <= l_length)                   return SAFE_NO;
  if (Get_subtext(p_path, 1, l_length) != l_prefix)      return SAFE_NO;
  if (Find_text(p_path, ":")  > 0)                       return SAFE_NO;
  if (Find_text(p_path, "/")  > 0)                       return SAFE_NO;
  return SAFE_YES;
}

Integer safe_file_open(Text p_path, Text p_mode, File &p_file)
// ----------------------------------------------------------------
// File_open (as an ANSI file) that only reads, unless the file is in
// SAFE_WRITE_FOLDER. Modes "r" and "rb" open anything; any other mode
// ("w", "wb", "a", "r+", ...) needs safe_path_is_writable().
// Returns 0 when the file was opened, like File_open.
// ----------------------------------------------------------------
{
  Integer l_reading = SAFE_NO;

  if (p_mode == "r")  l_reading = SAFE_YES;
  if (p_mode == "rb") l_reading = SAFE_YES;

  if (!l_reading) {
    if (!safe_path_is_writable(p_path)) return SAFE_OPEN_REFUSED;
  }
  return File_open(p_path, p_mode, "", p_file);
}

Integer safe_folder_create(Text p_path)
// ----------------------------------------------------------------
// Make a folder (and nothing else), only inside SAFE_WRITE_FOLDER,
// with the same rules as safe_path_is_writable. Returns 0 when the
// folder is there afterwards.
// ----------------------------------------------------------------
{
  if (Directory_exists(p_path)) return 0;
  if (!safe_path_is_writable(p_path)) return SAFE_OPEN_REFUSED;
  Directory_create(p_path);
  if (Directory_exists(p_path)) return 0;
  return SAFE_OPEN_REFUSED;
}

#ifdef SAFE_ALLOW_TEST_REPORTS
Integer safe_open_html(Widget p_widget, Text p_path)
// ----------------------------------------------------------------
// Open an existing .html file in the web browser (Windows opens it
// with the program set for .html files). Nothing else can be opened
// or run. Returns 0 if it was opened.
// ----------------------------------------------------------------
{
  if (!safe_is_html(p_path))  return SAFE_OPEN_REFUSED;
  if (!File_exists(p_path))   return SAFE_OPEN_REFUSED;
  if (Find_text(p_path, "|") > 0 || Find_text(p_path, "&") > 0) return SAFE_OPEN_REFUSED;
  return Shell_execute(p_widget, "open", p_path, "", "", 1);
}
#endif


// ---------------------------------------------------------------- the one program that may be started

#include "safe_lan_script.h"

Integer safe_helper_word(Text p_word, Integer p_max)
// ----------------------------------------------------------------
// SAFE_YES if p_word is 1 to p_max letters, digits and _ (so it can't
// add a switch, a path or a second command to a command line)
// ----------------------------------------------------------------
{
  Integer l_length = Text_length(p_word);
  Integer l_at     = 0;
  Integer l_char   = 0;

  if (l_length < 1 || l_length > p_max) return SAFE_NO;
  for (l_at = 1; l_at <= l_length; ++l_at) {
    Get_char(p_word, l_at, l_char);
    if (l_char >= 48 && l_char <= 57)  continue;   // 0-9
    if (l_char >= 65 && l_char <= 90)  continue;   // A-Z
    if (l_char >= 97 && l_char <= 122) continue;   // a-z
    if (l_char == 95)                  continue;   // _
    return SAFE_NO;
  }
  return SAFE_YES;
}

Integer safe_helper_address(Text p_address)
// ----------------------------------------------------------------
// SAFE_YES if p_address is "" or four numbers 0..255 with dots
// ----------------------------------------------------------------
{
  Integer l_length = Text_length(p_address);
  Integer l_at     = 0;
  Integer l_char   = 0;
  Integer l_dots   = 0;
  Integer l_digits = 0;
  Integer l_value  = 0;

  if (l_length == 0) return SAFE_YES;
  if (l_length > 15) return SAFE_NO;
  for (l_at = 1; l_at <= l_length; ++l_at) {
    Get_char(p_address, l_at, l_char);
    if (l_char == 46) {
      if (l_digits == 0) return SAFE_NO;
      ++l_dots;
      l_digits = 0;
      l_value  = 0;
    } else if (l_char >= 48 && l_char <= 57) {
      ++l_digits;
      l_value = l_value * 10 + l_char - 48;
      if (l_digits > 3 || l_value > 255) return SAFE_NO;
    } else {
      return SAFE_NO;
    }
  }
  if (l_dots != 3 || l_digits == 0) return SAFE_NO;
  return SAFE_YES;
}

Integer safe_helper_system_root(Text p_root)
// ----------------------------------------------------------------
// SAFE_YES if p_root looks like Windows' folder: a drive letter,
// ":\" and letters only (C:\WINDOWS)
// ----------------------------------------------------------------
{
  Integer l_length = Text_length(p_root);
  Integer l_char   = 0;

  if (l_length < 4 || l_length > 40) return SAFE_NO;
  if (Get_subtext(p_root, 2, 3) != ":\\") return SAFE_NO;
  Get_char(p_root, 1, l_char);
  if (!((l_char >= 65 && l_char <= 90) || (l_char >= 97 && l_char <= 122))) return SAFE_NO;
  if (!safe_helper_word(Get_subtext(p_root, 4, l_length), 36)) return SAFE_NO;
  return SAFE_YES;
}

Text safe_helper_script_path()
// ----------------------------------------------------------------
// The helper script, from the working folder
// ----------------------------------------------------------------
{
  Text l_path   = SAFE_HELPER_FOLDER;
  Text l_script = SAFE_HELPER_SCRIPT;

  l_path = l_path + "\\" + l_script;
  return l_path;
}

Text safe_helper_program(Text p_system_root)
// ----------------------------------------------------------------
// Windows PowerShell under the Windows folder, "" if that isn't one
// ----------------------------------------------------------------
{
  if (!safe_helper_system_root(p_system_root)) return "";
  return p_system_root + "\\System32\\WindowsPowerShell\\v1.0\\powershell.exe";
}

Text safe_helper_command_line(Text p_mode, Text p_dir, Text p_run, Text p_session, Text p_id, Text p_address, Integer p_port,
                              Text p_script)
// ----------------------------------------------------------------
// The command line that starts the helper script p_script (relative
// to the start folder), or "" if any part could change what it does:
// the mode must be scan, host or join and every value a plain word,
// number or address, so no quotes are needed
// ----------------------------------------------------------------
{
  Text l_line = "";

  if (p_mode != "scan" && p_mode != "host" && p_mode != "join") return "";
  if (!safe_helper_word(p_dir, 48) || !safe_helper_word(p_run, 48)) return "";
  if (p_session != "" && !safe_helper_word(p_session, 12)) return "";
  if (p_id != "" && !safe_helper_word(p_id, 40)) return "";
  if (!safe_helper_address(p_address)) return "";
  if (p_port < 1024 || p_port > 65535) return "";
  if (p_script != SAFE_HELPER_SCRIPT && p_script != safe_helper_script_path()) return "";

  l_line = "powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -File " + p_script;
  l_line = l_line + " -Mode " + p_mode + " -Dir " + p_dir + " -Run " + p_run + " -Port " + To_text(p_port);
  if (p_session != "") l_line = l_line + " -Session " + p_session;
  if (p_id      != "") l_line = l_line + " -Id " + p_id;
  if (p_address != "") l_line = l_line + " -Address " + p_address;
  return l_line;
}

Integer safe_helper_start_folder(Text p_absolute)
// ----------------------------------------------------------------
// SAFE_YES if p_absolute (from Get_absolute_path) is the helper
// folder: it ends in \cubeland_worlds\lan (a \ after it or not)
// ----------------------------------------------------------------
{
  Text    l_path   = Text_lower(p_absolute);
  Text    l_end    = "\\cubeland_worlds\\lan";
  Integer l_length = Text_length(l_path);
  Integer l_want   = Text_length(l_end);

  if (l_length > 0) {
    if (Get_subtext(l_path, l_length, l_length) == "\\") {
      l_path   = Get_subtext(l_path, 1, l_length - 1);
      l_length = l_length - 1;
    }
  }
  if (l_length <= l_want) return SAFE_NO;
  if (Get_subtext(l_path, l_length - l_want + 1, l_length) != l_end) return SAFE_NO;
  if (Find_text(l_path, "..") > 0) return SAFE_NO;
  return SAFE_YES;
}

Integer safe_run_helper(Text p_system_root, Text p_mode, Text p_dir, Text p_run, Text p_session, Text p_id, Text p_address,
                        Integer p_port)
// ----------------------------------------------------------------
// Write the LAN helper script into SAFE_HELPER_FOLDER and start it
// with Windows PowerShell, without a window and without waiting.
// This is the only call to Create_process: it can only start that
// one program with that one script. Returns 0 if it started;
// SAFE_OPEN_REFUSED if anything is wrong, or without
// SAFE_ALLOW_LAN_HELPER.
// ----------------------------------------------------------------
{
#ifdef SAFE_ALLOW_LAN_HELPER
  File    l_file;
  Text    l_program = safe_helper_program(p_system_root);
  Text    l_folder  = "";
  Text    l_line    = "";
  Integer l_result  = 0;

  if (l_program == "") return SAFE_OPEN_REFUSED;
  if (safe_helper_command_line(p_mode, p_dir, p_run, p_session, p_id, p_address, p_port, SAFE_HELPER_SCRIPT) == "") {
    return SAFE_OPEN_REFUSED;
  }
  if (safe_folder_create(SAFE_HELPER_FOLDER) != 0) return SAFE_OPEN_REFUSED;
  if (safe_file_open(safe_helper_script_path(), "w", l_file) != 0) return SAFE_OPEN_REFUSED;
  safe_lan_script_write(l_file);
  File_close(l_file);

  // started in the helper folder, so the script is named without a
  // path (an absolute one could hold spaces); if 12d can't say where
  // that is, from the working folder
  l_folder = Get_absolute_path(SAFE_HELPER_FOLDER);
  if (safe_helper_start_folder(l_folder)) {
    l_line   = safe_helper_command_line(p_mode, p_dir, p_run, p_session, p_id, p_address, p_port, SAFE_HELPER_SCRIPT);
    l_result = Create_process(l_program, l_line, l_folder, SAFE_CREATE_NO_WINDOW, 0, 0);
    if (l_result == 0) return 0;
  }
  l_line = safe_helper_command_line(p_mode, p_dir, p_run, p_session, p_id, p_address, p_port,
                                    safe_helper_script_path());
  if (Create_process(l_program, l_line, "", SAFE_CREATE_NO_WINDOW, 0, 0) == 0) return 0;
  return SAFE_OPEN_REFUSED;
#else
  return SAFE_OPEN_REFUSED;
#endif
}


#ifndef SAFETY_OFF
// ---------------------------------------------------------------- blocked calls
// (defined after safe_file_open, which is the only code that may
// call File_open)

// Files
#define File_open                             illegal_call
#define File_copy                             illegal_call
#define Delete_files                          illegal_call
#define Set_file_read_only                    illegal_call
#define Directory_delete                      illegal_call
#define Directory_delete_recursive            illegal_call
#define Write_to_file                         illegal_call
#define Write_4d_ascii                        illegal_call
#define Write_12d                             illegal_call
#define Write_12d_data                        illegal_call
#define Write_SLX                             illegal_call
#define Write_DAE_file                        illegal_call
#define Write_XML                             illegal_call
#define Write_XML_Document                    illegal_call
#define Write_XML_document                    illegal_call
#define Write_parameter_file                  illegal_call
#define Write_favorite                        illegal_call
#define View_write_favourite_file             illegal_call
#define View_write_position_file              illegal_call
#define Save_output_window_to_XML             illegal_call
#define Dump_slx_image                        illegal_call
#define File_redirect                         illegal_call

// Programs, shell commands, other macros
#define Create_process                        illegal_call
#define Shell_execute                         illegal_call
#define System                                illegal_call
#define Process_exists                        illegal_call
#define Create_macro                          illegal_call
#define Create_macro_function                 illegal_call
#define Run_chain                             illegal_call
#define Recalc_chain_running                  illegal_call
#define Run_slf_data                          illegal_call
#define Run_slf_file                          illegal_call
#define Read_4d_ascii                         illegal_call
#define Read_project_settings_file            illegal_call

// Project data
#define Project_save                          illegal_call
#define Model_delete                          illegal_call
#define Model_rename                          illegal_call
#define Remove_model                          illegal_call
#define Tin_delete                            illegal_call
#define Tin_rename                            illegal_call
#define Element_delete                        illegal_call
#define Delete_element                        illegal_call
#define Delete_all_models                     illegal_call
#define Delete_all_empty_models               illegal_call
#define Delete_all_tins                       illegal_call
#define Delete_all_functions                  illegal_call
#define Delete_function_strings_and_models    illegal_call
#define Delete_all_dependancies               illegal_call
#define Delete_dependancy                     illegal_call
#define Delete_hip                            illegal_call
#define Function_delete                       illegal_call
#define Function_rename                       illegal_call
#define Template_rename                       illegal_call
#define View_delete                           illegal_call
#define View_remove_model                     illegal_call
#define Menu_delete                           illegal_call
#define Set_project_attribute                 illegal_call
#define Set_project_attributes                illegal_call
#define Project_attribute_delete              illegal_call
#define Project_attribute_delete_all          illegal_call
#define Model_attribute_delete                illegal_call
#define Model_attribute_delete_all            illegal_call
#define Set_project_setting_colour            illegal_call
#define Set_project_setting_integer           illegal_call
#define Set_project_setting_real              illegal_call
#define Remove_project_setting                illegal_call
#define Set_active_project_settings_profile   illegal_call
#define Remove_shared_in_model                illegal_call
#define Remove_shared_in_tin                  illegal_call
#define Remove_drainage_pit                   illegal_call
#define Run_drainage_2d                       illegal_call
#define Run_drainage_analysis                 illegal_call
#define Run_drainage_analysis_dynamic         illegal_call
#define Run_dws_network                       illegal_call

// Clipboard, databases, network
#define Get_clipboard_text                    illegal_call
#define Set_clipboard_text                    illegal_call
#define Console_to_clipboard                  illegal_call
#define Create_ODBC_connection                illegal_call
#define Connect                               illegal_call
#define Execute                               illegal_call
#define Synergy_connect                       illegal_call
#define Synergy_check_out                     illegal_call
#define Synergy_get                           illegal_call

#endif   // SAFETY_OFF

#endif
