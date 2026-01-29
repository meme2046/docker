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

def "main lines" [] {
  let new_lines = [
    'mkdir ($nu.data-dir | path join "vendor/autoload")'
    'starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")'
  ]

  [] | append $new_lines
}

def "main ts2date" [ts: string] {
  $ts | str substring 0..9 | into datetime -f "%s" | date to-timezone local | format date "%Y-%m-%d %H:%M:%S"
}
# git test
def "main git" [] {
  git ls-remote https://github.com/github/gitignore.git HEAD
}

# ipv6 测试
# ping -6 ipv6.baidu.com
# ping -6 www.tsinghua.edu.cn

def "main killport" [num: int = 5173] {
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
# 复制备份文件到c盘,避免d盘损坏
def "main bkcp" [] {
  cp --progress --force d:/.backups/mysql/*.sql c:/.backups/mysql
  cp --progress --force d:/.backups/bruno/*.json c:/.backups/bruno
}

def "main pp" [num: int = 5173] {
  let matches = (netstat -ano | decode gbk | lines | where $it =~ $':($num)')
  if ($matches | is-empty) {
    print $"✘ No process found listening on port 『($num)』"
    return
  } else {
    print $matches
  }
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
    mkcert -cert-file d:/.mkcert/cert.pem
    -key-file d:/.mkcert/key.pem
    ::1 localhost 127.0.0.1 192.168.123.7
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

def "main test" [] {
  # not (main nullorempty (which $cmd_name))
  ^pnpm root -g
}
