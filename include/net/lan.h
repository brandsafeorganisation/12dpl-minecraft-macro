#ifndef LAN_H_INCLUDED
#define LAN_H_INCLUDED

// ----------------------------------------------------------------
// The LAN helper: real network play without a shared folder.
//
// 12dPL can't open sockets, so a small Windows PowerShell script
// (src/net/lan_helper.ps1, kept in the macro by safety.h and started
// only through safe_run_helper) carries the multiplayer files over the
// network. net.4dm doesn't know: it reads and writes its folder as if
// it were a shared one, and the helper fills it.
//
//   cubeland_worlds\lan\s_<run>\      a Play Multiplayer scan: lan_<session>.txt
//                                     for each world heard (with address, port)
//   cubeland_worlds\lan\h_<session>\  a host's session, snapshot and logs
//   cubeland_worlds\lan\j_<run>\      a guest's copy of them
//
// Each folder also holds control_<run>.txt (the game to the helper:
// "run ~" or "stop ~") and status_<run>.txt (the helper to the game:
// "<state> <detail> ~", states starting, scanning, hosting <port>,
// connecting, downloading, ready <lines>, failed <why>, lost ...,
// closed ..., stopped).
//
// A running helper is a record (DATATYPE_LAN_RUN) the controller keeps.
// ----------------------------------------------------------------

#define LAN_FOLDER            "cubeland_worlds\\lan"
#define LAN_DISCOVERY_PORT    24460
#define LAN_GAME_PORT         24461
#define LAN_START_SECONDS     10.0    // no status by then: PowerShell didn't start
#define LAN_CONNECT_SECONDS   30.0    // joining gives up after this long
#define LAN_HOST_WAIT_SECONDS 5.0     // hosting waits this long for the helper to listen
#define LAN_CHECK_SECONDS     1.0     // read a running helper's status this often

#define DATATYPE_LAN_RUN      ("lan_run")
#define ATTR_LANR_ACTIVE      ("active")    // TRUE while a helper should be running
#define ATTR_LANR_FOLDER      ("folder")    // its folder
#define ATTR_LANR_RUN         ("run")       // its run name (control_/status_ files)
#define ATTR_LANR_MODE        ("mode")      // scan, host or join
#define ATTR_LANR_STARTED     ("started")   // when it was started
#define ATTR_LANR_NEXT_CHECK  ("next_check")
#define ATTR_LANR_STATE       ("state")     // the last status read
#define ATTR_LANR_DETAIL      ("detail")
#define ATTR_LANR_TOLD        ("told")      // TRUE once a problem was told

// Functions
Text    lan_run_name         (Real p_now);
Text    lan_word             (Text p_text);
Text    lan_folder           (Text p_dir);
Text    lan_scan_dir         (Text p_run);
Text    lan_host_dir         (Text p_session);
Text    lan_join_dir         (Text p_run);
Integer lan_write_control    (Text p_folder, Text p_run, Text p_word);
Integer lan_read_status      (Text p_folder, Text p_run, Text &p_state, Text &p_detail);
Text    lan_status_problem   (Text p_state, Text p_detail);
void    lan_run_clear        (Attributes &p_run);
Integer lan_run_start        (Attributes &p_run, Text p_system_root, Text p_mode, Text p_dir, Text p_run_name, Text p_session,
                              Text p_id, Text p_address, Integer p_port, Real p_now);
void    lan_run_stop         (Attributes &p_run);
Integer lan_run_active       (Attributes &p_run);
Text    lan_run_folder       (Attributes &p_run);
Text    lan_run_state        (Attributes &p_run);
Text    lan_run_check        (Attributes &p_run, Real p_now);

#endif
