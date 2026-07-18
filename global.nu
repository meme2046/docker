def ts2date [ts: string] {
  $ts | str substring 0..9 | into datetime -f "%s" | date to-timezone local | format date "%Y-%m-%d %H:%M:%S"
}

# port scan
def pp [num: int = 5173] {
  let netstat_result = (netstat -ano | find $num)
  print $netstat_result
}

# kill process
def kl [pid: int] {
  ^taskkill /F /PID $pid
}

def ips [] {
  let ips = (
    [
      (http -H {"user-agent": "curl"} ip.sb | str trim)
      (http -H {"user-agent": "curl"} ping0.cc | str trim)
      (http ip.gs | str trim)
      (http ip.3322.net | str trim)
    ] | each {|ip| $ip | str trim | str replace -a "\n" "" }
  )

  # print ($ips | uniq)
  print $"✓ IPs: ($ips)"
}

def nullorempty [input?: any] {
  # 统一取值：有位置参数用参数，无则取管道输入
  let val = if $input == null { $in } else { $input }

  # 下面全部判断 val，不再判断 $input
  if $val == null {
    return true
  } else if (($val | describe) == "string" or ($val | describe) == "byte stream") {
    return (($val | str length) == 0)
  } else if ($val | describe | str starts-with "list") {
    return (($val | length) == 0)
  } else if ($val | describe | str starts-with "record") {
    return (($val | columns | length) == 0)
  } else if ($val | describe | str starts-with "table") {
    return (($val | columns | length) == 0)
  } else {
    return false
  }
}
# fp 传入 python 脚本路径
def uvpy [fp: string] {
  let py = "./.venv/Scripts/python.exe"
  if (not (nullorempty (which $py))) {
    print (which $py)
    print $"✓ Using (^$py --version)"
    $env.PYTHONIOENCODING = 'utf-8'
    $env.PYTHONPATH = '.'
    # $env.PYTHONIOENCODING | print
    # $env.PYTHONPATH | print
    ^$py $fp
  } else if (not (nullorempty (which python3.10))) {
    print (which python3.10)
    print $"✓ Using (^python3.10 --version)"
    ^python3.10 $fp
  } else if (not (nullorempty (which python))) {
    print (which python)
    print $"✓ Using (^python --version)"
    ^python $fp
  } else {
    print "✗ Python not found"
  }
}

# 添加一行内容,如果不存在则添加到nushell配置文件中
def appendline [fp: string line: string] {
  if (not ($fp | path exists)) {
    print "✗ File not found: $fp"
    return
  }

  let trimmed_line = $line | str trim
  let content = open --raw $fp

  if ($content | find $trimmed_line | length) == 0 {
    $"($content)\n($line)" | save --force $fp
  }
  print $"($fp):\n"
  open $fp
}

# 使用notepad++ 打开文件, 防阻塞当前进程
def npp [file: path] {
  ^start "" ^notepad++ $file
}

# wsl network模式
def wslnet [] {
  open $"($env.USERPROFILE)/.wslconfig"
}

def paths [] {
  print $"(ansi p)↓常用路径↓(ansi reset)"
  print $"APPDATA: (ansi gu)($env.APPDATA)(ansi reset)"
  print $"LOCALAPPDATA: (ansi gu)($env.LOCALAPPDATA)(ansi reset)"
  print $"USERPROFILE: (ansi gu)($env.USERPROFILE)(ansi reset)"
  print $"clash-party: (ansi gu)($env.APPDATA | path join mihomo-party)(ansi reset)"
  print $"TOPIARY_LANGUAGE_DIR: (ansi gu)($env.TOPIARY_LANGUAGE_DIR)(ansi reset)"
  print $"TOPIARY_CONFIG_FILE: (ansi gu)($env.TOPIARY_CONFIG_FILE)(ansi reset)"
  print $"letsencrypt: (ansi gu)d:/.letsencrypt(ansi reset)"
  print $"db_data: (ansi gu)d:/.db(ansi reset)"
  print $"dotenv: (ansi gu)d:/.env(ansi reset)"
  print $"天翼同步盘: (ansi gu)d:/PC(ansi reset)"
  print $"ssh: (ansi gu)d:/.ssh(ansi reset)"
}
