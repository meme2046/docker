const HOST_IP = "192.168.123.7"
const TOPIARY_PATH = "c:/.topiary"
def main [] {
  print 'my docker cli collection'
}

def "main print" [] {
  print $"($TOPIARY_PATH)/languages.ncl"
  print $"($TOPIARY_PATH)/queries/nu.scm"
}

#  从github获取config file到本地$TOPIARY_PATH
def "main cfg-pull" [] {
  mkdir $"($TOPIARY_PATH)/queries";
  # http --raw https://raw.githubusercontent.com/blindFS/topiary-nushell/main/format.nu | save --force $"($TOPIARY_PATH)/format.nu";
  http --raw https://raw.githubusercontent.com/blindFS/topiary-nushell/main/queries/nu.scm | save --force $"($TOPIARY_PATH)/queries/nu.scm";
}

def "main set-lang-cfg" [] {

  let content = '{
  languages = {
    nu = {
      extensions = ["nu"],
      grammar.source.path = "c:/.topiary/tree-sitter-nu/nu.dll",
      symbol = "tree_sitter_nu",
    },
  },
}
'

  $content | save --force --progress $"($TOPIARY_PATH)/languages.ncl"
}

def "main envset" [] {

  pwsh -Command '
  [Environment]::SetEnvironmentVariable("TOPIARY_LANGUAGE_DIR", "c:/.topiary/queries", "User")
  [Environment]::SetEnvironmentVariable("TOPIARY_CONFIG_FILE", "c:/.topiary/languages.ncl", "User")
  '

  # 删除用户变量，值设为$null
  # [Environment]::SetEnvironmentVariable("TOPIARY_LANGUAGE_DIR", $null, "User")
  # [Environment]::SetEnvironmentVariable("TOPIARY_CONFIG_FILE", $null, "User")
}
# 前置条件:
# 1. 下载: https://visualstudio.microsoft.com/zh-hans/visual-cpp-build-tools/
# 2. 选择: "Windows 11 SDK","MSVC C++ x64/x86 build tool" 安装
# ts = tree-sitter，nu = nushell，build 编译 parser
def "main ts-nu-build" [] {
  cd tree-sitter-nu
  tree-sitter build
  mkdir $"($TOPIARY_PATH)/tree-sitter-nu"
  cp nu.dll $"($TOPIARY_PATH)/tree-sitter-nu/nu.dll"
}

def "main ts-nu" [] {
  git clone git@github.com:nushell/tree-sitter-nu.git # build后这个文件夹可删除
  main ts-nu-build
}

def "main setup" [] {
  main cfg-pull
  main set-lang-cfg
  main envset
  main ts-nu
  print '✔ done'
}
