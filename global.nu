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
def uvpy [
  fp?: string
  --version (-v)
] {
  let candidates = [
    "./.venv/Scripts/python.exe"
    "python3.10"
    "python"
  ]

  let found = $candidates
    | each {|cand|
      let p = which $cand
      if (not (nullorempty $p)) {
        {bin: $cand full_path: $p}
      }
    }
    | where $in != null
    | first

  if $found == null {
    print "✗ Python not found"
    return
  }

  let bin = $found.bin
  let full_path = $found.full_path

  print $full_path
  print $"✓ Using (^$bin --version)"

  if $version {
    return
  }

  with-env {
    PYTHONIOENCODING: "utf-8"
    PYTHONPATH: "."
  } {
    if $fp == null {
      ^$bin
    } else {
      # 包装成列表再展开，稳定不报错
      let cmd_args = [$fp]
      ^$bin ...$cmd_args
    }
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

def show-path [] {
  print $"(ansi p)===== COMM: 常用路径 =====(ansi reset)"
  print $"$nu.env-path: (ansi gu)($nu.env-path)(ansi reset)"
  print $"$nu.config-path: (ansi gu)($nu.config-path)(ansi reset)"
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

# show-args $nu.config-path 7 --prefix prefix_ --timeout 5 true -v
def show-args [
  path: string = $nu.config-path
  count: int = 7
  is_ok: bool = false # 普通布尔参数，调用必须显式传 true/false

  # 可选参数（带默认值）
  --prefix: string = "log_"
  --timeout: float = 2.5

  # 布尔标志参数（简写 -v，不传=false，加-v/--verbose=true）
  --verbose (-v)
  --overwrite (-o)
] {
  # 打印所有入参
  print $"(ansi p)===== DEMO: 打印函数传入参数 =====(ansi reset)"
  print $"示例命令: (ansi b)show-args $nu.config-path 7 false --prefix log_ --timeout 2.5 -v(ansi reset)"
  print $"path: (ansi gu)($path)(ansi reset)"
  print $"count: (ansi gu)($count)(ansi reset)"
  print $"is_ok: (ansi gu)($is_ok)(ansi reset)"
  print $"prefix: (ansi gu)($prefix)(ansi reset)"
  print $"timeout: (ansi gu)($timeout) s(ansi reset)"
  print $"开启详细日志: (ansi gu)($verbose)(ansi reset)"
  print $"允许覆盖文件: (ansi gu)($overwrite)(ansi reset)"
}

def show-cmd [] {
  print $"(ansi p)===== COMM: 常用命令 =====(ansi reset)"
  print $'DEMO函数传参: (ansi gu)show-args(ansi reset)'
  print $'常用路径: (ansi gu)show-path(ansi reset)'
print ''
  print $'etcd查询: (ansi gu)etcdctl --endpoints="192.168.123.7:2379" get --prefix "/cron/jobs"(ansi reset)'
  print $'etcd写入: (ansi gu)etcdctl --endpoints="192.168.123.7:2379" put "<your_key>" "<your_value>"(ansi reset)'
print ''
  print $'(ansi bb)需安装`pnpm install -g meocli`↓(ansi reset):
将dotenv文件转为apifox环境变量: (ansi gu)me env apifox d:/.env(ansi reset)
prettier: (ansi gu)me prettier d:/.tmp/test.svg(ansi reset)
clash规则合并: (ansi gu)me js clash <原始js脚本> <我的自定义json规则>(ansi reset)'
print ''
  print $'(ansi bb)需安装`uv tool install pymecli`↓(ansi reset):
bitget现货: (ansi gu)bitget spot "FARTCOIN"(ansi reset)
bitget合约: (ansi gu)bitget mix "BTCUSDT"(ansi reset)
本机IPv6地址("(非临时)"): (ansi gu)util ipv6(ansi reset)
打印时间: (ansi gu)util st(ansi reset)'
}
