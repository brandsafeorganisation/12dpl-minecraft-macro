#ifndef NET_4DM_INCLUDED
#define NET_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/core/events.h"
#include "../../include/world/world.h"
#include "../../include/player/player.h"
#include "../../include/render/hud.h"
#include "../../include/net/net.h"

// ---------------------------------------------------------------- set up

void net_clear(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox)
// ----------------------------------------------------------------
// Not in a multiplayer game: no session, no players, nothing read
// ----------------------------------------------------------------
{
  record_clear      (p_net,   DATATYPE_NET);
  record_set_integer(p_net,   ATTR_NET_MODE,      NET_OFF);
  record_set_integer(p_net,   ATTR_NET_OUT_COUNT, 0);
  record_set_text   (p_net,   ATTR_NET_PROBLEM,   "");
  record_clear      (p_peers, DATATYPE_PEERS);
  record_set_integer(p_peers, ATTR_PEER_COUNT,    0);
  record_clear      (p_inbox, DATATYPE_NET_INBOX);
  record_set_integer(p_inbox, ATTR_INBOX_COUNT,   0);
}

Integer net_mode(Attributes &p_net)
// ----------------------------------------------------------------
// NET_OFF, NET_HOST or NET_GUEST
// ----------------------------------------------------------------
{
  return record_integer(p_net, ATTR_NET_MODE);
}

Text net_clean_name(Text p_name)
// ----------------------------------------------------------------
// A name with only letters, digits, - and _ (spaces become _), at
// most 20 characters, so it can be part of a file name; "player"
// if nothing is left
// ----------------------------------------------------------------
{
  Text    l_allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_";
  Text    l_clean   = "";
  Text    l_char    = "";
  Integer l_at      = 0;

  for (l_at = 1; l_at <= Text_length(p_name); ++l_at) {
    if (Text_length(l_clean) >= 20) break;
    l_char = Get_subtext(p_name, l_at, l_at);
    if (l_char == " ") l_char = "_";
    if (Find_text(l_allowed, l_char) > 0) l_clean = l_clean + l_char;
  }
  if (l_clean == "") l_clean = "player";
  return l_clean;
}

Text net_session_path(Text p_folder)
// ----------------------------------------------------------------
// The file naming the host's current session
// ----------------------------------------------------------------
{
  return p_folder + "\\session.txt";
}

Text net_snapshot_path(Text p_folder, Text p_session)
// ----------------------------------------------------------------
// The host's world as it was when the session started
// ----------------------------------------------------------------
{
  return p_folder + "\\snapshot_" + p_session + ".txt";
}

Text net_log_name(Text p_session, Text p_id)
// ----------------------------------------------------------------
// The file name of one player's log in a session
// ----------------------------------------------------------------
{
  return "log_" + p_session + "_" + p_id + ".txt";
}

Integer net_ensure_folder(Text p_folder)
// ----------------------------------------------------------------
// Make the multiplayer folder (and the worlds folder it is usually
// in) if it isn't there. Returns TRUE if it exists afterwards.
// ----------------------------------------------------------------
{
  Text l_worlds = WORLD_FOLDER;

  if (Directory_exists(p_folder)) return TRUE;
  if (!Directory_exists(l_worlds)) Directory_create(l_worlds);
  Directory_create(p_folder);
  return Directory_exists(p_folder);
}

Integer net_write_session(Text p_folder, Text p_session, Text p_host_id, Integer p_seed, Text p_world_name)
// ----------------------------------------------------------------
// Host: name the session that joining players should join
// ----------------------------------------------------------------
{
  File l_file;
  Text l_tag = NET_SESSION_TAG;

  if (safe_file_open(net_session_path(p_folder), "w", l_file) != 0) return FAILURE;
  File_write_line(l_file, l_tag + " " + To_text(NET_PROTOCOL));
  File_write_line(l_file, "session " + p_session);
  File_write_line(l_file, "host " + p_host_id);
  File_write_line(l_file, "seed " + To_text(p_seed));
  File_write_line(l_file, "world " + p_world_name);
  File_close(l_file);
  return SUCCESS;
}

