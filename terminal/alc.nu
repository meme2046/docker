def main [] {
  print "alacritty 配置"
}
# nu alc.nu setup
def "main setup" [] {
  let fp = ($env.APPDATA | path join "alacritty" "alacritty.toml")
  mkdir ($fp | path dirname)
  touch $fp
  cp --force --progress ./alacritty.toml $fp
  open --raw $fp
  # alacritty migrate
}

def "main migrate" [] {
  alacritty migrate
}
