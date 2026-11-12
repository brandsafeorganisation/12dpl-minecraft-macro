# Multiplayer plan

A plan only: nothing here is built yet. It was put together by reading the
code and every entry of `resources/12dpl_functions_documentation.json`.

## 1. What 12dPL offers for talking to another copy of the game

| Option | Calls | Usable? |
|--------|-------|---------|
| Sockets, TCP/UDP, HTTP, named pipes | none exist | no |
| Start a helper program (a relay with real sockets) | `Create_process`, `Shell_execute`, `Process_exists` | blocked in `include/core/safety.h` |
| ODBC database | `Create_ODBC_connection`, `Connect`, `Execute` | `Connect` and `Execute` blocked; needs a database server |
| Synergy (12d's server) | `Synergy_connect`, `Synergy_check_out`, `Synergy_get` | blocked; check-in/check-out takes seconds to minutes |
| 12d project sharing | `Share_out_model`, `Share_in_model`, `Synchronize_shared_in_model` | changes the project and needs a save; far too slow |
| Clipboard | `Get_clipboard_text`, `Set_clipboard_text` | blocked, and one machine only |
| Files | `File_open` (r, a, a+, w), `File_read_line`, `File_write_line`, `File_flush`, `File_tell`, `File_seek`, `Find_files`, `Get_file_size`, `Get_file_modified_time_utc`, `Directory_create`, `Sleep` | **yes**, through `safe_file_open` |

**The only usable transport is a shared folder of append-only text files that
each copy of the game polls.**

## 2. Design

**Files.** A session lives in `cubeland_worlds\mp\<session>\`:

- `session.txt` holds the protocol version, seed, world name and host id.
- `snapshot.txt` is the host's world, written by `save_world`, edit list included.
- `log_<peer>.txt` is one append-only file per player. Each file has exactly one
  writer, so nothing needs locking and nothing is ever deleted.

**Reading.** Each reader keeps a byte offset per log and seeks to it on every
poll. Every line ends with `~`. A line that arrives without it (half written)
is read again on the next poll.

**Messages.** One line each, `<seq> <tag> ...`:

- `P t x y z yaw pitch held`: position and look
- `B index block`: a cell's final state
- `C text`: chat
- `T time_of_day`
- `M slot kind x y z yaw flash`: a mob (host only)
- `H`: heartbeat
- `J` / `L`: join / leave
- `D peer damage`: a host zombie hit a guest

**Who decides what:**

- Each player owns their own position and inventory.
- The host decides mobs, the time of day and the order of block edits.
- Guests apply their own edits straight away. The host re-sends every edit in
  its log, and guests follow that stream, so if two players change the same
  cell, the host's order wins.
- Edits are sent as final cell states, not as break/place actions. Water flowing
  in or a plant dropping then stays identical on every machine without
  re-running that logic.

**How often:**

- Positions are written every 200 ms, and only when they change.
- Logs are polled every 200 ms.
- Block edits are written and flushed at once.
- Mobs are sent every 500 ms, the time of day every 5 s and a heartbeat every 1 s.
- Remote players and mobs move smoothly between samples (interpolation).

Expect almost no delay on a local disk. Over a network share, expect about 100 ms
to several seconds. Windows caches file and folder information for up to about
10 s, so read from the saved offset rather than polling `Get_file_size`.

**Joining.** A guest:

1. reads `session.txt`;
2. generates the world from the seed;
3. applies `snapshot.txt`;
4. carries on reading the host's log from the offset stored in the snapshot.

**Leaving.** A player counts as gone after 10 s with no new lines, timed on the
reader's own clock. `L` marks a clean leave. If the host disappears, guests
carry on alone and save a local copy.

**Known limit.** The game only runs frames while the mouse is captured. 12dPL
has no timer and no way to check for input without waiting. So a paused player
stops sending and catches up from the log when they carry on. A paused host
freezes the mobs for everyone.

## 3. How it fits the code

**New files** (a new `net` part, which needs the owner's OK):

- `src/net/net.4dm` with `include/net/net.h`: transport, session and protocol.
- `src/net/peers.4dm`: the remote players, as one record with numbered fields.

**New globals** in `include/program/game.h`: `g_net`, `g_peers` and `g_net_inbox`.

**Keeping functions honest:**

- The controller (`game_panel.4dm`) calls `net_poll(g_net, g_net_inbox, now)`
  and `net_flush(g_net, now)`.
- `game_update` turns inbox lines into events with
  `net_apply(p_inbox, ..., p_events)`, so the harness can test it by putting
  lines straight into the inbox.
- The open files are a table owned by `net.4dm`.

**New events:** `EVT_NET_BLOCK_SET`, `EVT_PEER_JOINED`, `EVT_PEER_LEFT` and `EVT_CHAT`.

**Block edits:**

- `mesh_on_event`, `save_on_event`, `chest_on_event` and `furnace_on_event` each
  handle `EVT_NET_BLOCK_SET`.
- `world_apply_remote_block` sets the cell, the column top and the light.
- `net_on_event` turns `EVT_BLOCK_BROKEN` / `EVT_BLOCK_PLACED` into `B` lines,
  but never re-sends `EVT_NET_*` events, so edits don't bounce back.

**Mobs:**

- Guests skip `cows_update` and copy mobs from the host's `M` lines.
- On the host, mobs chase the nearest player. That needs the other players'
  positions passed into `cows.4dm`.

**Screen and menu:**

- `render_collect_peers()` draws remote players with `render_mob_begin`,
  `render_mob_part` and `render_mob_end`.
- The menu gets Host and Join buttons. Chat reuses the T chat line.

## 4. Safety (owner decisions)

**On one machine** nothing changes: both copies write inside
`SAFE_WRITE_FOLDER` through `safe_file_open`.

**Across machines**, the folder has to reach a network share. The options:

- **(a)** A Windows link to the share inside `cubeland_worlds\`. No code change,
  but writes then leave the folder through the operating system. *Decide:
  document it or forbid it.*
- **(b)** Let `safe_path_is_writable` accept one more root, `SAFE_SHARE_FOLDER`,
  a network path from the settings. Limits:
  - the path must end in `\cubeland_mp`;
  - only fixed file name patterns may be written;
  - `..` is still forbidden.

  *Decide: this loosens safety, and editing the settings file would change where
  the game writes.*
- **(c)** Not recommended: unblock `Create_process` or `Connect` / `Execute`.

Session folders pile up, because nothing is deleted. Old ones are overwritten
with a marker, as `save_delete_world` does.

## 5. Phases

| Phase | What | Rough size |
|-------|------|------------|
| 0 | Throwaway test inside real 12d (below) | ~150 lines |
| 1 | Transport, session files, Host/Join menu | ~450 |
| 2 | Positions, remote players drawn | ~300 |
| 3 | Block sync, joining from the snapshot, `EVT_NET_BLOCK_SET` handlers | ~350 |
| 4 | Chat, time of day, heartbeat and leaving | ~250 |
| 5 | Host-run mobs, guests hitting mobs, zombies chasing other players | ~400 |
| 6 | (optional) Shared drops, chests and furnaces | ~300 |

**Phase 0 checks**, with two sessions on one PC and then two PCs over a share:

- how quickly an append plus `File_flush` shows up on the other side;
- whether a file can be read while another session has it open for appending;
- whether `File_tell` / `File_seek` work on a growing file;
- how out of date `Find_files` is;
- what opening a file costs per frame;
- whether ANSI text files behave.

**Risks:**

- network share caching;
- file sharing modes;
- the cost of file reading and writing per frame;
- the paused-host freeze;
- `Get_host_id` returns the licence dongle number, which may be the same on both
  PCs, so player ids should come from `Get_user_name` plus the time.

**Test tools:**

- The harness would need stand-ins for `Find_files`, `File_flush`,
  `Get_file_modified_time_utc` and `Sleep`, plus scenario hooks that put lines
  straight into the inbox.
- The desktop build needs the same calls (`FindFirstFile`, `fflush`) and would
  then work over a real share.