Integer net_read_session(Text p_folder, Text &p_session, Text &p_host_id, Integer &p_seed, Text &p_world_name, Text &p_problem)
// ----------------------------------------------------------------
// Joining: which session the host is running. Returns FAILURE with
// problem saying why if there is none.
// ----------------------------------------------------------------
{
  File         l_file;
  Dynamic_Text l_words;
  Text         l_line  = "";
  Text         l_key   = "";
  Text         l_tag   = NET_SESSION_TAG;
  Integer      l_count = 0;

  p_session    = "";
  p_host_id    = "";
  p_seed       = 0;
  p_world_name = "";
  p_problem    = "";
  if (!File_exists(net_session_path(p_folder))) {
    p_problem = "nobody is hosting in " + p_folder;
    return FAILURE;
  }
  if (safe_file_open(net_session_path(p_folder), "r", l_file) != 0) {
    p_problem = "the session file in " + p_folder + " couldn't be opened";
    return FAILURE;
  }
  while (File_read_line(l_file, l_line) == 0) {
    Null(l_words);
    l_count = From_text(l_line, l_words);
    if (l_count < 2) continue;
    Get_item(l_words, 1, l_key);
    if (l_key == l_tag) {
      if (net_word_integer(l_words, 2) != NET_PROTOCOL) p_problem = "the host is running a different version of the game";
    }
    if (l_key == "session") Get_item(l_words, 2, p_session);
    if (l_key == "host"   ) Get_item(l_words, 2, p_host_id);
    if (l_key == "seed"   ) p_seed = net_word_integer(l_words, 2);
    if (l_key == "world"  ) p_world_name = net_rest_of_line(l_line);
  }
  File_close(l_file);
  if (p_problem != "") return FAILURE;
  if (p_session == "") {
    p_problem = "the session file in " + p_folder + " is damaged";
    return FAILURE;
  }
  if (!File_exists(net_snapshot_path(p_folder, p_session))) {
    p_problem = "the host's world isn't in " + p_folder;
    return FAILURE;
  }
  return SUCCESS;
}

void net_start(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Integer p_mode, Text p_folder,
               Text p_session, Text p_host_id, Text p_id, Text p_name, Real p_now)
// ----------------------------------------------------------------
// Start playing in a session as host or guest: say who you are in
// your own log; other players are found by the next scan
// ----------------------------------------------------------------
{
  net_clear(p_net, p_peers, p_inbox);
  record_set_integer(p_net, ATTR_NET_MODE,          p_mode);
  record_set_text   (p_net, ATTR_NET_FOLDER,        p_folder);
  record_set_text   (p_net, ATTR_NET_SESSION,       p_session);
  record_set_text   (p_net, ATTR_NET_ID,            p_id);
  record_set_text   (p_net, ATTR_NET_HOST_FILE,     net_log_name(p_session, p_host_id));
  record_set_text   (p_net, ATTR_NET_NAME,          p_name);
  record_set_real   (p_net, ATTR_NET_NEXT_POLL,     p_now);
  record_set_real   (p_net, ATTR_NET_NEXT_SCAN,     p_now);
  record_set_real   (p_net, ATTR_NET_NEXT_POSITION, p_now);
  record_set_real   (p_net, ATTR_NET_NEXT_BEAT,     p_now);
  record_set_real   (p_net, ATTR_NET_NEXT_TIME,     p_now);
  record_set_real   (p_net, ATTR_NET_SENT_X,        -1000.0);
  net_queue(p_net, "J " + p_name);
  net_flush(p_net);
}

// ---------------------------------------------------------------- writing

