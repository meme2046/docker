const HOST_IP = "192.168.123.7"

def main [] {
  print 'my docker cli collection'
}
# 循环demo
def "main list" [dir_path: string = "."] {
  for d in (ls $dir_path | where type == dir) {
    print $d.name
  }
  print "----------------------------------------"
  ls $dir_path | where type == dir | each { print $in.name } | ignore
  print "----------------------------------------"
  echo hello | print $"($in) world!"
  print "----------------------------------------"
  ls $dir_path | where type == dir | each { echo $in.name }
}

def "main ts2date" [ts: string] {
  $ts | str substring 0..9 | into datetime -f "%s" | date to-timezone local | format date "%Y-%m-%d %H:%M:%S"
}
# git test
def "main git" [] {
  git ls-remote https://github.com/github/gitignore.git HEAD
}

# kill process
def kl [pid: int] {
  ^taskkill /F /PID $pid
}

def "main bkcp" [] {
  cp --progress --force d:/.backups/mysql/*.sql c:/.backups/mysql
  cp --progress --force d:/.backups/bruno/*.json c:/.backups/bruno
}

def "main pp" [num: int = 5173] {
  let netstat_result = (netstat -ano | find $num)

  print $netstat_result
}

def "main prettier" [fp: string = "./tests/test.properties"] {
  (
    prettier --config=d:/github/meme2046/docker/.vscode/.prettierrc.yaml
    --ignore-path=d:/github/meme2046/docker/.vscode/.prettierignore
    --write $fp
  )
}

def "main gencert" [] {
  (
    mkcert -cert-file d:/.letsencrypt/mkcert/cert.pem
    -key-file d:/.letsencrypt/mkcert/key.pem
    ($HOST_IP)
  )
}

def "main ips" [] {
  let ips = (
    [
      (xh -b ifconfig.co user-agent:curl | str trim)
      (xh -b ifconfig.me user-agent:curl | str trim)
      (xh -b ip.gs user-agent:curl | str trim)
      (xh -b ip.3322.net user-agent:curl | str trim)
    ] | each {|ip| $ip | str trim | str replace -a "\n" "" }
  )

  # print ($ips | uniq)
  print $"✔ IPs: ($ips)"
}

def "main uvpy" [fp: string] {
  let py = "./venv/Scripts/python.exe"
  if (not (main nullorempty (which $py))) {
    print (which $py)
    print $"✔ Using (^$py --version)"
    $env.PYTHONPATH = '.'
    $env.PYTHONIOENCODING = 'utf-8'
    print $env.PYTHONPATH
    print $env.PYTHONIOENCODING
    ^$py $fp
  } else if (not (main nullorempty (which python))) {
    print (which python)
    print $"✔ Using (^python --version)"
    ^python $fp
  } else {
    print "✘ Python not found"
  }
}

def "main nullorempty" [input: any] {
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

def "main test" [] {
  # not (main nullorempty (which $cmd_name))
  ^pnpm root -g
}

def "main confline" [line: string] {
  let fp = $nu.config-path

  mut config_list = open $fp | split row -r '\n'
  mut matched = false
  for item in $config_list {
    if ($item | str contains $line) {
      $matched = true
    }
  }

  if ($matched == false) {
    $config_list = ($config_list | append $line)
  }

  $config_list | str join "\n" | save --force $fp
  open $fp
}
