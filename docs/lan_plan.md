# Cubeland: real LAN play without a shared folder (research plan)

**Implemented** (see README, Multiplayer). Differences from this plan:
the six-argument `Create_process` (no `Process_Handle`; the status file
says whether the helper runs), no modified-time checks (each Play
Multiplayer search has its own folder, and the helper writes a world
`open 0` once it stops answering), the helper finds 12d's process
itself (its parent), and the script lives in
`include/core/safe_lan_script.h`, written from `src/net/lan_helper.ps1`.

The research below was written before any code. Quotes come from
`resources/12dpl_functions_documentation.json` (ids in brackets). Where I
am not sure, it says **UNSURE**.

---

## (a) Verdict

**cmd.exe alone can't do it.** Two PCs can only talk if one of them
accepts connections that it didn't start: a listening socket or a
writable share. The programs that come with Windows and run from cmd
can't provide either one without admin rights or extra setup:

| Route from cmd | What it can do | Why it fails for LAN play |
|---|---|---|
| `curl.exe` (Win10 1803+) | HTTP/FTP/`telnet://` **client** (raw TCP out) | Can't listen, so it needs a server on the other PC, and there is none |
| `ftp.exe`, `tftp` (optional feature, off by default), `telnet` (off by default) | clients only | same: no server comes with Windows |
| `certutil -urlcache`, `bitsadmin`, `ssh.exe` (client) | download / client only | `sshd` is an optional feature that needs admin |
| `net share`, admin shares `\\pc\c$` | make or use an SMB share | `net share` needs elevation. `c$` needs admin credentials on the other PC (plus `LocalAccountTokenFilterPolicy` for local accounts). Guest access is off since Win10 1709. This is just the existing shared-folder mode with extra steps |
| `net view`, `nbtstat -A`, `arp -a`, `ping` | list PCs (partly; `net view` browsing died with SMB1) | Finds PCs but carries no data, and the other side can't see pings without packet capture (`pktmon` needs admin) |
| Mailslots `echo x > \\*\mailslot\cubeland` | broadcast datagram **send** (NetBIOS UDP 138) | Receiving needs `CreateMailslot`, which nothing in cmd can call (and 12dPL's File_open can't create one). Remote mailslots are deprecated and, as I recall, off by default in Windows 11 24H2 (**UNSURE** of the exact build) |
| Named pipes `\\pc\pipe\name` | client open of a pipe | Needs a pipe server; cmd can't create one |
| `netsh interface portproxy`, `netsh http add urlacl` | forward ports | admin, and still needs a listener |
| `msg *` | pop-up text | Not on Home editions, needs AllowRemoteRPC (registry, admin), shows dialogs, not a data channel |
| `cscript`/`wscript`/`mshta` (JScript/VBScript) | COM: `MSXML2.ServerXMLHTTP`, `WinHttp.WinHttpRequest` | **Client only.** No COM object that comes with Windows can listen (`MSWinsock.Winsock` is a VB6 OCX, not part of Windows). VBScript is being removed (feature on demand from 24H2) |
| Internet relay (curl to a paste or push service) | works | Not LAN, a third-party service, privacy. Rejected |

Two edge notes:

- `csc.exe` (`C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe`,
  part of .NET Framework 4.8 in Win10/11) can be run from cmd and could
  compile a small C# listener into `cubeland_worlds`. Strictly, it is a
  "standard executable". But it is .NET sockets, just as PowerShell is,
  and it means **the macro builds and runs a new unsigned .exe**. That is
  worse for safety review and for antivirus. Its only advantage is a
  firewall prompt that names `cubeland_lan.exe` rather than PowerShell.
  This is option B; I don't recommend it.
- The existing shared-folder mode is already the best that "cmd and
  files" can do.

**Fallback chosen: Windows PowerShell 5.1.** It is part of every
Windows 10/11 install, at
`%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe`, and it has
`System.Net.Sockets.UdpClient` / `TcpListener`. A small helper script
bridges the network to **local files**, so `net.4dm`'s log-line protocol
stays almost the same.

---

## (b) 12dPL calls: what exists and what to use

### Starting processes (all blocked in `safety.h` today)

| Call (id) | Signature | Behaviour |
|---|---|---|
| **Create_process** (2635), the one to use | `Integer Create_process(Text program_name, Text command_line, Text start_directory, Integer flags, Integer inherit, Process_Handle &handle)` | "basically calls the Microsoft CreateProcess", passing `flags` as `dwCreationFlags` and `inherit` as `bInheritHandles`. It doesn't wait: "the macro can check with Process_exists". **No STARTUPINFO, so there is no stdout/stdin capture and no wShowWindow.** Returns 0 on success. "Create_process can not be called from 12d Model Practise version." |
| Create_process (1620) | `Integer Create_process(Text program_name, Text command_line, Text start_directory, Integer flags, Integer wait, Integer inherit)` | Same, with `wait = 1` to block. No handle |
| **Process_exists** (2636) | `Integer Process_exists(Process_Handle handle)` | Non-zero while the process is still running. "Warning this is the opposite of most 12dPL function return values" |
| Shell_execute (1623) | `Integer Shell_execute(Widget widget, Text operation, Text file, Text parameters, Text directory, Integer showcmd)` | ShellExecute. Doesn't block; `showcmd` 0 (SW_HIDE) hides the window. No handle (the doc text mentions one, but the signature has none). Usable fallback if Create_process ever misbehaves |
| System (21) | `Integer System(Text msg)` | C `system()`, so `cmd /c`. **Blocks 12d**, a console window flashes (12d is a GUI app), and output is only available through `> file`. Not suitable |
| Create_macro (1627) | runs another macro | not relevant |

**There is no kill or terminate call in the docs.** The helper has to stop
itself (see the stop rules below).

`Process_Handle` (data types doc): "A handle to an external process." It
can't go in an Attributes record, so the controller keeps it as a
variable or a global.

Flags: `CREATE_NO_WINDOW` = 0x08000000 = **134217728** (fits in a signed
32-bit Integer; write it in decimal, since **UNSURE** whether 12dPL takes
hex literals). powershell.exe is a console program, so with
CREATE_NO_WINDOW no console is created at all: **no window flash**, and
Windows Terminal doesn't open either. Use `inherit = 0`.

### Calls for file IPC with the helper (none blocked)

- `File_exists` (202), `Directory_exists` (2468), `Directory_create`
  (2470) through `safe_folder_create`, `File_open` through
  `safe_file_open`, `File_read_line` / `File_write_line` / `File_seek` /
  `File_tell` (already used by `net.4dm`).