void net_queue(Attributes &p_net, Text p_line)
// ----------------------------------------------------------------
// Add a line to send with the next net_flush
// ----------------------------------------------------------------
{
  Integer l_count = record_integer(p_net, ATTR_NET_OUT_COUNT) + 1;
  Text    l_end   = NET_LINE_END;

  if (net_mode(p_net) == NET_OFF) return;
  record_set_text_at(p_net, ATTR_NET_OUT, l_count, p_line + " " + l_end);
  record_set_integer(p_net, ATTR_NET_OUT_COUNT, l_count);
}

Integer net_flush(Attributes &p_net)
// ----------------------------------------------------------------
// Append the queued lines to your log (opened and closed each time,
// so other players can read it in between). Returns how many lines
// were written; if the log can't be opened they stay queued and
// ATTR_NET_PROBLEM says so.
// ----------------------------------------------------------------
{
  File    l_file;
  Integer l_count = record_integer(p_net, ATTR_NET_OUT_COUNT);
  Integer l_line  = 0;
  Text    l_path  = record_text(p_net, ATTR_NET_FOLDER) + "\\" +
                    net_log_name(record_text(p_net, ATTR_NET_SESSION), record_text(p_net, ATTR_NET_ID));

  if (net_mode(p_net) == NET_OFF || l_count == 0) return 0;
  if (safe_file_open(l_path, "a", l_file) != 0) {
    record_set_text(p_net, ATTR_NET_PROBLEM, "can't write " + l_path);
    return 0;
  }
  for (l_line = 1; l_line <= l_count; ++l_line) File_write_line(l_file, record_text_at(p_net, ATTR_NET_OUT, l_line));
  File_flush(l_file);
  File_close(l_file);
  record_set_integer(p_net, ATTR_NET_OUT_COUNT, 0);
  record_set_text   (p_net, ATTR_NET_PROBLEM,   "");
  return l_count;
}

void net_leave(Attributes &p_net)
// ----------------------------------------------------------------
// Say goodbye and stop
// ----------------------------------------------------------------
{
  if (net_mode(p_net) == NET_OFF) return;
  net_queue(p_net, "L");
  net_flush(p_net);
  record_set_integer(p_net, ATTR_NET_MODE, NET_OFF);
}

void net_say(Attributes &p_net, Text p_text)
// ----------------------------------------------------------------
// Send a chat line to everyone
// ----------------------------------------------------------------
{
  net_queue(p_net, "C " + p_text);
}

void net_send_state(Attributes &p_net, Attributes &p_player, Attributes &p_info, Real p_now)
// ----------------------------------------------------------------
// Queue where you are when it has changed (at most every
// NET_POSITION_SECONDS), a heartbeat when it hasn't, and the host's
// time of day now and then
// ----------------------------------------------------------------
{
  Real l_x     = 0.0;
  Real l_y     = 0.0;
  Real l_z     = 0.0;
  Real l_yaw   = 0.0;
  Real l_pitch = 0.0;
  Real l_moved = 0.0;

  if (net_mode(p_net) == NET_OFF) return;

  if (p_now >= record_real(p_net, ATTR_NET_NEXT_POSITION)) {
    record_set_real(p_net, ATTR_NET_NEXT_POSITION, p_now + NET_POSITION_SECONDS);
    player_position(p_player, l_x, l_y, l_z);
    player_look    (p_player, l_yaw, l_pitch);
    l_moved = Absolute(l_x - record_real(p_net, ATTR_NET_SENT_X)) + Absolute(l_y - record_real(p_net, ATTR_NET_SENT_Y))
            + Absolute(l_z - record_real(p_net, ATTR_NET_SENT_Z)) + Absolute(l_yaw - record_real(p_net, ATTR_NET_SENT_YAW))
            + Absolute(l_pitch - record_real(p_net, ATTR_NET_SENT_PITCH));
    if (l_moved > 0.01) {
      net_queue(p_net, "P " + To_text(l_x, 2) + " " + To_text(l_y, 2) + " " + To_text(l_z, 2) + " " +
                       To_text(l_yaw, 3) + " " + To_text(l_pitch, 3));
      record_set_real(p_net, ATTR_NET_SENT_X,     l_x);
      record_set_real(p_net, ATTR_NET_SENT_Y,     l_y);
      record_set_real(p_net, ATTR_NET_SENT_Z,     l_z);
      record_set_real(p_net, ATTR_NET_SENT_YAW,   l_yaw);
      record_set_real(p_net, ATTR_NET_SENT_PITCH, l_pitch);
      record_set_real(p_net, ATTR_NET_NEXT_BEAT,  p_now + NET_BEAT_SECONDS);
    }
  }
  if (p_now >= record_real(p_net, ATTR_NET_NEXT_BEAT)) {
    record_set_real(p_net, ATTR_NET_NEXT_BEAT, p_now + NET_BEAT_SECONDS);
    net_queue(p_net, "H");
  }
  if (net_mode(p_net) == NET_HOST && p_now >= record_real(p_net, ATTR_NET_NEXT_TIME)) {
    record_set_real(p_net, ATTR_NET_NEXT_TIME, p_now + NET_TIME_SECONDS);
    net_queue(p_net, "T " + To_text(world_time_of_day(p_info), 5));
  }
}

