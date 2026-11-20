# Cubeland LAN helper. Cubeland writes this file into cubeland_worlds\lan
# each time it starts it (from src/net/lan_helper.ps1 through
# tools/make_lan_helper.py), so edits here are lost. It joins Cubeland's
# multiplayer files to the network and does nothing else.
#
#   -Mode scan  ask the LAN for open worlds; write <Dir>\lan_<session>.txt
#               for each one heard (open 0 once it stops answering)
#   -Mode host  answer those questions; send guests the snapshot and every
#               log; pass each log line on to everyone else
#   -Mode join  fetch the host's snapshot and logs into <Dir>, then pass
#               log lines both ways
#
# It reads and writes files only in cubeland_worlds\lan\<Dir> (and never
# deletes one). It stops when control_<Run>.txt says stop, when the 12d
# (or cubeland.exe) that started it has gone, or after HEARTBEAT seconds
# without the game rewriting control_<Run>.txt.
#
# No double quotes in this file: it is kept in the macro as 12dPL text.
param(
  [ValidateSet('scan','host','join')]            [string]$Mode = 'scan',
  [ValidatePattern('^[0-9A-Za-z_]{1,48}$')]      [string]$Dir = 'found',
  [ValidatePattern('^[0-9A-Za-z_]{1,48}$')]      [string]$Run = 'x',
  [ValidatePattern('^[0-9]{0,12}$')]             [string]$Session = '',
  [ValidatePattern('^[0-9A-Za-z_]{0,40}$')]      [string]$Id = '',
  [ValidatePattern('^$|^([0-9]{1,3}\.){3}[0-9]{1,3}$')] [string]$Address = '',
  [ValidateRange(1024, 65535)]                   [int]$Port = 24461,
  [ValidateRange(1024, 65535)]                   [int]$Discovery = 24460
)

$ErrorActionPreference = 'Stop'
$Protocol  = '1'
$Heartbeat = 43200                                  # seconds; the parent check is the real one
$Quiet     = 5                                      # seconds before a world that stopped answering is closed
$CR        = [string][char]13
$LF        = [string][char]10
$CRLF      = $CR + $LF
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
    try { [System.IO.File]::WriteAllText((Path-Of ('status_' + $Run + '.txt')), $clean + ' ~' + $CRLF, $FileEnc); return }
    catch { Start-Sleep -Milliseconds 10 }
  }
}

function Note([string]$text) {
  try { [System.IO.File]::AppendAllText((Path-Of ('helper_' + $Run + '.log')),
        (Get-Date).ToString('HH:mm:ss.fff') + ' ' + $text + $CRLF, $FileEnc) } catch {}
}

function Append-Lines([string]$name, $lines) {
  if ($lines.Count -eq 0) { return }
  $bytes = $FileEnc.GetBytes(($lines -join $CRLF) + $CRLF)
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
    $line = $FileEnc.GetString($buf, $used, $i - $used).TrimEnd([char]13)
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
  $bytes = $WireEnc.GetBytes(($frames -join $LF) + $LF)
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
  $end = $text.LastIndexOf($LF)
  if ($end -ge 0) {
    foreach ($f in $text.Substring(0, $end).Split([char]10)) { if ($f.Length -gt 0) { $frames.Add($f) } }
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
$NextCheck   = [DateTime]::MinValue
$ParentPid   = 0
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
  if ($script:ParentPid -gt 0) {
    $p = Get-Process -Id $script:ParentPid -ErrorAction SilentlyContinue
    if ($p -eq $null) { return $true }
    try { if ($script:ParentStart -ne $null -and $p.StartTime -ne $script:ParentStart) { return $true } } catch {}
  }
  return $false
}

function Find-Parent {
  # the program that started this one (12d, or cubeland.exe)
  try { $script:ParentPid = [int](Get-CimInstance Win32_Process -Filter ('ProcessId=' + $PID)).ParentProcessId } catch {
    try { $script:ParentPid = [int](Get-WmiObject Win32_Process -Filter ('ProcessId=' + $PID)).ParentProcessId } catch {} }
  try { $script:ParentStart = (Get-Process -Id $script:ParentPid).StartTime } catch {}
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

$Heard = @{}   # session -> @{ Lines = ...; At = time last heard; Open = written as open }

function Write-Found([string]$sid, $lines) {
  try { [System.IO.File]::WriteAllText((Path-Of ('lan_' + $sid + '.txt')), ($lines -join $CRLF) + $CRLF, $FileEnc) } catch {}
}

function Save-Found([string]$reply, [string]$address) {
  $lines = @($reply.Split([char]10) | ForEach-Object { $_.TrimEnd([char]13) })
  if ($lines.Count -lt 3 -or $lines[0] -ne ('cubeland_here ' + $Protocol)) { return }
  $out = New-Object System.Collections.Generic.List[string]
  $sid = ''; $port = ''
  foreach ($line in $lines[1..($lines.Count - 1)]) {
    if ($line.Length -gt 200) { continue }
    $words = $line.Split(' ', 2)
    if ($words[0] -eq 'port') { $port = $words[1]; continue }
    if ($Keys -notcontains $words[0]) { continue }
    if ($words[0] -eq 'session') { $sid = $words[1] }
    $out.Add($line)
  }
  if ($sid -notmatch '^[0-9]{1,12}$' -or $port -notmatch '^[0-9]{4,5}$') { return }
  # the world line goes last (Cubeland reads the rest of it as the name)
  $world = @($out | Where-Object { $_.StartsWith('world ') })
  $rest  = @($out | Where-Object { -not $_.StartsWith('world ') })
  $out = New-Object System.Collections.Generic.List[string]
  foreach ($l in $rest) { $out.Add($l) }
  $out.Add('address ' + $address)
  $out.Add('port ' + $port)
  foreach ($l in $world) { $out.Add($l) }
  $Heard[$sid] = @{ Lines = $out; At = [DateTime]::UtcNow; Open = $true }
  Write-Found $sid $out
}

function Close-Quiet {
  # a world that stopped answering is written closed (files are never deleted)
  $now = [DateTime]::UtcNow
  foreach ($s in @($Heard.Keys)) {
    $h = $Heard[$s]
    if (-not $h.Open -or ($now - $h.At).TotalSeconds -lt $Quiet) { continue }
    $h.Open = $false
    Write-Found $s @($h.Lines | ForEach-Object { if ($_.StartsWith('open ')) { 'open 0' } else { $_ } })
  }
}

function Run-Scan {
  $udp = New-Object System.Net.Sockets.UdpClient(0)     # any free port: replies come back to it
  $udp.EnableBroadcast = $true
  $query = $WireEnc.GetBytes('cubeland_query ' + $Protocol + $LF)
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
      Close-Quiet
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
        $info = [System.IO.File]::ReadAllText((Path-Of ('lan_' + $Session + '.txt')), $FileEnc)
        if ($info -match '(?m)^open 0') { continue }     # closed: say nothing
        $bytes = $WireEnc.GetBytes('cubeland_here ' + $Protocol + $LF + $info + $LF + 'port ' + $Port + $LF)
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
  Find-Parent
  Write-Status 'starting'
  switch ($Mode) { 'scan' { Run-Scan } 'host' { Run-Host } 'join' { Run-Join } }
} catch {
  Note ($_ | Out-String)
  Write-Status ('failed ' + $_.Exception.Message)
}