- `List_files_in_folder` (7895), and the 11-argument form (8011) that
  also returns `Dynamic_Integer64 &times_modified`.
- `Get_file_modified_time_utc(Text file_name, Integer64 &time)` (3876):
  "seconds elapsed since midnight, January 1st 1970 UTC". Used to tell
  whether a found LAN world is still fresh.
- `Get_file_size(Text, Integer &)` (2407);
  `Touch_file_modified_time(Text path_name)` (7984) (writes a time; if it
  is used it should go through a safe wrapper).
- `Sleep(Integer milli)` (2476), for the "Connecting..." wait loop.
- `Get_time(Real &time)` (661), with 100 ns precision.
- `Getenv(Text env)` (1087): `SystemRoot`, and optionally
  `COMPUTERNAME`.
- `Get_absolute_path(Text path_name)` (7815): "Return the text
  representing the absolute path ... `Get_absolute_path("options_logs/")`
  // usually return the absolute path to options usage folder in the
  working project". CreateProcess needs an **absolute**
  `lpCurrentDirectory`, and this gives it.
- `Get_temporary_project_directory(Text &folder_name)` (2475):
  `"%TEMP%\12d\process-id"`. **The last folder name is 12d.exe's PID**,
  which is passed to the helper so it can exit when 12d exits.
- `Get_user_name` (814) (already used for the player name).
- Clipboard (1521/1522) is blocked and no use (one PC only). The docs
  have **no registry calls**. ODBC (`Create_ODBC_connection` / `Connect`
  / `Execute`) would need a database server. Synergy needs a 12d
  server. Neither is suitable.

---

## (c) The helper script (draft, PowerShell 5.1, also runs on pwsh 7)

Source: `src/net/lan_helper.ps1`. A generator,
`tools/make_lan_helper.py` (modelled on `make_report_page.py`), turns it
into `src/net/lan_helper_script.4dm`, a `File_write_line` per line, with
`\` doubled and `"` escaped as `\"`. The `Create_macro` doc uses `\"`, so
12dPL accepts it. **UNSURE** why `make_report_page.py` says strings
"can't hold a double quote here": check `translate.py`, or keep the
script to single quotes only, as the report page does. The draft below
already uses single quotes only, apart from `"..."` interpolated strings,
which could be rewritten with `+`. The macro rewrites
`cubeland_worlds\lan\cubeland_lan.ps1` from that text each time before
starting it.

```powershell
# Cubeland LAN helper. Cubeland writes this file into cubeland_worlds\lan
# each time it starts it, so edits are lost. It joins Cubeland's files to
# the network: nothing else.
#
#   -Mode scan  ask the LAN for open worlds; write found\lan_<session>.txt
#   -Mode host  answer those questions; send guests the snapshot and every
#               log; pass each log line on to everyone else
#   -Mode join  fetch the host's snapshot and logs into this folder, then
#               pass lines both ways
#
# It reads and writes files only in cubeland_worlds\lan\<Dir> (never
# deletes one) and stops when control_<Run>.txt says stop, when the game
# that started it has gone, or after HEARTBEAT seconds without the game
# touching control_<Run>.txt.
param(
  [ValidateSet('scan','host','join')]            [string]$Mode = 'scan',
  [ValidatePattern('^[0-9A-Za-z_]{1,48}$')]      [string]$Dir = 'found',
  [ValidatePattern('^[0-9A-Za-z_]{1,48}$')]      [string]$Run = 'x',
  [ValidatePattern('^[0-9]{0,12}$')]             [string]$Session = '',
  [ValidatePattern('^[0-9A-Za-z_]{0,40}$')]      [string]$Id = '',
  [ValidatePattern('^$|^([0-9]{1,3}\.){3}[0-9]{1,3}$')] [string]$Address = '',
  [ValidateRange(1024, 65535)]                   [int]$Port = 24461,
  [ValidateRange(1024, 65535)]                   [int]$Discovery = 24460,
  [int]$ParentPid = 0
)

$ErrorActionPreference = 'Stop'
$Protocol  = '1'
$Heartbeat = 900                                   # seconds; the PID check is the real one
$Folder    = [System.IO.Path]::Combine($PSScriptRoot, $Dir)
$FileEnc   = [System.Text.Encoding]::Default        # Cubeland's files are ANSI
$WireEnc   = New-Object System.Text.UTF8Encoding($false)
$LogName   = '^log_' + $Session + '_[0-9A-Za-z_]{1,40}\.txt$'
$Keys      = @('cubeland_session','session','host','name','seed','mode','cheats','open','world')

function Path-Of([string]$name) { return [System.IO.Path]::Combine($Folder, $name) }

function Write-Status([string]$text) {
  # one line ending in ~ (like a log line): Cubeland ignores a line without it
  $clean = $text -replace '[\r\n~]', ' '
  for ($try = 0; $try -lt 5; $try++) {
    try { [System.IO.File]::WriteAllText((Path-Of ('status_' + $Run + '.txt')), $clean + ' ~' + "`r`n", $FileEnc); return }
    catch { Start-Sleep -Milliseconds 10 }
  }
}

function Note([string]$text) {
  try { [System.IO.File]::AppendAllText((Path-Of ('helper_' + $Run + '.log')),
        (Get-Date).ToString('HH:mm:ss.fff') + ' ' + $text + "`r`n", $FileEnc) } catch {}
}

function Append-Lines([string]$name, $lines) {
  if ($lines.Count -eq 0) { return }
  $bytes = $FileEnc.GetBytes(($lines -join "`r`n") + "`r`n")
  for ($try = 0; $try -lt 20; $try++) {
    try {
      $fs = New-Object System.IO.FileStream((Path-Of $name), [System.IO.FileMode]::Append,
              [System.IO.FileAccess]::Write, [System.IO.FileShare]::ReadWrite)
      try { $fs.Write($bytes, 0, $bytes.Length) } finally { $fs.Close() }
      return
    } catch { Start-Sleep -Milliseconds 10 }
  }
  Note ('could not append to ' + $name)
}

# ---------------------------------------------------------------- reading the game's own log
$Sent = @{}   # file name -> bytes already passed on

function Read-Range([string]$name, [long]$from, [long]$upto) {
  # the complete lines (ending in ~) between two byte offsets; returns @(lines, offset after the last)
  $lines = New-Object System.Collections.Generic.List[string]
  $path = Path-Of $name
  if (-not [System.IO.File]::Exists($path)) { return @($lines, $from) }
  $fs = New-Object System.IO.FileStream($path, [System.IO.FileMode]::Open,
          [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
  try {
    if ($upto -lt 0 -or $upto -gt $fs.Length) { $upto = $fs.Length }
    if ($upto -le $from) { return @($lines, $from) }
    $fs.Position = $from
    $buf = New-Object byte[] ($upto - $from)
    $n = $fs.Read($buf, 0, $buf.Length)
  } finally { $fs.Close() }
  $used = 0
  for ($i = 0; $i -lt $n; $i++) {
    if ($buf[$i] -ne 10) { continue }
    $line = $FileEnc.GetString($buf, $used, $i - $used).TrimEnd("`r")
    if (-not $line.EndsWith('~')) { break }
    $lines.Add($line)
    $used = $i + 1
  }
  return @($lines, ($from + $used))
}