void net_on_event(Attributes &p_event, Attributes &p_net)
// ----------------------------------------------------------------
// Event handler: tell the others about every block you change (its
// final state); changes that came from them aren't sent back
// ----------------------------------------------------------------
{
  Integer l_type = event_type(p_event);
  Integer l_x    = event_integer(p_event, 1);
  Integer l_y    = event_integer(p_event, 2);
  Integer l_z    = event_integer(p_event, 3);

  if (net_mode(p_net) == NET_OFF) return;
  if (l_type != EVT_BLOCK_BROKEN && l_type != EVT_BLOCK_PLACED) return;
  if (event_is_remote(p_event)) return;
  net_queue(p_net, "B " + To_text(l_x) + " " + To_text(l_y) + " " + To_text(l_z) + " " + To_text(world_get_block(l_x, l_y, l_z)));
}

// ---------------------------------------------------------------- reading

Integer net_find_peer(Attributes &p_peers, Text p_file)
// ----------------------------------------------------------------
// The player whose log is p_file, 0 if not known yet
// ----------------------------------------------------------------
{
  Integer l_peer = 0;

  for (l_peer = 1; l_peer <= peers_count(p_peers); ++l_peer) {
    if (record_text_at(p_peers, ATTR_PEER_FILE, l_peer) == p_file) return l_peer;
  }
  return 0;
}

Integer net_add_peer(Attributes &p_peers, Text p_file, Real p_now)
// ----------------------------------------------------------------
// Start following a newly found log; returns its number (0 if
// there are MAX_PEERS already). It isn't shown until it says
// something.
// ----------------------------------------------------------------
{
  Integer l_peer = peers_count(p_peers) + 1;

  if (l_peer > MAX_PEERS) return 0;
  record_set_integer   (p_peers, ATTR_PEER_COUNT, l_peer);
  record_set_text_at   (p_peers, ATTR_PEER_FILE,   l_peer, p_file);
  record_set_text_at   (p_peers, ATTR_PEER_NAME,   l_peer, "player");
  record_set_integer_at(p_peers, ATTR_PEER_OFFSET, l_peer, 0);
  record_set_integer_at(p_peers, ATTR_PEER_HERE,   l_peer, FALSE);
  record_set_real_at   (p_peers, ATTR_PEER_SEEN,   l_peer, p_now);
  record_set_real_at   (p_peers, ATTR_PEER_GOAL_X, l_peer, 0.0);
  record_set_real_at   (p_peers, ATTR_PEER_GOAL_Y, l_peer, -100.0);
  record_set_real_at   (p_peers, ATTR_PEER_GOAL_Z, l_peer, 0.0);
  record_set_real_at   (p_peers, ATTR_X,           l_peer, 0.0);
  record_set_real_at   (p_peers, ATTR_Y,           l_peer, -100.0);
  record_set_real_at   (p_peers, ATTR_Z,           l_peer, 0.0);
  record_set_real_at   (p_peers, ATTR_YAW,         l_peer, 0.0);
  record_set_real_at   (p_peers, ATTR_PITCH,       l_peer, 0.0);
  record_set_real_at   (p_peers, ATTR_PEER_STEP,   l_peer, 0.0);
  return l_peer;
}

