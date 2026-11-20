#ifndef LAN_4DM_INCLUDED
#define LAN_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/net/net.h"
#include "../../include/net/lan.h"

// ---------------------------------------------------------------- folders and files

Text lan_run_name(Real p_now)
// ----------------------------------------------------------------
// A name for a new run, from the time (so the files of
// earlier ones, which are never deleted, aren't mistaken for its)
// ----------------------------------------------------------------
{
  Real    l_ms     = (p_now - Floor(p_now / 1000000.0) * 1000000.0) * 1000.0;   // milliseconds, so two in one second differ
  Integer l_number = Floor(l_ms);

  return To_text(l_number);
}

Text lan_word(Text p_text)
// ----------------------------------------------------------------
// p_text with anything but letters, digits and _ made _ (the LAN
// helper only takes plain words), at most 40 characters
// ----------------------------------------------------------------
{
  Text    l_word   = p_text;
  Integer l_length = Text_length(p_text);
  Integer l_at     = 0;
  Integer l_char   = 0;

  if (l_length > 40) {
    l_word   = Get_subtext(p_text, 1, 40);
    l_length = 40;
  }
  for (l_at = 1; l_at <= l_length; ++l_at) {
    Get_char(l_word, l_at, l_char);
    if (l_char >= 48 && l_char <= 57)  continue;
    if (l_char >= 65 && l_char <= 90)  continue;
    if (l_char >= 97 && l_char <= 122) continue;
    Set_char(l_word, l_at, 95);
  }
  if (l_word == "") l_word = "player";
  return l_word;
}

Text lan_folder(Text p_dir)
// ----------------------------------------------------------------
// A helper's folder: p_dir inside LAN_FOLDER
// ----------------------------------------------------------------
{
  Text l_folder = LAN_FOLDER;

  return l_folder + "\\" + p_dir;
}

Text lan_scan_dir(Text p_run)
// ----------------------------------------------------------------
// The folder name a Play Multiplayer scan writes the worlds it hears in
// ----------------------------------------------------------------
{
  return "s_" + p_run;
}

Text lan_host_dir(Text p_session)
// ----------------------------------------------------------------
// The folder name a host keeps its session in
// ----------------------------------------------------------------
{
  return "h_" + p_session;
}

Text lan_join_dir(Text p_run)
// ----------------------------------------------------------------
// The folder name a guest keeps its copy of the session in
// ----------------------------------------------------------------
{
  return "j_" + p_run;
}

Integer lan_write_control(Text p_folder, Text p_run, Text p_word)
// ----------------------------------------------------------------
// Tell the helper to carry on ("run") or to stop ("stop"). Returns
// SUCCESS if the file was written.
// ----------------------------------------------------------------
{
  File l_file;

  if (safe_file_open(p_folder + "\\control_" + p_run + ".txt", "w", l_file) != 0) return FAILURE;
  File_write_line(l_file, p_word + " ~");
  File_close(l_file);
  return SUCCESS;
}

Integer lan_read_status(Text p_folder, Text p_run, Text &p_state, Text &p_detail)
// ----------------------------------------------------------------
// The helper's last word: its state ("hosting") and the rest
// ("24461"). Returns FAILURE (state "") if there is none yet, or it
// is half written (no ~ at the end).
// ----------------------------------------------------------------
{
  File         l_file;
  Dynamic_Text l_words;
  Text         l_path   = p_folder + "\\status_" + p_run + ".txt";
  Text         l_line   = "";
  Integer      l_length = 0;
  Integer      l_count  = 0;

  p_state  = "";
  p_detail = "";
  if (!File_exists(l_path)) return FAILURE;
  if (safe_file_open(l_path, "r", l_file) != 0) return FAILURE;
  if (File_read_line(l_file, l_line) != 0) l_line = "";
  File_close(l_file);
  l_line   = Text_justify(l_line);
  l_length = Text_length(l_line);
  if (l_length < 2) return FAILURE;
  if (Get_subtext(l_line, l_length, l_length) != "~") return FAILURE;
  l_line  = Text_justify(Get_subtext(l_line, 1, l_length - 1));
  l_count = From_text(l_line, l_words);
  if (l_count < 1) return FAILURE;
  Get_item(l_words, 1, p_state);
  p_detail = net_rest_of_line(l_line);
  return SUCCESS;
}

Text lan_status_problem(Text p_state, Text p_detail)
// ----------------------------------------------------------------
// What to tell the player about a helper's state, "" if all is well
// ----------------------------------------------------------------
{
  if (p_state == "lost")   return "Lost the connection to the host";
  if (p_state == "closed") return "The host closed the world";
  if (p_state != "failed") return "";
  if (p_detail == "the host did not answer") return "The host didn't answer: its firewall may be blocking Windows PowerShell";
  if (Find_text(p_detail, "locked down") > 0) return "PowerShell is locked down on this PC: connect through a shared folder (Options... > Multiplayer...)";
  if (p_detail == "no free port") return "No network port was free on this PC";
  if (p_detail == "that world is closed") return "That world is closed";
  if (Find_text(p_detail, "different version") > 0) return "The host is running a different version of the game";
  return "The network helper failed: " + p_detail;
}

// ---------------------------------------------------------------- a running helper