function Read-New([string]$name) {
  $from = 0
  if ($Sent.ContainsKey($name)) { $from = $Sent[$name] }
  $r = Read-Range $name $from -1
  $Sent[$name] = $r[1]
  return ,$r[0]
}

# ---------------------------------------------------------------- connections (one line = one frame)
function New-Conn($client) {
  $client.NoDelay = $true
  $client.SendTimeout = 10000
  return @{ Client = $client; Stream = $client.GetStream(); Decoder = $WireEnc.GetDecoder();
            Pending = (New-Object System.Text.StringBuilder); Id = ''; Ready = $false;
            Heard = [DateTime]::UtcNow; Beat = [DateTime]::UtcNow }
}

function Send-Frames($conn, $frames) {
  if ($frames.Count -eq 0) { return }
  $bytes = $WireEnc.GetBytes(($frames -join "`n") + "`n")
  $conn.Stream.Write($bytes, 0, $bytes.Length)
  $conn.Beat = [DateTime]::UtcNow
}

function Receive-Frames($conn) {
  # the complete frames that have arrived; $null once the other end has gone
  $frames = New-Object System.Collections.Generic.List[string]
  $socket = $conn.Client.Client
  if ($socket.Poll(0, [System.Net.Sockets.SelectMode]::SelectRead) -and $socket.Available -eq 0) { return $null }
  while ($socket.Available -gt 0) {
    $buf = New-Object byte[] ([Math]::Min($socket.Available, 65536))
    $n = $conn.Stream.Read($buf, 0, $buf.Length)
    if ($n -le 0) { return $null }
    $chars = New-Object char[] ($conn.Decoder.GetCharCount($buf, 0, $n))
    $m = $conn.Decoder.GetChars($buf, 0, $n, $chars, 0)
    [void]$conn.Pending.Append($chars, 0, $m)
    $conn.Heard = [DateTime]::UtcNow
  }
  $text = $conn.Pending.ToString()
  $end = $text.LastIndexOf("`n")
  if ($end -ge 0) {
    foreach ($f in $text.Substring(0, $end).Split("`n")) { if ($f.Length -gt 0) { $frames.Add($f) } }
    [void]$conn.Pending.Remove(0, $end + 1)
  }
  if ($conn.Pending.Length -gt 1048576) { return $null }   # no line is this long
  return ,$frames
}

function Keep-Alive($conn) {
  $now = [DateTime]::UtcNow
  if (($now - $conn.Heard).TotalSeconds -gt 20) { return $false }
  if (($now - $conn.Beat).TotalSeconds -gt 2) { Send-Frames $conn @('K') }
  return $true
}

# ---------------------------------------------------------------- stopping
$NextCheck = [DateTime]::MinValue
$ParentStart = $null

function Should-Stop {
  $now = [DateTime]::UtcNow
  if ($now -lt $script:NextCheck) { return $false }
  $script:NextCheck = $now.AddSeconds(1)
  $control = Path-Of ('control_' + $Run + '.txt')
  try {
    if ([System.IO.File]::ReadAllText($control, $FileEnc).StartsWith('stop')) { return $true }
    if (($now - [System.IO.File]::GetLastWriteTimeUtc($control)).TotalSeconds -gt $Heartbeat) { return $true }
  } catch { return $true }                              # no control file: not started by Cubeland
  if ($ParentPid -gt 0) {
    $p = Get-Process -Id $ParentPid -ErrorAction SilentlyContinue
    if ($p -eq $null) { return $true }
    try { if ($script:ParentStart -ne $null -and $p.StartTime -ne $script:ParentStart) { return $true } } catch {}
  }
  return $false
}