void net_scan(Attributes &p_net, Attributes &p_peers, Real p_now)
// ----------------------------------------------------------------
// Look in the folder for logs of this session that aren't followed
// yet (players who joined since the last look)
// ----------------------------------------------------------------
{
  Dynamic_Text l_files;
  Integer      l_count  = 0;
  Integer      l_file   = 0;
  Text         l_path   = "";
  Text         l_name   = "";
  Text         l_prefix = "log_" + record_text(p_net, ATTR_NET_SESSION) + "_";
  Text         l_mine   = net_log_name(record_text(p_net, ATTR_NET_SESSION), record_text(p_net, ATTR_NET_ID));

  if (List_files_in_folder(record_text(p_net, ATTR_NET_FOLDER), "*.txt", l_count, l_files) != 0) return;
  for (l_file = 1; l_file <= l_count; ++l_file) {
    Get_item(l_files, l_file, l_path);
    l_name = file_title_from_path(l_path) + ".txt";
    if (l_name == l_mine) continue;
    if (Text_length(l_name) <= Text_length(l_prefix)) continue;
    if (Get_subtext(l_name, 1, Text_length(l_prefix)) != l_prefix) continue;
    if (net_find_peer(p_peers, l_name) > 0) continue;
    net_add_peer(p_peers, l_name, p_now);
  }
}

void net_inbox_add(Attributes &p_inbox, Integer p_peer, Text p_line)
// ----------------------------------------------------------------
// Keep a line read from a player's log for net_apply
// ----------------------------------------------------------------
{
  Integer l_count = record_integer(p_inbox, ATTR_INBOX_COUNT) + 1;

  record_set_integer   (p_inbox, ATTR_INBOX_COUNT, l_count);
  record_set_text_at   (p_inbox, ATTR_INBOX_LINE,  l_count, p_line);
  record_set_integer_at(p_inbox, ATTR_INBOX_PEER,  l_count, p_peer);
}

Integer net_read_peer(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Integer p_peer)
// ----------------------------------------------------------------
// Read the complete new lines of one player's log into the inbox,
// from where the last read stopped. Returns how many were read.
// ----------------------------------------------------------------
{
  File    l_file;
  Text    l_line   = "";
  Text    l_end    = NET_LINE_END;
  Integer l_offset = record_integer_at(p_peers, ATTR_PEER_OFFSET, p_peer);
  Integer l_where  = 0;
  Integer l_lines  = 0;
  Integer l_length = 0;
  Text    l_path   = record_text(p_net, ATTR_NET_FOLDER) + "\\" + record_text_at(p_peers, ATTR_PEER_FILE, p_peer);

  if (safe_file_open(l_path, "r", l_file) != 0) return 0;
  if (l_offset > 0) File_seek(l_file, l_offset);
  while (l_lines < NET_MAX_LINES_PER_POLL) {
    if (File_read_line(l_file, l_line) != 0) break;
    l_length = Text_length(l_line);
    // only part of the line written so far: read it again next time
    if (l_length < 1) break;
    if (Get_subtext(l_line, l_length, l_length) != l_end) break;
    File_tell(l_file, l_where);
    l_offset = l_where;
    net_inbox_add(p_inbox, p_peer, Text_justify(Get_subtext(l_line, 1, l_length - 1)));
    ++l_lines;
  }
  File_close(l_file);
  record_set_integer_at(p_peers, ATTR_PEER_OFFSET, p_peer, l_offset);
  return l_lines;
}

