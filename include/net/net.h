#ifndef NET_H_INCLUDED
#define NET_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// Multiplayer through a shared folder (12dPL has no sockets, so files
// are the only way two copies of the game can talk)
//
// A session lives in the multiplayer folder (settings, "cubeland_worlds\mp"
// by default, or a network folder named cubeland_mp):
//
//   session.txt                 the host's current session: id, host, seed, world
//   snapshot_<session>.txt      the host's world when it started hosting
//   log_<session>_<player>.txt  one per player, only ever appended to by
//                               that player, so nothing needs locking
//
// Every line of a log ends in NET_LINE_END; a line without it is still
// being written and is read again next time. Each reader remembers how
// far it has read every log (a byte offset) and only reads what is new.
//
// Lines (one message each):
//   J <name>                 joined
//   L                        left
//   P x y z yaw pitch        where the player is and where they look
//   H                        still here (when not moving)
//   B x y z block            a cell's new block (final state, so water
//                            filling in or a door's other half arrive as
//                            their own lines)
//   C <text>                 said in the chat
//   T time                   the host's time of day (0..1)
//
// Who decides: each player their own position, inventory, chests and
// furnaces; every player applies everyone's block lines; the host's
// clock wins. Animals run on each machine separately.
//
// Honest functions: only the controller calls net_poll and net_flush
// (they read and write files); net_apply turns what was read into
// events and chat, so the tests can feed it lines directly.
// ----------------------------------------------------------------

#define NET_OFF                 0
#define NET_HOST                1
#define NET_GUEST               2

#define NET_PROTOCOL            1
#define NET_LINE_END            "~"
#define NET_SESSION_TAG         "cubeland_session"
#define NET_POLL_SECONDS        0.2    // read the other logs this often
#define NET_SCAN_SECONDS        2.0    // look for new players this often
#define NET_POSITION_SECONDS    0.2    // send where you are this often (when moving)
#define NET_BEAT_SECONDS        1.0    // say you're still here this often
#define NET_TIME_SECONDS        5.0    // host: send the time of day this often
#define NET_AWAY_SECONDS        3.0    // nothing heard for this long: listed as away (paused, most likely)
#define NET_GONE_SECONDS        60.0   // nothing heard for this long: gone
#define NET_MAX_LINES_PER_POLL  2000   // a joining player catches up over a few polls
#define NET_SMOOTHING           10.0   // how quickly drawn players catch up with their last position
#define MAX_PEERS               16

#define DATATYPE_NET            ("net")
#define ATTR_NET_MODE           ("mode")
#define ATTR_NET_FOLDER         ("folder")
#define ATTR_NET_SESSION        ("session")
#define ATTR_NET_ID             ("id")
#define ATTR_NET_HOST_FILE      ("host_file")    // the host's log file name
#define ATTR_NET_NAME           ("name")
#define ATTR_NET_OUT_COUNT      ("out_count")
#define ATTR_NET_OUT            ("out")          // queued line n
#define ATTR_NET_NEXT_POLL      ("next_poll")
#define ATTR_NET_NEXT_SCAN      ("next_scan")
#define ATTR_NET_NEXT_POSITION  ("next_position")
#define ATTR_NET_NEXT_BEAT      ("next_beat")
#define ATTR_NET_NEXT_TIME      ("next_time")
#define ATTR_NET_SENT_X         ("sent_x")
#define ATTR_NET_SENT_Y         ("sent_y")
#define ATTR_NET_SENT_Z         ("sent_z")
#define ATTR_NET_SENT_YAW       ("sent_yaw")
#define ATTR_NET_SENT_PITCH     ("sent_pitch")
#define ATTR_NET_PROBLEM        ("problem")      // why the last write failed, "" if it worked

#define DATATYPE_PEERS          ("peers")
#define ATTR_PEER_COUNT         ("count")
#define ATTR_PEER_FILE          ("file")         // the peer's log file name
#define ATTR_PEER_NAME          ("name")
#define ATTR_PEER_OFFSET        ("offset")       // bytes of its log already read
#define ATTR_PEER_HERE          ("here")         // TRUE while playing
#define ATTR_PEER_SEEN          ("seen")         // local time of its last line
#define ATTR_PEER_GOAL_X        ("goal_x")       // last position it sent (ATTR_X.. is where it's drawn)
#define ATTR_PEER_GOAL_Y        ("goal_y")
#define ATTR_PEER_GOAL_Z        ("goal_z")
#define ATTR_PEER_STEP          ("step")         // walk cycle for its legs

#define DATATYPE_NET_INBOX      ("net_inbox")
#define ATTR_INBOX_COUNT        ("count")
#define ATTR_INBOX_LINE         ("line")
#define ATTR_INBOX_PEER         ("peer")

void    net_clear              (Attributes &p_net, Attributes &p_peers, Attributes &p_inbox);
Integer net_mode               (Attributes &p_net);
Text    net_clean_name         (Text p_name);
Text    net_session_path       (Text p_folder);
Text    net_snapshot_path      (Text p_folder, Text p_session);
Text    net_log_name           (Text p_session, Text p_id);
Integer net_ensure_folder      (Text p_folder);
Integer net_write_session      (Text p_folder, Text p_session, Text p_host_id, Integer p_seed, Text p_world_name);
Integer net_read_session       (Text p_folder, Text &p_session, Text &p_host_id, Integer &p_seed, Text &p_world_name, Text &p_problem);
void    net_start              (Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Integer p_mode, Text p_folder,
                                Text p_session, Text p_host_id, Text p_id, Text p_name, Real p_now);
void    net_queue              (Attributes &p_net, Text p_line);
Integer net_flush              (Attributes &p_net);
void    net_leave              (Attributes &p_net);
Integer net_find_peer          (Attributes &p_peers, Text p_file);
Integer net_add_peer           (Attributes &p_peers, Text p_file, Real p_now);
void    net_scan               (Attributes &p_net, Attributes &p_peers, Real p_now);
Integer net_read_peer          (Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Integer p_peer);
void    net_inbox_add          (Attributes &p_inbox, Integer p_peer, Text p_line);
void    net_poll               (Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Real p_now);
Real    net_word_real          (Dynamic_Text &p_words, Integer p_position);
Integer net_word_integer       (Dynamic_Text &p_words, Integer p_position);
Text    net_rest_of_line       (Text p_line);
void    net_apply_line         (Attributes &p_net, Attributes &p_peers, Integer p_peer, Text p_line, Attributes &p_info,
                                Attributes &p_hud, Attributes &p_events, Real p_now);
void    net_apply              (Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Attributes &p_info,
                                Attributes &p_hud, Attributes &p_events, Real p_dt, Real p_now);
void    net_send_state         (Attributes &p_net, Attributes &p_player, Attributes &p_info, Real p_now);
void    net_say                (Attributes &p_net, Text p_text);
void    net_on_event           (Attributes &p_event, Attributes &p_net);
Integer peers_count            (Attributes &p_peers);
Integer peer_here              (Attributes &p_peers, Integer p_peer);
Text    peer_name              (Attributes &p_peers, Integer p_peer);
void    peer_position          (Attributes &p_peers, Integer p_peer, Real &p_x, Real &p_y, Real &p_z);
Real    peer_yaw               (Attributes &p_peers, Integer p_peer);
Real    peer_pitch             (Attributes &p_peers, Integer p_peer);
Real    peer_step              (Attributes &p_peers, Integer p_peer);
Text    net_players_text       (Attributes &p_net, Attributes &p_peers, Real p_now);

#endif