# ---------------------------------------------------------------- scan
function Broadcast-Addresses {
  $list = New-Object System.Collections.ArrayList
  [void]$list.Add([System.Net.IPAddress]::Broadcast)
  [void]$list.Add([System.Net.IPAddress]::Loopback)     # a host on this PC
  # 255.255.255.255 leaves through one adapter only, so also each adapter's own broadcast address
  foreach ($nic in [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()) {
    if ($nic.OperationalStatus -ne 'Up') { continue }
    foreach ($u in $nic.GetIPProperties().UnicastAddresses) {
      if ($u.Address.AddressFamily -ne 'InterNetwork' -or $u.IPv4Mask -eq $null) { continue }
      $a = $u.Address.GetAddressBytes(); $m = $u.IPv4Mask.GetAddressBytes()
      for ($i = 0; $i -lt 4; $i++) { $a[$i] = [byte]($a[$i] -bor (255 -bxor $m[$i])) }
      [void]$list.Add((New-Object System.Net.IPAddress (,$a)))
    }
  }
  return $list
}

function Save-Found([string]$reply, [string]$address) {
  $lines = @($reply.Split("`n") | ForEach-Object { $_.TrimEnd("`r") })
  if ($lines.Count -lt 3 -or $lines[0] -ne ('cubeland_here ' + $Protocol)) { return }
  $out = New-Object System.Collections.Generic.List[string]
  $session = ''; $port = ''
  foreach ($line in $lines[1..($lines.Count - 1)]) {
    if ($line.Length -gt 200) { continue }
    $words = $line.Split(' ', 2)
    if ($words[0] -eq 'port') { $port = $words[1]; continue }
    if ($Keys -notcontains $words[0]) { continue }
    if ($words[0] -eq 'session') { $session = $words[1] }
    $out.Add($line)
  }
  if ($session -notmatch '^[0-9]{1,12}$' -or $port -notmatch '^[0-9]{4,5}$') { return }
  $out.Add('address ' + $address)
  $out.Add('port ' + $port)
  try { [System.IO.File]::WriteAllText((Path-Of ('lan_' + $session + '.txt')), ($out -join "`r`n") + "`r`n", $FileEnc) } catch {}
}

function Run-Scan {
  $udp = New-Object System.Net.Sockets.UdpClient(0)     # any free port: replies come back to it
  $udp.EnableBroadcast = $true
  $query = $WireEnc.GetBytes('cubeland_query ' + $Protocol + "`n")
  $next = [DateTime]::MinValue; $targets = $null; $retarget = [DateTime]::MinValue
  Write-Status 'scanning'
  while (-not (Should-Stop)) {
    $now = [DateTime]::UtcNow
    if ($now -ge $retarget) { $targets = Broadcast-Addresses; $retarget = $now.AddSeconds(10) }
    if ($now -ge $next) {
      $next = $now.AddSeconds(1)
      foreach ($to in $targets) {
        try { [void]$udp.Send($query, $query.Length, (New-Object System.Net.IPEndPoint($to, $Discovery))) } catch {}
      }
    }
    while ($udp.Available -gt 0) {
      $from = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
      try { $bytes = $udp.Receive([ref]$from) } catch { break }
      Save-Found ($WireEnc.GetString($bytes)) ($from.Address.ToString())
    }
    Start-Sleep -Milliseconds 50
  }
  $udp.Close()
  Write-Status 'stopped'
}

# ---------------------------------------------------------------- host
function Catch-Up($own) {
  # what a new guest needs: the snapshot, then every log so far
  $frames = New-Object System.Collections.Generic.List[string]
  $frames.Add('W ' + $Protocol + ' ' + $Session)
  $count = 0
  foreach ($line in [System.IO.File]::ReadAllLines((Path-Of ('snapshot_' + $Session + '.txt')), $FileEnc)) {
    $frames.Add('S ' + $line); $count++
  }
  $frames.Add('E ' + $count)
  foreach ($file in [System.IO.Directory]::GetFiles($Folder, 'log_' + $Session + '_*.txt')) {
    $name = [System.IO.Path]::GetFileName($file)
    if ($name -notmatch $LogName) { continue }
    $upto = -1
    if ($name -eq $own) { $upto = $Sent[$own] }        # the rest goes out with the next Read-New
    foreach ($line in (Read-Range $name 0 $upto)[0]) { $frames.Add('L ' + $name + ' ' + $line) }
  }
  return ,$frames
}

function Run-Host {
  $own = 'log_' + $Session + '_' + $Id + '.txt'
  $listener = $null
  for ($p = $Port; $p -lt $Port + 10 -and $listener -eq $null; $p++) {
    try {
      $l = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Any, $p)
      $l.Start(); $listener = $l; $script:Port = $p      # the firewall asks about PowerShell here
    } catch {}
  }
  if ($listener -eq $null) { Write-Status 'failed no free port'; return }
  $udp = New-Object System.Net.Sockets.UdpClient
  $udp.Client.SetSocketOption([System.Net.Sockets.SocketOptionLevel]::Socket,
                              [System.Net.Sockets.SocketOptionName]::ReuseAddress, $true)
  $udp.Client.Bind((New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, $Discovery)))
  $conns = New-Object System.Collections.ArrayList
  [void](Read-New $own)                                 # sent to each guest by Catch-Up instead
  Write-Status ('hosting ' + $Port)
  while (-not (Should-Stop)) {
    # Play Multiplayer screens asking who is there
    while ($udp.Available -gt 0) {
      $from = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
      try { $q = $WireEnc.GetString($udp.Receive([ref]$from)) } catch { break }
      if (-not $q.StartsWith('cubeland_query ' + $Protocol)) { continue }
      try {
        $text = 'cubeland_here ' + $Protocol + "`n" +
                [System.IO.File]::ReadAllText((Path-Of ('lan_' + $Session + '.txt')), $FileEnc) + "`nport " + $Port + "`n"
        $bytes = $WireEnc.GetBytes($text)
        [void]$udp.Send($bytes, $bytes.Length, $from)
      } catch {}
    }
    while ($listener.Pending() -and $conns.Count -lt 15) { [void]$conns.Add((New-Conn $listener.AcceptTcpClient())) }

    # the host's own new lines go to every guest
    $out = New-Object System.Collections.Generic.List[string]
    foreach ($line in (Read-New $own)) { $out.Add('L ' + $own + ' ' + $line) }

    foreach ($c in @($conns)) {
      $gone = $false
      try {
        $frames = Receive-Frames $c
        if ($frames -eq $null -or -not (Keep-Alive $c)) { $gone = $true }
        else {
          foreach ($f in $frames) {
            $w = $f.Split(' ', 3)
            if ($w[0] -eq 'H' -and -not $c.Ready) {
              # H <protocol> <session> <id>
              $words = $f.Split(' ')
              if ($words.Count -ne 4 -or $words[1] -ne $Protocol) { Send-Frames $c @('R the host is running a different version'); $gone = $true; break }
              if ($words[2] -ne $Session) { Send-Frames $c @('R that world is closed'); $gone = $true; break }
              if ($words[3] -notmatch '^[0-9A-Za-z_]{1,40}$' -or $words[3] -eq $Id) { Send-Frames $c @('R bad player id'); $gone = $true; break }
              $c.Id = $words[3]
              Send-Frames $c (Catch-Up $own)
              $c.Ready = $true
              Note ('joined ' + $c.Id)
            } elseif ($w[0] -eq 'L' -and $c.Ready -and $w.Count -eq 3) {
              # a guest may only write its own log
              if ($w[1] -ne ('log_' + $Session + '_' + $c.Id + '.txt')) { continue }
              Append-Lines $w[1] @($w[2])
              foreach ($o in $conns) { if ($o -ne $c -and $o.Ready) { try { Send-Frames $o @($f) } catch {} } }
            }
          }
        }
      } catch { $gone = $true; Note ('lost ' + $c.Id + ': ' + $_.Exception.Message) }
      if ($gone) {
        try { $c.Client.Close() } catch {}
        $conns.Remove($c)
        if ($c.Ready) {
          # say it left for it, in case it couldn't
          $name = 'log_' + $Session + '_' + $c.Id + '.txt'
          Append-Lines $name @('L ~')
          $out.Add('L ' + $name + ' L ~')
        }
      }
    }
    foreach ($c in $conns) { if ($c.Ready) { try { Send-Frames $c $out } catch {} } }
    Start-Sleep -Milliseconds 20
  }
  foreach ($c in $conns) { try { Send-Frames $c @('X the host closed the world'); $c.Client.Close() } catch {} }
  $listener.Stop(); $udp.Close()
  Write-Status 'stopped'
}