void net_poll(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Real p_now)
// ----------------------------------------------------------------
// Controller: now and then look for new players and read what every
// player has written since the last time
// ----------------------------------------------------------------
{
  Integer l_peer = 0;

  if (net_mode(p_net) == NET_OFF) return;
  if (p_now < record_real(p_net, ATTR_NET_NEXT_POLL)) return;
  record_set_real(p_net, ATTR_NET_NEXT_POLL, p_now + NET_POLL_SECONDS);

  if (p_now >= record_real(p_net, ATTR_NET_NEXT_SCAN)) {
    record_set_real(p_net, ATTR_NET_NEXT_SCAN, p_now + NET_SCAN_SECONDS);
    net_scan(p_net, p_peers, p_now);
  }
  for (l_peer = 1; l_peer <= peers_count(p_peers); ++l_peer) net_read_peer(p_net, p_peers, p_inbox, l_peer);
}

// ---------------------------------------------------------------- applying what was read

Real net_word_real(Dynamic_Text &p_words, Integer p_position)
// ----------------------------------------------------------------
// Word number position of a split line as a Real (0 if bad)
// ----------------------------------------------------------------
{
  Text l_word  = "";
  Real l_value = 0.0;

  Get_item(p_words, p_position, l_word);
  if (Get_subtext(l_word, 1, 1) == "-") {
    if (From_text(Get_subtext(l_word, 2, Text_length(l_word)), l_value) != 0) return 0.0;
    return -l_value;
  }
  if (From_text(l_word, l_value) != 0) return 0.0;
  return l_value;
}

Integer net_word_integer(Dynamic_Text &p_words, Integer p_position)
// ----------------------------------------------------------------
// Word number position of a split line as an Integer (0 if bad)
// ----------------------------------------------------------------
{
  Text    l_word  = "";
  Integer l_value = 0;

  Get_item(p_words, p_position, l_word);
  if (Get_subtext(l_word, 1, 1) == "-") {
    if (From_text(Get_subtext(l_word, 2, Text_length(l_word)), l_value) != 0) return 0;
    return -l_value;
  }
  if (From_text(l_word, l_value) != 0) return 0;
  return l_value;
}

Text net_rest_of_line(Text p_line)
// ----------------------------------------------------------------
// Everything after the first word and its space ("C hello there"
// gives "hello there")
// ----------------------------------------------------------------
{
  Integer l_space = Find_text(p_line, " ");

  if (l_space < 1) return "";
  return Get_subtext(p_line, l_space + 1, Text_length(p_line));
}

void net_apply_line(Attributes &p_net, Attributes &p_peers, Integer p_peer, Text p_line, Attributes &p_info,
                    Attributes &p_hud, Attributes &p_events, Real p_now)
