def ts2date [ts: string] {
  $ts | str substring 0..9 | into datetime -f "%s" | date to-timezone local | format date "%Y-%m-%d %H:%M:%S"
}

# port scan
def pp [num: int = 5173] {
  let netstat_result = (netstat -ano | complete)
  if $netstat_result.exit_code != 0 {
    print $"Error netstat: ($netstat_result.stderr)"
    return
  }

  let matches = ($netstat_result.stdout | decode gbk | lines | where $it =~ $':($num)')
  if ($matches | is-empty) {
    print $"No process found listening on port ($num)"
  } else {
    print $matches
  }
}
# kill process
def kl [pid: int] {
  ^taskkill /F /PID $pid
}

def ips [] {
  let ips = (
    [
      (^xh -b ifconfig.co user-agent:curl | str trim)
      (^xh -b ifconfig.me user-agent:curl | str trim)
      (^xh -b ip.gs user-agent:curl | str trim)
      (^xh -b ip.3322.net user-agent:curl | str trim)
    ] | each {|ip| $ip | str trim | str replace -a "\n" "" }
  )

  # print ($ips | uniq)
  print $ips
}

def nullorempty [input: any] {
  # 判断输入是否为null或者空
  if ($input == null) {
    return true
  } else if (($input | describe) == "string") {
    return (($input | str length) == 0)
  } else if ($input | describe | str starts-with "list") {
    return (($input | length) == 0)
  } else if ($input | describe | str starts-with "record") {
    return (($input | columns | length) == 0)
  } else if ($input | describe | str starts-with "table") {
    return (($input | columns | length) == 0)
  } else {
    return false
  }
}

def uvpy [fp: string] {
  let py = "./.venv/Scripts/python.exe"
  if (not (nullorempty (which $py))) {
    print (which $py)
    print $"✔ Using (^$py --version)"
    $env.PYTHONIOENCODING = 'utf-8'
    $env.PYTHONPATH = '.'
    # $env.PYTHONIOENCODING | print
    # $env.PYTHONPATH | print
    ^$py $fp
  } else if (not (nullorempty (which python))) {
    print (which python)
    print $"✔ Using (^python --version)"
    ^python $fp
  } else {
    print "✘ Python not found"
  }
}
