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

def klname [name: string] {
  ^taskkill /f /im $name
  # ^taskkill /f /im java.exe
}

def ips [] {
  let ips = (
    [
      (http -H {"user-agent": "curl"} ip.sb | str trim)
      (http -H {"user-agent": "curl"} ifconfig.co | str trim)
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
  print $"(ansi yb)===== COMM: 常用路径 =====(ansi reset)"
  print $"$nu.env-path: (ansi g)($nu.env-path | str replace --all '\' '/')(ansi reset)"
  print $"$nu.config-path: (ansi g)($nu.config-path | str replace --all '\' '/')(ansi reset)"
  print $"APPDATA: (ansi g)($env.APPDATA | str replace --all '\' '/')(ansi reset)"
  print $"LOCALAPPDATA: (ansi g)($env.LOCALAPPDATA | str replace --all '\' '/')(ansi reset)"
  print $"TEMP: (ansi g)($env.TEMP | str replace --all '\' '/')(ansi reset)"
  print $"USERPROFILE: (ansi g)($env.USERPROFILE | str replace --all '\' '/')(ansi reset)"
  print $"clash-party: (ansi g)($env.APPDATA | path join mihomo-party | str replace --all '\' '/')(ansi reset)"
  print $"TOPIARY_LANGUAGE_DIR: (ansi g)($env.TOPIARY_LANGUAGE_DIR)(ansi reset)"
  print $"TOPIARY_CONFIG_FILE: (ansi g)($env.TOPIARY_CONFIG_FILE)(ansi reset)"
  print $"letsencrypt: (ansi g)d:/.letsencrypt(ansi reset)"
  print $"db_data: (ansi g)d:/.db(ansi reset)"
  print $"dotenv: (ansi g)d:/.env(ansi reset)"
  print $"天翼网盘: (ansi g)d:/.eCloud/backup(ansi reset)"
  print $"ssh: (ansi g)d:/.ssh(ansi reset)"
  print $"PROJECT_DOCKER_DIR: (ansi g)($env.PROJECT_DOCKER_DIR)(ansi reset)"
  print $"PROJECT_PYMECLI_DIR: (ansi g)($env.PROJECT_PYMECLI_DIR)(ansi reset)"
  print $"PROJECT_MEOCLI_DIR: (ansi g)($env.PROJECT_MEOCLI_DIR)(ansi reset)"
  print $'Android emulator: (ansi g)($env.LOCALAPPDATA | path join "Android/Sdk/emulator" | str replace --all '\' '/')(ansi reset)'
  print $'Android cmdline-tools: (ansi g)($"($env.LOCALAPPDATA)/Android/Sdk/cmdline-tools" | str replace --all '\' '/')(ansi reset)'
}

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
  print $"(ansi yb)===== DEMO: 打印函数传入参数 =====(ansi reset)"
  print $"示例命令: (ansi gu)show-args $nu.config-path 7 false --prefix log_ --timeout 2.5 -v(ansi reset)"
  print $"path: (ansi g)($path)(ansi reset)"
  print $"count: (ansi g)($count)(ansi reset)"
  print $"is_ok: (ansi g)($is_ok)(ansi reset)"
  print $"prefix: (ansi g)($prefix)(ansi reset)"
  print $"timeout: (ansi g)($timeout) s(ansi reset)"
  print $"开启详细日志: (ansi g)($verbose)(ansi reset)"
  print $"允许覆盖文件: (ansi g)($overwrite)(ansi reset)"
}

def show-cmd [] {
  print $"(ansi yb)===== COMM: 常用命令 =====(ansi rst)"
  print $'DEMO函数传参: (ansi gu)show-args(ansi reset)'
  print $'常用路径: (ansi gu)show-path(ansi reset)'
  print $'打印colors: (ansi gu)show-colors(ansi reset)'
  print $'将 (ansi u)python/python3(ansi rst) 软链接到python目标版本: (ansi gu)python-link 3.10(ansi reset)'
  print $'(ansi gu)docker container ls(ansi rst) 简化命令: (ansi gu)dockerls(ansi reset)'
  print ''
  print $'(ansi m)alacritty皮肤<nord为皮肤名>:(ansi rst) (ansi g)alacritty-theme nord(ansi reset)
  ㆍ皮肤列表: (ansi lu)https://github.com/alacritty/alacritty-theme/tree/master/themes(ansi reset)'
  print ''
  print $'etcd查询: (ansi g)etcdctl --endpoints="192.168.123.7:2379" get --prefix "/cron/jobs"(ansi reset)'
  print $'etcd写入: (ansi g)etcdctl --endpoints="192.168.123.7:2379" put "<your_key>" "<your_value>"(ansi reset)'
  print ''
  print $'(ansi m)需安装(ansi rst)(ansi g)`pnpm install -g meocli`(ansi reset)
  将dotenv文件转为apifox环境变量: (ansi g)me env apifox d:/.env(ansi reset)
  prettier: (ansi g)me prettier d:/.tmp/test.svg(ansi reset)
  clash规则合并: (ansi g)me js clash <原始js脚本> <我的自定义json规则>(ansi reset)'
  print ''
  print $'(ansi m)需安装(ansi rst)(ansi g)`uv tool install pymecli`(ansi reset)
  bitget现货: (ansi g)bitget spot "XAUTUSDT,BTCUSDT,ETHUSDT,FARTCOIN"(ansi reset)
  bitget合约: (ansi g)bitget mix "XAUTUSDT,BTCUSDT,ETHUSDT,FARTCOIN"(ansi reset)  
  本机IPv6地址("(非临时)"): (ansi g)util ipv6(ansi reset)
  打印时间: (ansi g)util st(ansi reset)'
  print ''
  print $'(ansi m)docker饥荒联机版(ansi rst)
  (ansi c)开服:(ansi rst) (ansi g)dst(ansi reset)
    1. 查询升级mod版本信息
    2. 生成自动安装mod配置
    3. 覆盖文件使用最新配置
    4. 拉去构建所需镜像
    5. 通过docker-compose启动dedicated server
  (ansi c)重置:(ansi rst) (ansi g)dstreset(ansi reset)
    1. 删除存档和日志, 以便使用(ansi gu)`dst`(ansi rst)命令重新开局'
}

def env-set [] {
  # 设置项目目录到环境变量方便调用
  # let base_dir = "d:/github/meme2046/docker"
  let apiversion = (docker version --format json | from json).Client.ApiVersion
  ^pwsh -Command $"
  [Environment]::SetEnvironmentVariable\('PROJECT_DOCKER_DIR', 'd:/github/meme2046/docker', 'User'\)
  [Environment]::SetEnvironmentVariable\('PROJECT_PYMECLI_DIR', 'd:/github/meme2046/pymecli', 'User'\)
  [Environment]::SetEnvironmentVariable\('PROJECT_MEOCLI_DIR', 'd:/github/meme2046/meocli', 'User'\)
  "
  # ^pwsh -Command $"[Environment]::SetEnvironmentVariable\('JAVA_HOME', '($jbr_path)', 'User'\)"
  # ^pwsh -Command $"[Environment]::SetEnvironmentVariable\('DOCKER_API_VERSION', '($apiversion)', 'User'\)"

  #   print $"PROJECT_DOCKER_DIR: (ansi g)($env.PROJECT_DOCKER_DIR)(ansi reset)
  # PROJECT_PYMECLI_DIR: (ansi g)($env.PROJECT_PYMECLI_DIR)(ansi reset)
  # PROJECT_MEOCLI_DIR: (ansi g)($env.PROJECT_MEOCLI_DIR)(ansi reset)
  # DOCKER_API_VERSION: (ansi g)($env.DOCKER_API_VERSION)(ansi reset)
  #   "
}

def env-null [name: string] {
  pwsh -Command $"[Environment]::SetEnvironmentVariable\('DOCKER_API_VERSION', $null, 'User'\)"
}

# 饥荒联机版, 启动dedicated server
def dst [] {
  cd $"($env.PROJECT_DOCKER_DIR)/dst"
  # 1. 查询升级mod版本信息 2. 生成自动安装mod配置 3. 覆盖文件使最新配置生效 4. 拉去构建所需镜像 5. 通过docker-compose启动dedicated server
  nu dst.nu single
}
# 饥荒联机版, 删除存档和日志, 使用dst命令重新开局
def dstreset [] {
  cd $"($env.PROJECT_DOCKER_DIR)/dst"
  nu dst.nu reset
}

def show-colors [] {
  print $'(ansi y)我的颜色分类:(ansi rst)
1. 链接: (ansi b)Blue <b>(ansi rst) / (ansi lu)Light blue <lu>(ansi reset)
2. 一级标题: (ansi y)Yellow <y>(ansi rst) / (ansi ly)Light yellow <ly>(ansi rst)
3. 二级标题: (ansi m)Magenta <m>(ansi rst) / (ansi lm)Light magenta <lm>(ansi rst)
4. 三级标题: (ansi c)Cyan <c>(ansi rst) / (ansi lc)Light cyan <lc>(ansi rst)
5. 命令行: (ansi g)Green <g>(ansi rst) / (ansi lg)Light green <lg>(ansi rst)
6. 错误文本: (ansi r)Red <r>(ansi rst) / (ansi lr)Light red <lr>(ansi rst)'
  print $'(ansi y)颜色展示:(ansi rst)'
  print $'|039| (ansi default)Default(ansi rst)  |049| (ansi bg_default)Default(ansi rst)  |037| (ansi w)Light gray(ansi rst)     |047| (ansi bg_w)Light gray(ansi rst)'
  print $'|030| (ansi k)Black(ansi rst)    |040| (ansi bg_k)Black(ansi rst)    |090| (ansi dgr)Dark gray(ansi rst)      |100| (ansi bg_dgr)Dark gray(ansi rst)'
  print $'|031| (ansi r)Red(ansi rst)      |041| (ansi bg_r)Red(ansi rst)      |091| (ansi lr)Light red(ansi rst)      |101| (ansi bg_lr)Light red(ansi rst)'
  print $'|032| (ansi g)Green(ansi rst)    |042| (ansi bg_g)Green(ansi rst)    |092| (ansi lg)Light green(ansi rst)    |102| (ansi bg_lg)Light green(ansi rst)'
  print $'|033| (ansi y)Yellow(ansi rst)   |043| (ansi bg_y)Yellow(ansi rst)   |093| (ansi ly)Light yellow(ansi rst)   |103| (ansi bg_ly)Light yellow(ansi rst)'
  print $'|034| (ansi b)Blue(ansi rst)     |044| (ansi bg_b)Blue(ansi rst)     |094| (ansi lu)Light blue(ansi rst)     |104| (ansi bg_lu)Light blue(ansi rst)'
  print $'|035| (ansi m)Magenta(ansi rst)  |045| (ansi bg_m)Magenta(ansi rst)  |095| (ansi lm)Light magenta(ansi rst)  |105| (ansi bg_lm)Light magenta(ansi rst)'
  print $'|036| (ansi c)Cyan(ansi rst)     |046| (ansi bg_c)Cyan(ansi rst)     |096| (ansi lc)Light cyan(ansi rst)     |106| (ansi bg_lc)Light cyan(ansi rst)'
}
# 设置alacritty皮肤
def alacritty-theme [theme_name: string = "nord"] {
  cd ($env.PROJECT_DOCKER_DIR | path join "terminal")
  nu alacritty.nu theme $theme_name
}

# 将python和python3软链接到python目标版本
def python-link [target_version: string = "3.10"] {
  let target_path = (which $'python($target_version)').path | first
  if (nullorempty $target_path) {
    print $'✗ python($target_version) not found'
    return
  }
  let py_path = $target_path | path dirname | path join "python.exe"
  let py3_path = $target_path | path dirname | path join "python3.exe"
  pwsh -Command $'
  New-Item -ItemType SymbolicLink -Path ($py_path) -Target ($target_path) -Force
  New-Item -ItemType SymbolicLink -Path ($py3_path) -Target ($target_path) -Force
  '
  print $'(ansi g)python --version:(ansi rst) (^python --version)'
  print $'(ansi g)python3 --version:(ansi rst) (^python3 --version)'
}

# docker container ls 以nushell table显示
def dockerls [] {
  # select ID Names State Status Command Image Ports
  (docker container ls --all --format json | from json -o | select ID Names State Status)
}
# 更新容器, 需要更新的容器添加以下label
# labels: [com.centurylinklabs.watchtower.enable: "true"]
def dockerup [] {
  let apiversion = (docker version --format json | from json).Client.ApiVersion
  $env.DOCKER_API_VERSION = $apiversion

  docker compose -f $"($env.PROJECT_DOCKER_DIR)/compose.yaml" pull
  docker compose -p global -f $"($env.PROJECT_DOCKER_DIR)/compose.yaml" up -d
}

# quark签到, 需环境变量:COOKIE_QUARK, 钉钉Notify: DD_BOT_TOKEN, DD_BOT_SECRET
def quark-ck [] {
  nu $"($env.PROJECT_DOCKER_DIR)/quark/quark.nu" ck
}

def android-sdk [] {
  print $'(ansi y)本机安装的Android SDK:(ansi rst)'
  ls $"($env.LOCALAPPDATA)/Android/Sdk/platforms" | get name
}

def "flutter-sdk" [] {
  print $'(ansi y)Flutter默认SDK:(ansi rst)'
  let fp = $'(which flutter | get 0 | get path | path dirname | path dirname)/packages/flutter_tools/gradle/src/main/kotlin/FlutterExtension.kt'
  print $'(ansi bu)($fp | str replace --all '\' '/')(ansi rst)'
  let content = open $fp
  print ($content | find targetSdkVersion | last)
  print ($content | find compileSdkVersion | last)
  print ($content | find minSdkVersion | last)
}

def "flutter-jbr" [] {
  flutter doctor -v | parse --regex '.*?Java binary at:\s*(.+)' | first | get capture0 | path dirname | path dirname | str replace --all '\' '/'
}

def "winnat-restart" [] {
  net stop winnat
  net start winnat
}

def "ar-ping" [] {
  tcping -4 turbo-gateway.com
  tcping -4 permagate.io
  tcping -4 ar.4everland.io
  tcping -4 arweave.net # proxy
  tcping -4 arweave.org # proxy
}

def "genkey" [] {
  (
    ^'c:/Program Files/Android/Android Studio/jbr/bin/keytool.exe'
    -genkey -v
    -keystore "d:/.google/.secret/keytool/upload-keystore.jks"
    -keyalg RSA
    -keysize 2048
    -validity 10000
    -alias xabplayer
  )
}

def "ipv6dis" [] {
  ^pwsh -Command $"
  Set-NetIPv6Protocol -RandomizeIdentifiers Disabled
  Get-NetIPv6Protocol | Select RandomizeIdentifiers,UseTemporaryAddresses
  "
  # Set-NetIPv6Protocol -RandomizeIdentifiers Enabled
}

def "mysqlbk" [] {
  cd $"($env.PROJECT_DOCKER_DIR)/cron"
  nu cron.nu mysqlbk bot_tx --cn mysql
}