// ----------------------------------------------------------------
// Act on one line from a player's log
// ----------------------------------------------------------------
{
  Dynamic_Text l_words;
  Integer      l_count = From_text(p_line, l_words);
  Text         l_tag   = "";
  Text         l_name  = peer_name(p_peers, p_peer);

  if (l_count < 1) return;
  Get_item(l_words, 1, l_tag);
  record_set_real_at(p_peers, ATTR_PEER_SEEN, p_peer, p_now);

  // anything but a goodbye means they are (still) here
  if (l_tag != "L" && !peer_here(p_peers, p_peer)) {
    record_set_integer_at(p_peers, ATTR_PEER_HERE, p_peer, TRUE);
    if (l_tag != "J") hud_toast(p_hud, l_name + " is here", p_now);
  }

  if (l_tag == "J") {
    l_name = net_clean_name(net_rest_of_line(p_line));
    record_set_text_at(p_peers, ATTR_PEER_NAME, p_peer, l_name);
    hud_chat(p_hud, l_name + " joined the game", p_now);
  } else if (l_tag == "L") {
    if (peer_here(p_peers, p_peer)) hud_chat(p_hud, l_name + " left the game", p_now);
    record_set_integer_at(p_peers, ATTR_PEER_HERE, p_peer, FALSE);
  } else if (l_tag == "P" && l_count >= 6) {
    record_set_real_at(p_peers, ATTR_PEER_GOAL_X, p_peer, net_word_real(l_words, 2));
    record_set_real_at(p_peers, ATTR_PEER_GOAL_Y, p_peer, net_word_real(l_words, 3));
    record_set_real_at(p_peers, ATTR_PEER_GOAL_Z, p_peer, net_word_real(l_words, 4));
    record_set_real_at(p_peers, ATTR_YAW,         p_peer, net_word_real(l_words, 5));
    record_set_real_at(p_peers, ATTR_PITCH,       p_peer, net_word_real(l_words, 6));
    // first sighting: appear there rather than glide in from afar
    if (record_real_at(p_peers, ATTR_Y, p_peer) < -50.0) {
      record_set_real_at(p_peers, ATTR_X, p_peer, net_word_real(l_words, 2));
      record_set_real_at(p_peers, ATTR_Y, p_peer, net_word_real(l_words, 3));
      record_set_real_at(p_peers, ATTR_Z, p_peer, net_word_real(l_words, 4));
    }
  } else if (l_tag == "B" && l_count >= 5) {
    world_apply_remote_block(p_events, net_word_integer(l_words, 2), net_word_integer(l_words, 3),
                             net_word_integer(l_words, 4), net_word_integer(l_words, 5));
  } else if (l_tag == "C") {
    hud_chat(p_hud, "<" + l_name + "> " + net_rest_of_line(p_line), p_now);
  } else if (l_tag == "T" && l_count >= 2) {
    // only the host's clock counts
    if (record_text_at(p_peers, ATTR_PEER_FILE, p_peer) == record_text(p_net, ATTR_NET_HOST_FILE)) {
      world_set_time_of_day(p_info, net_word_real(l_words, 2));
    }
  }
}

void net_apply(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Attributes &p_info,
               Attributes &p_hud, Attributes &p_events, Real p_dt, Real p_now)
// ----------------------------------------------------------------
// Act on every line read since the last frame, move the drawn
// players towards where they last said they were, and let go of
// players who have gone quiet
// ----------------------------------------------------------------
{
  Integer l_line  = 0;
  Integer l_peer  = 0;
  Real    l_ease  = min_real(1.0, p_dt * NET_SMOOTHING);
  Real    l_dx    = 0.0;
  Real    l_dz    = 0.0;
  Real    l_x     = 0.0;
  Real    l_y     = 0.0;
  Real    l_z     = 0.0;

  for (l_line = 1; l_line <= record_integer(p_inbox, ATTR_INBOX_COUNT); ++l_line) {
    net_apply_line(p_net, p_peers, record_integer_at(p_inbox, ATTR_INBOX_PEER, l_line),
                   record_text_at(p_inbox, ATTR_INBOX_LINE, l_line), p_info, p_hud, p_events, p_now);
  }
  record_clear      (p_inbox, DATATYPE_NET_INBOX);
  record_set_integer(p_inbox, ATTR_INBOX_COUNT, 0);

  for (l_peer = 1; l_peer <= peers_count(p_peers); ++l_peer) {
    if (!peer_here(p_peers, l_peer)) continue;
    if (p_now - record_real_at(p_peers, ATTR_PEER_SEEN, l_peer) > NET_GONE_SECONDS) {
      record_set_integer_at(p_peers, ATTR_PEER_HERE, l_peer, FALSE);
      hud_chat(p_hud, peer_name(p_peers, l_peer) + " went quiet for a minute and was dropped", p_now);
      continue;
    }
    peer_position(p_peers, l_peer, l_x, l_y, l_z);
    l_dx = (record_real_at(p_peers, ATTR_PEER_GOAL_X, l_peer) - l_x) * l_ease;
    l_dz = (record_real_at(p_peers, ATTR_PEER_GOAL_Z, l_peer) - l_z) * l_ease;
    record_set_real_at(p_peers, ATTR_X, l_peer, l_x + l_dx);
    record_set_real_at(p_peers, ATTR_Y, l_peer, l_y + (record_real_at(p_peers, ATTR_PEER_GOAL_Y, l_peer) - l_y) * l_ease);
    record_set_real_at(p_peers, ATTR_Z, l_peer, l_z + l_dz);
    // legs swing as far as they walked
    record_set_real_at(p_peers, ATTR_PEER_STEP, l_peer, peer_step(p_peers, l_peer) + Sqrt(l_dx * l_dx + l_dz * l_dz) * 3.0);
  }
}