# ---------------------------------------------------------------- join
function Run-Join {
  $own = 'log_' + $Session + '_' + $Id + '.txt'
  Write-Status 'connecting'
  $client = New-Object System.Net.Sockets.TcpClient
  $wait = $client.BeginConnect($Address, $Port, $null, $null)
  if (-not $wait.AsyncWaitHandle.WaitOne(5000) -or -not $client.Connected) { Write-Status 'failed the host did not answer'; return }
  $client.EndConnect($wait)
  $c = New-Conn $client
  Send-Frames $c @('H ' + $Protocol + ' ' + $Session + ' ' + $Id)
  $snapshot = $null; $lines = 0; $ready = $false
  while (-not (Should-Stop)) {
    $frames = Receive-Frames $c
    if ($frames -eq $null -or -not (Keep-Alive $c)) { Write-Status 'lost the connection to the host'; return }
    foreach ($f in $frames) {
      $rest = ''
      if ($f.Length -gt 2) { $rest = $f.Substring(2) }
      switch ($f.Substring(0, 1)) {
        'W' { $snapshot = New-Object System.IO.StreamWriter((Path-Of ('snapshot_' + $Session + '.txt')), $false, $FileEnc)
              Write-Status 'downloading' }
        'S' { if ($snapshot -ne $null) { $snapshot.WriteLine($rest); $lines++ } }
        'E' { if ($snapshot -ne $null) { $snapshot.Close(); $snapshot = $null }
              $ready = $true; [void](Read-New $own); Write-Status ('ready ' + $lines) }
        'L' { $w = $rest.Split(' ', 2)
              if ($w.Count -eq 2 -and $w[0] -match $LogName -and $w[0] -ne $own) { Append-Lines $w[0] @($w[1]) } }
        'R' { Write-Status ('failed ' + $rest); return }
        'X' { Write-Status ('closed ' + $rest); return }
      }
    }
    if ($ready) {
      $out = New-Object System.Collections.Generic.List[string]
      foreach ($line in (Read-New $own)) { $out.Add('L ' + $own + ' ' + $line) }
      Send-Frames $c $out
    }
    Start-Sleep -Milliseconds 20
  }
  try { $client.Close() } catch {}
  Write-Status 'stopped'
}

