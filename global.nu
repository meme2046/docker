def ts2date [ts: string] {
    $ts | str substring 0..9 | into datetime -f "%s" | date to-timezone local | format date "%Y-%m-%d %H:%M:%S"
}

# port scan
def pp [num:int=5173] {
    let matches = (netstat -ano | decode gbk | lines | where $it =~ $':($num)')
    if ($matches | is-empty) {
        print $"No process found listening on port ($num)"
        return
    } else {
        print $matches
    }
}
# kill process
def kl [pid:int] {
    ^taskkill /F /PID $pid
}