// ---------------------------------------------------------------- the other players

Integer peers_count(Attributes &p_peers)
// ----------------------------------------------------------------
// How many players' logs are followed (here or not)
// ----------------------------------------------------------------
{
  return record_integer(p_peers, ATTR_PEER_COUNT);
}

Integer peer_here(Attributes &p_peers, Integer p_peer)
// ----------------------------------------------------------------
// TRUE while a player is in the game (drawn and listed)
// ----------------------------------------------------------------
{
  return record_integer_at(p_peers, ATTR_PEER_HERE, p_peer) == TRUE;
}

Text peer_name(Attributes &p_peers, Integer p_peer)
// ----------------------------------------------------------------
// The name a player joined with
// ----------------------------------------------------------------
{
  return record_text_at(p_peers, ATTR_PEER_NAME, p_peer);
}

void peer_position(Attributes &p_peers, Integer p_peer, Real &p_x, Real &p_y, Real &p_z)
// ----------------------------------------------------------------
// Where a player is drawn (feet)
// ----------------------------------------------------------------
{
  p_x = record_real_at(p_peers, ATTR_X, p_peer);
  p_y = record_real_at(p_peers, ATTR_Y, p_peer);
  p_z = record_real_at(p_peers, ATTR_Z, p_peer);
}

Real peer_yaw(Attributes &p_peers, Integer p_peer)
// ----------------------------------------------------------------
// Which way a player faces
// ----------------------------------------------------------------
{
  return record_real_at(p_peers, ATTR_YAW, p_peer);
}

Real peer_pitch(Attributes &p_peers, Integer p_peer)
// ----------------------------------------------------------------
// How far up or down a player looks
// ----------------------------------------------------------------
{
  return record_real_at(p_peers, ATTR_PITCH, p_peer);
}

Real peer_step(Attributes &p_peers, Integer p_peer)
// ----------------------------------------------------------------
// A player's walk cycle (radians)
// ----------------------------------------------------------------
{
  return record_real_at(p_peers, ATTR_PEER_STEP, p_peer);
}

Text net_players_text(Attributes &p_net, Attributes &p_peers, Real p_now)
// ----------------------------------------------------------------
// "hosting: you, Sam, Alex (away)" for the status line, "" when not
// in a multiplayer game. A player who has said nothing for a few
// seconds is most likely paused (a game only sends while its view
// runs).
// ----------------------------------------------------------------
{
  Text    l_text = "";
  Integer l_peer = 0;

  if (net_mode(p_net) == NET_OFF) return "";
  l_text = "joined: ";
  if (net_mode(p_net) == NET_HOST) l_text = "hosting: ";
  l_text = l_text + record_text(p_net, ATTR_NET_NAME);
  for (l_peer = 1; l_peer <= peers_count(p_peers); ++l_peer) {
    if (!peer_here(p_peers, l_peer)) continue;
    l_text = l_text + ", " + peer_name(p_peers, l_peer);
    if (p_now - record_real_at(p_peers, ATTR_PEER_SEEN, l_peer) > NET_AWAY_SECONDS) l_text = l_text + " (away)";
  }
  if (record_text(p_net, ATTR_NET_PROBLEM) != "") l_text = l_text + " (" + record_text(p_net, ATTR_NET_PROBLEM) + ")";
  return l_text;
}

#endif