# ---------------------------------------------------------------- start
try {
  if ($ExecutionContext.SessionState.LanguageMode -ne 'FullLanguage') { Write-Status 'failed powershell is locked down on this pc'; exit }
  if (-not [System.IO.Directory]::Exists($Folder)) { [void][System.IO.Directory]::CreateDirectory($Folder) }
  if ($ParentPid -le 0) {
    try { $ParentPid = (Get-CimInstance Win32_Process -Filter ('ProcessId=' + $PID)).ParentProcessId } catch {}
  }
  try { $ParentStart = (Get-Process -Id $ParentPid).StartTime } catch {}
  Write-Status 'starting'
  switch ($Mode) { 'scan' { Run-Scan } 'host' { Run-Host } 'join' { Run-Join } }
} catch {
  Note ($_ | Out-String)
  Write-Status ('failed ' + $_.Exception.Message)
}
```

Notes on the draft:

- Its loops are single-threaded and non-blocking (`Pending()`,
  `Available`, `Poll`), so no runspaces or jobs.
- It never deletes: `WriteAllText` overwrites, `Append` appends, and the
  snapshot is written with `StreamWriter(..., append=$false)`.
- Snapshots are small because a save is the seed plus edits. If they get
  large, `Catch-Up` should stream them rather than build one list.
- **UNSURE (test on Windows):** whether `UdpClient(0)` bound to an
  ephemeral port triggers a firewall prompt on the guest. I expect it
  doesn't, because the guest only receives unicast replies to its own
  broadcast. That is allowed by the default Windows Firewall setting
  "Allow unicast response" (to multicast or broadcast, for 3 seconds).

---

## (d) Files and protocol

### Folders (all inside `cubeland_worlds`, which the macro already writes)

```
cubeland_worlds\lan\cubeland_lan.ps1      written by the macro before every start
cubeland_worlds\lan\found\                scan helper: lan_<session>.txt per world heard
cubeland_worlds\lan\h_<session>\          host: lan_, snapshot_, log_ files (net.4dm's folder)
cubeland_worlds\lan\j_<player id>\        guest: the snapshot and logs received (net.4dm's folder)
  each of those also holds:
    control_<run>.txt   macro -> helper: "run ~" or "stop ~" (overwritten)
    status_<run>.txt    helper -> macro: one line "<state> <detail> ~"
    helper_<run>.log    helper's own notes, for debugging
```

Each run has its own folder, so a host and a guest in the same 12d
working folder (the same PC, over loopback) never append to the same
files. The folders build up over time (nothing is deleted); they are
small.

### Found-world file (`found\lan_<session>.txt`)

This is the existing session-file format that `net_read_session` reads,
with two extra keys. Unknown keys are already ignored, so it stays
compatible:

```
cubeland_session 1
session 123456789
host bob_4821
name bob
seed 4242
mode 1
cheats 0
open 1
world Shared
address 192.168.1.23
port 24461
```

**Fresh** means the file's modified time
(`Get_file_modified_time_utc`) is within `LAN_FRESH_SECONDS` (5 s) of
now. The scan helper rewrites the file about once a second while the
host answers. Stale files from earlier days are therefore never listed,
and none are deleted.

### Status states (`status_<run>.txt`)

`starting`, `scanning`, `hosting <port>`, `connecting`, `downloading`,
`ready <snapshot lines>`, `failed <why>`, `lost the connection to the
host`, `closed <why>`, `stopped`. The macro shows `failed`, `lost` and
`closed` in chat. If there is no status file, or it still says
`starting` after about 10 s, the helper didn't start (blocked, or
PowerShell is missing).

### Discovery (UDP, port 24460)

- Guest scan → broadcast to 255.255.255.255, each adapter's own broadcast
  address and 127.0.0.1, once a second: `cubeland_query 1`.
- Host → unicast reply to the sender: `cubeland_here 1\n` + the host's
  own `lan_<session>.txt` (written by `net_write_session`, so the macro
  stays in charge of mode, cheats and world name) + `port <tcp port>`.
- This is a query/response design, unlike Minecraft, where the host
  sends `[MOTD]..[/MOTD][AD]port[/AD]` to 224.0.2.60:4445 and every
  client has to listen. With query/response **only the host has to
  accept inbound traffic**, so the firewall should only ask on the host.

### Game traffic (TCP, port 24461; the host tries up to 24470 if it is taken)

One UTF-8 frame per line; the first letter is the frame type:

| Frame | Direction | Meaning |
|---|---|---|
| `H <protocol> <session> <id>` | guest → host | hello |
| `W <protocol> <session>` | host → guest | welcome; the snapshot follows |
| `S <line>` | host → guest | one line of `snapshot_<session>.txt` |
| `E <count>` | host → guest | snapshot finished (guest's status becomes `ready`) |
| `L <logname> <line>` | both | one line of a player's log (`<line>` keeps its ` ~` end) |
| `R <why>` | host → guest | refused |
| `X <why>` | host → guest | host closed the world |
| `K` | both | keep-alive every 2 s; 20 s of silence counts as gone |

The host only accepts `L` lines that a guest writes to **its own** log
(`log_<session>_<that guest's id>.txt`). The guest only accepts names that
match `^log_<session>_[0-9A-Za-z_]+\.txt$`, so nothing can climb out of
the folder.

### The macro side

`net.4dm` is unchanged: it still appends its own log, scans its folder
for `log_<session>_*.txt` and reads new complete lines. The helper makes
the folder look like a shared folder that every player writes to.

---

## (e) Implementation steps, by file

1. **`src/net/lan_helper.ps1`** (new): the script above.
   **`tools/make_lan_helper.py`** (new) writes
   **`src/net/lan_helper_script.4dm`** with
   `void lan_helper_script_write(File &p_file)`, plus a `--check` option.
   `tools/test_harness/build.sh` checks that it is current, as it does
   for the report page.

2. **`include/core/safety.h`**:
   - Add the switch `SAFE_ALLOW_LAN_HELPER` with
     `#warning Safety: the LAN helper may be started (Windows PowerShell running cubeland_worlds\lan\cubeland_lan.ps1) (SAFE_ALLOW_LAN_HELPER)`.
     No apostrophes, per the existing note.
   - Add `#define SAFE_HELPER_FOLDER "cubeland_worlds\\lan"`,
     `SAFE_HELPER_SCRIPT "cubeland_lan.ps1"` and
     `SAFE_CREATE_NO_WINDOW 134217728`.
   - `Integer safe_helper_word(Text p_word, Integer p_max)`: letters,
     digits and `_` only, length 1 to p_max. Also
     `safe_helper_address(Text)` for dotted IPv4, digits only.
   - `Text safe_helper_command_line(Text p_mode, Text p_dir, Text p_run, Text p_session, Text p_id, Text p_address, Integer p_port, Integer p_parent)`.
     An honest function that unit tests can check. It returns `""` if
     anything fails validation; otherwise:
     `<SystemRoot>\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -File cubeland_lan.ps1 -Mode host -Dir h_123 -Run h_123 -Session 123 -Id bob_4821 -Port 24461 -ParentPid 5678`.
     It needs no quotes: SystemRoot must look like `C:\WINDOWS` (letter,
     colon, backslash, letters only), and the script is named relative
     to the start folder.
   - `Integer safe_run_helper(<same args>, Process_Handle &p_handle)`
     does the following:
     - builds the line;
     - takes the start folder from `Get_absolute_path(SAFE_HELPER_FOLDER + "\\")`
       and refuses it unless it ends in `\cubeland_worlds\lan\`;
     - writes the script itself from `lan_helper_script_write`, so the
       file that runs is always the macro's own text;
     - calls `Create_process(<exe>, <line>, <folder>, SAFE_CREATE_NO_WINDOW, 0, p_handle)`.

     **That is the only call to Create_process anywhere, and it can
     only start the one fixed program with the one fixed script.**
   - `Integer safe_helper_running(Process_Handle &p_handle)` wraps
     `Process_exists`.
   - Define all of these **above** the blocked-calls section. Keep
     `#define Create_process illegal_call` and
     `#define Process_exists illegal_call` below it, as for File_open.
   - Without the switch, `safe_run_helper` returns `SAFE_OPEN_REFUSED`,
     so the code compiles in every build and the game falls back to the
     shared folder.
   - Update the header comment ("start programs: only the LAN helper,
     with SAFE_ALLOW_LAN_HELPER").
   - **Ordering problem:** `safety.h` must not depend on other headers,
     but `lan_helper_script_write` is generated code. Two ways out:
     - include the generated `.4dm` from `safety.h`, since it only
       calls `File_write_line`;
     - or have the caller write the script and let `safe_run_helper`
       only check that the file exists. That is weaker: in the window
       between the write and the start, anything on the PC that can
       write `cubeland_worlds` could swap the file.

     I recommend the first.

3. **`src/build.4dm`**: add `#define SAFE_ALLOW_LAN_HELPER` next to
   `SAFE_ALLOW_SHARE_FOLDER`. Decide whether `test/cubeland_test.4dm`
   defines it. Either works because of the refusing stub; I'd leave it
   off so the test build can never start a process.

4. **`include/net/lan.h` + `src/net/lan.4dm`** (new module; add both to
   `build.4dm` and to the layout in the README).
   - Constants: `LAN_FOLDER`, `LAN_FOUND_DIR "found"`,
     `LAN_DISCOVERY_PORT 24460`, `LAN_GAME_PORT 24461`,
     `LAN_FRESH_SECONDS 5`, `LAN_CONNECT_SECONDS 30`,
     `LAN_START_SECONDS 10`.
   - Honest functions:
     - `lan_host_dir(session)`, `lan_join_dir(id)`, `lan_folder(dir)`;
     - `lan_write_control(folder, run, word)` (`safe_file_open "w"`);
     - `lan_read_status(folder, run, &state, &detail)` (a line without
       `~` counts as unread);
     - `lan_status_problem(state, detail)`, which gives the player's
       text, for example "the host didn't answer: its firewall may be
       blocking Windows PowerShell";
     - `lan_parent_pid()`, taken from the last folder name of
       `Get_temporary_project_directory`. This one reads 12d state, so
       only controllers call it, or the controller passes the folder
       in.
   - `lan_start(mode, dir, run, session, id, address, port, Process_Handle &)`
     makes the folder (`safe_folder_create`), writes `control` "run" and
     calls `safe_run_helper`. It is a controller-only function.

5. **`include/net/net.h` / `src/net/net.4dm`**:
   - `net_read_session_address(Text p_path, Text &p_address, Integer &p_port)`.
     This is a new function, so `net_read_session`'s callers don't
     change.
   - `net_list_lan` gains `Integer p_fresh_after`: 0 means no check, as
     for the shared folder; otherwise skip files whose UTC modified time
     is older. Use `Get_file_modified_time_utc`, which returns
     **Integer64**, against `Get_time(Integer &)`. **UNSURE** whether
     12dPL compares Integer64 with Integer directly; if not, assign to
     Integer64 first.
   - Add `ATTR_LAN_ADDRESS` and `ATTR_LAN_PORT` to the list record.
   - Rewrite the header comment, which says "12dPL has no sockets, so
     files are the only way". The new wording: files stay the
     interface, carried by the shared folder or by the LAN helper.
   - Optionally make `NET_POLL_SECONDS` 0.1 for the helper (local disk).

6. **Settings** (`settings.h/.4dm`, `settings_panel.4dm`,
   `render_screens.4dm`):
   - `ATTR_SET_MP_TRANSPORT`: *Network (LAN)*, the default, or *Shared
     folder*.
   - The folder field is shown only for Shared folder.
   - Widgets go in the existing multiplayer settings screen; no 12d
     widgets.

7. **`src/ui/menu_panel.4dm`** (controller), for the Network transport:
   - On `W_MULTIPLAYER`, call `lan_start("scan", "found", "s<time>", ...)`
     and keep the handle in a global `g_lan_helper`. The handle can't go
     in a record, and only controllers name globals.
   - List from `cubeland_worlds\lan\found` with `p_fresh_after = now - 5`
     (the existing 2 s rescan stays).
   - On `W_BACK`, on `W_JOIN` and when the panel closes, write
     `control` "stop".
   - If the status is `failed ...` or still `starting` after
     `LAN_START_SECONDS`, show a line in the empty list: "Couldn't search
     the network: <problem>".

8. **`src/ui/game_panel.4dm`** (controller):
   - **Join** (`MENU_RESULT_JOIN`), for the Network transport:
     1. Read address and port from the found file.
     2. `l_folder = lan_folder(lan_join_dir(l_player_id))`.
     3. `lan_start("join", ...)`.
     4. Loop with `Sleep(100)` and `game_panel_notice(p_box, "Connecting", "to <host> (<address>)")`
        until the status is `ready` (then call `game_join(l_folder, <found file>, ...)`,
        which needs no changes because it takes the folder and the
        session file separately), or `failed`, `closed`, or
        `LAN_CONNECT_SECONDS` have passed (then report the problem).
   - **Host** (the SCREEN_LAN start, line ~808):
     1. `l_folder = lan_folder(lan_host_dir(session))`.
     2. Call `game_host(...)` with that folder (unchanged).
     3. Call `lan_start("host", ...)`.
     4. Wait up to 5 s for `hosting <port>`.
     5. Chat: "Local game hosted on port N. If Windows asks, allow
        Windows PowerShell on private networks". On failure, chat the
        problem and suggest the shared-folder setting.
   - **While playing:** every `NET_SCAN_SECONDS`, read the status and
     check `safe_helper_running`. On `lost`, `closed` or the helper
     gone, say so once in chat. A guest keeps playing alone, as today
     when a host's log stops.
   - **Leaving:** at every `net_leave(g_net)` (lines ~422, 430, 808,
     874), also write `control` "stop". Mouse capture code is untouched.

9. **`src/program/game.4dm`**: no logic change (it already takes
   `p_folder`). Update the comments that say "multiplayer folder".

10. **Test build**:
    - `tools/make_test_registry.py`: add `'Process_Handle'` to
      `CANT_PASS`. In `classify()`, mark any function whose body calls
      `Create_process`, `safe_run_helper` or `lan_start` as
      `why = 'starts a program'`, spread through callers like the panel
      rule. That keeps "every function once" from ever starting
      PowerShell.
    - `test/src/test_cases.4dm`, unit tests:
      - `safe_helper_command_line` gives the exact line, and `""` for
        `bob;calc`, `..`, a space, a bad IP or port 80;
      - `lan_read_status` with and without `~`;
      - `net_read_session_address`;
      - `net_list_lan` freshness (write a found file, check it is
        listed, then not listed with a later `p_fresh_after`);
      - `lan_status_problem` texts.
    - `test/src/test_inputs.4dm`: rules for `p_address` (valid IPs
      only), `p_port` (1024..65535), `p_run` / `p_dir` (valid words).
    - Run `python3 tools/make_test_registry.py`.

11. **Harness** (`tools/test_harness`):
    - `translate.py`: add `Process_Handle` to `decl_re`.
    - `runtime.h`:
      - `struct Process_Handle { int id = 0; };`
      - `Create_process` (both overloads) prints
        `[process] <program> | <command line> | <dir> | flags <n>`, gives
        a fake id and starts a **simulated helper** (below). It never
        runs anything.
      - `Process_exists` returns whether the simulated helper is still
        running.
      - `Get_absolute_path` gives the run folder + path, using `\`.
      - `Getenv("SystemRoot")` gives `C:\Windows`.
      - `Get_temporary_project_directory` gives `.../12d/4242`.
    - New `lan_sim.cpp`, appended like `hooks.cpp`, with
      `lan_sim_pump()` called once per tick from `harness.cpp` and from
      the `Sleep` stub. It parses the command line, so the test also
      checks that the macro built the right one, and does what the
      script would do, with files only. A "remote PC" is
      `run/remote/cubeland_worlds/lan/...`:
      - **scan:** for each remote host folder with an open `lan_*.txt`,
        rewrite `found\lan_<s>.txt` with `address 10.0.0.2` and
        `port 24461` each tick.
      - **join:** write `status downloading`, copy the remote snapshot,
        then `ready N`; then each tick copy new complete remote log
        lines into the local folder, and the guest's own new lines out
        to the remote folder.
      - **host:** write `hosting 24461`; copy the host's log to the
        remote folder and the remote guests' lines (written by hooks,
        such as `bob`) into the host folder.
      - Stop when `control` says stop, then write `stopped`.
      - Failure switches set by hooks: `call lan_firewall` (scan finds
        nothing; join gives `failed the host did not answer`) and
        `call lan_host_quits` (join gets `closed the host closed the world`).
    - Hooks: `remote_host` (writes a remote host folder from the
      current world, using `save_world_to` into the remote path through
      plain C++ file calls), `remote_bob_line`, `lan_status`,
      `lan_files`.
    - New scenario **`37_lan_helper.txt`**:
      1. Play Multiplayer prints the scan `[process]` line, then
         `wait 4`, then `snap` the list showing the remote host, world
         and mode.
      2. Join shows "Connecting", then the world loads; bob's block is
         there.
      3. The host quits, so the chat says "closed".
      4. Back to a world: Open to LAN prints the host `[process]` line;
         a simulated guest's lines arrive; Save and Quit writes `stop`.
      5. A firewall-blocked run shows the problem text.

      Add the row to the harness README. Scenario 24 stays as the
      shared-folder test.
    - **Optional real test of the script:**
      `tools/lan_helper/test_helper.ps1`, run with `pwsh` if installed
      (it isn't here; installing it is the owner's call). It copies a
      fake host folder, starts `-Mode host` and `-Mode join -Address 127.0.0.1`
      plus `-Mode scan` in temp folders (scan also sends to 127.0.0.1),
      and checks the found file, the snapshot copy and lines in both
      directions, then writes `stop`. On Linux, `Get-CimInstance` fails
      inside its try/catch, so pass `-ParentPid`.

12. **Desktop build** (`tools/desktop/desktop.cpp`): real versions of
    the calls, so two PCs can be tested **without 12d**.
    - `struct Process_Handle { HANDLE h = NULL; };`
    - `Create_process` → `CreateProcessA(program, <mutable copy of the line>, NULL, NULL, inherit, flags, NULL, dir.empty() ? NULL : dir, &si, &pi)`,
      closing `pi.hThread` and keeping `pi.hProcess`.
    - `Process_exists` → `WaitForSingleObject(h, 0) == WAIT_TIMEOUT`.
    - `Get_absolute_path` → `GetFullPathNameA`; `Getenv` → `getenv`;
      `Get_temporary_project_directory` → `%TEMP%\12d\<GetCurrentProcessId()>`.
    - Build with `./build_with_zig.sh`, then copy `cubeland.exe` and
      `cubeland_test.exe` to `release/` (per CLAUDE.md).

13. **Docs**:
    - `docs/TODO.md`: add "Real LAN play without a shared folder (PowerShell helper)".
    - `README.md`: player-facing text, covering the Network /
      Shared-folder choice, the one-time firewall prompt on the host and
      the Private network profile.
    - `CLAUDE.md` project notes: the helper, the generator script, and
      that only `safe_run_helper` may start a process.
    - Then build, `./run.sh --all`, look at the PNGs, commit, push and
      merge to `main`, per CLAUDE.md.

---

## (f) Risks and unknowns

- **Firewall (the big one).** The first `TcpListener.Start()` or UDP bind
  on the host makes Windows Defender Firewall ask about
  **"Windows PowerShell"**.
  - Admins click Allow. **Standard users need admin credentials** to
    allow it.
  - If someone presses **Cancel**, Windows creates inbound **block**
    rules for powershell.exe. The host then stays unreachable until an
    admin removes them in `wf.msc`.
  - The allow rule covers *every* PowerShell script that listens, which
    some IT departments won't accept.
  - On a network marked **Public**, the default tick only allows
    Private.
  - Company Group Policy can stop local rules from taking effect.
  - Guests should get no prompt (query/response design), but that is
    **UNSURE until tested**.
  - The macro can't see the prompt: the host just never shows up for
    guests. The status and chat text should say what to check.
- **AV / EDR.** "An engineering app starts hidden PowerShell with
  `-ExecutionPolicy Bypass`, which opens a listening socket" matches
  common EDR rules (CrowdStrike, Defender for Endpoint ASR "block
  process creations from ... / obfuscated scripts"). The script is plain
  text with no `-EncodedCommand` and no downloads, so AMSI should pass
  it. On managed company PCs it may still be blocked or reported to IT.
  12d users are mostly on such PCs. **Keep the shared-folder mode as the
  fallback** and ask IT.
- **Execution policy.** `-ExecutionPolicy Bypass` on the command line
  beats LocalMachine and CurrentUser policies but **not** a Group Policy
  (MachinePolicy/UserPolicy) setting. Then the script doesn't run: the
  status file never appears, and after `LAN_START_SECONDS` the macro
  reports it. `-EncodedCommand` would avoid execution policy, but it is
  an AV red flag; don't.
- **Constrained Language Mode** (AppLocker/WDAC): `New-Object` of socket
  types is refused. The script checks `LanguageMode` and writes
  `failed powershell is locked down on this pc`.
- **12d itself.**
  - `Create_process` "can not be called from 12d Model Practise
    version".
  - **UNSURE** how 12d passes an empty `program_name`, so the plan
    always gives the full exe path.
  - **UNSURE** what 12d does with `start_directory` given as a relative
    path, so the plan gives `Get_absolute_path(...)`.
  - The docs mention no sandbox, but IT may block child processes of
    12d.exe.
  - **UNSURE** whether `Get_absolute_path` gives a trailing `\`;
    normalise it.
  - **UNSURE** that the temp project folder's last part is always the
    PID. The script falls back to CIM `ParentProcessId`, then to the
    heartbeat.
- **No kill call.** If the macro crashes, the helper exits within about
  1 s through the PID check (start time compared, against PID reuse). If
  both checks fail, the 15-minute heartbeat limit ends it. The controller
  should rewrite `control` "run" every few seconds while it runs; in a
  pause it may stop, which is why the heartbeat limit is long.
- **Window flashing.** `CREATE_NO_WINDOW` means no console, so no flash
  (it depends on 12d really passing `flags` through, as the doc says).
  `-WindowStyle Hidden` stays as a backup and is harmless without a
  console. The firewall prompt itself does appear, maybe behind 12d's
  window.
- **PowerShell start time.** 0.5 to 3 s, more with AV scanning, so the
  list fills after about 2 to 4 s. Show "Searching..." meanwhile.
- **Latency.** The macro reads every `NET_POLL_SECONDS` (0.2 s); the
  helper reads every 20 ms; LAN TCP takes about 1 ms. End to end that is
  about 0.1 to 0.45 s, the same as or better than SMB shared folders.
  Polling local files is cheap, so 0.1 s is possible.
- **Files in use.** The macro opens and closes logs for every flush and
  read. The helper uses `FileShare.ReadWrite` and retries. A clash
  delays a line by one tick but never loses it.
- **Broadcast reach.** Only the same subnet. Guest Wi-Fi with client
  isolation, VPNs and some mesh systems block broadcasts. A later
  addition could be a "Direct connect: IP address" field (the join path
  already takes address and port).
- **Ports.** UDP 24460 and TCP 24461, both below the Windows ephemeral
  range (49152 and up). Hyper-V/WSL sometimes reserve port ranges, so
  the host tries 10 TCP ports. Discovery can't move, but `ReuseAddress`
  lets two hosts share it.
- **Trust.** Anyone on the LAN can join an open world. The same is true
  today for anyone who can see the shared folder, and in Minecraft. The
  helper checks file names, line lengths and that a guest writes only
  its own log. Snapshot and log text is still parsed by the macro, as
  it is now.
- **Disk.** Logs grow by about 0.7 MB per player per hour; per-run
  folders build up (never deleted). This matches today's behaviour.
- **Fallbacks, in order:** shared folder (exists); `Shell_execute` with
  showcmd 0 if `Create_process` misbehaves in 12d; a `csc.exe`-compiled
  helper (option B) if a named firewall rule matters more than the extra
  safety review.