void lan_run_clear(Attributes &p_run)
// ----------------------------------------------------------------
// No helper running
// ----------------------------------------------------------------
{
  record_clear      (p_run, DATATYPE_LAN_RUN);
  record_set_integer(p_run, ATTR_LANR_ACTIVE,     FALSE);
  record_set_text   (p_run, ATTR_LANR_FOLDER,     "");
  record_set_text   (p_run, ATTR_LANR_RUN,        "");
  record_set_text   (p_run, ATTR_LANR_MODE,       "");
  record_set_real   (p_run, ATTR_LANR_STARTED,    0.0);
  record_set_real   (p_run, ATTR_LANR_NEXT_CHECK, 0.0);
  record_set_text   (p_run, ATTR_LANR_STATE,      "");
  record_set_text   (p_run, ATTR_LANR_DETAIL,     "");
  record_set_integer(p_run, ATTR_LANR_TOLD,       FALSE);
}

Integer lan_run_start(Attributes &p_run, Text p_system_root, Text p_mode, Text p_dir, Text p_run_name, Text p_session,
                      Text p_id, Text p_address, Integer p_port, Real p_now)
// ----------------------------------------------------------------
// Make the helper's folder and start it (p_system_root is Windows'
// folder, from the SystemRoot variable). A helper already running
// in p_run is told to stop first. Returns SUCCESS if it was started.
// ----------------------------------------------------------------
{
  Text l_lan    = LAN_FOLDER;
  Text l_folder = lan_folder(p_dir);

  lan_run_stop(p_run);
  lan_run_clear(p_run);
  if (safe_folder_create(l_lan) != 0)    return FAILURE;
  if (safe_folder_create(l_folder) != 0) return FAILURE;
  if (lan_write_control(l_folder, p_run_name, "run") != SUCCESS) return FAILURE;
  if (safe_run_helper(p_system_root, p_mode, p_dir, p_run_name, p_session, p_id, p_address, p_port) != 0) return FAILURE;
  record_set_integer(p_run, ATTR_LANR_ACTIVE,  TRUE);
  record_set_text   (p_run, ATTR_LANR_FOLDER,  l_folder);
  record_set_text   (p_run, ATTR_LANR_RUN,     p_run_name);
  record_set_text   (p_run, ATTR_LANR_MODE,    p_mode);
  record_set_real   (p_run, ATTR_LANR_STARTED, p_now);
  record_set_text   (p_run, ATTR_LANR_STATE,   "starting");
  return SUCCESS;
}

void lan_run_stop(Attributes &p_run)
// ----------------------------------------------------------------
// Tell a running helper to stop (it notices within a second)
// ----------------------------------------------------------------
{
  if (!lan_run_active(p_run)) return;
  lan_write_control(record_text(p_run, ATTR_LANR_FOLDER), record_text(p_run, ATTR_LANR_RUN), "stop");
  record_set_integer(p_run, ATTR_LANR_ACTIVE, FALSE);
}

Integer lan_run_active(Attributes &p_run)
// ----------------------------------------------------------------
// TRUE while a helper was started and not told to stop
// ----------------------------------------------------------------
{
  if (!Attribute_exists(p_run, ATTR_LANR_ACTIVE)) return FALSE;
  return record_integer(p_run, ATTR_LANR_ACTIVE) == TRUE;
}

Text lan_run_folder(Attributes &p_run)
// ----------------------------------------------------------------
// The running helper's folder
// ----------------------------------------------------------------
{
  return record_text(p_run, ATTR_LANR_FOLDER);
}

Text lan_run_state(Attributes &p_run)
// ----------------------------------------------------------------
// The helper's state when last checked ("hosting", "ready", ...)
// ----------------------------------------------------------------
{
  return record_text(p_run, ATTR_LANR_STATE);
}

Text lan_run_check(Attributes &p_run, Real p_now)
// ----------------------------------------------------------------
// Read the helper's status (at most every LAN_CHECK_SECONDS) and
// return a problem to tell the player, once, or "": a failure, a
// lost or closed connection, or no word from it after
// LAN_START_SECONDS (Windows PowerShell didn't start)
// ----------------------------------------------------------------
{
  Text l_state   = "";
  Text l_detail  = "";
  Text l_problem = "";

  if (!lan_run_active(p_run)) return "";
  if (p_now < record_real(p_run, ATTR_LANR_NEXT_CHECK)) return "";
  record_set_real(p_run, ATTR_LANR_NEXT_CHECK, p_now + LAN_CHECK_SECONDS);
  if (lan_read_status(lan_run_folder(p_run), record_text(p_run, ATTR_LANR_RUN), l_state, l_detail) == SUCCESS) {
    record_set_text(p_run, ATTR_LANR_STATE,  l_state);
    record_set_text(p_run, ATTR_LANR_DETAIL, l_detail);
    l_problem = lan_status_problem(l_state, l_detail);
  } else if (p_now - record_real(p_run, ATTR_LANR_STARTED) > LAN_START_SECONDS) {
    l_problem = "Windows PowerShell didn't start, so the network can't be used: connect through a shared folder (Options... > Multiplayer...)";
  }
  if (l_problem == "" || record_integer(p_run, ATTR_LANR_TOLD) == TRUE) return "";
  record_set_integer(p_run, ATTR_LANR_TOLD, TRUE);
  return l_problem;
}

#endif
