def ts2date [ts: string] {
  $ts | str substring 0..9 | into datetime -f "%s" | date to-timezone local | format date "%Y-%m-%d %H:%M:%S"
}

def killport [num:int=5173] {
    let matches = (netstat -ano | decode utf-8 | lines | where $it =~ $':($num)')
    if ($matches | is-empty) {
        print $"No process found listening on port ($num)"
        return
    }
    let pid = ($matches | first | split row --regex '\s+' | last | str trim)
    if ($pid | is-empty) {
        print $"No process found listening on port ($num)"
    } else {
        print $"Killing process ID: ($pid) listening on port ($num)"
        ^taskkill /F /PID $pid
    }
}