def main [] {
  print "alacritty 配置"
}
# nu alc.nu setup
def "main setup" [] {
  let fp = ($env.APPDATA | path join "alacritty" "alacritty.toml")
  mkdir ($fp | path dirname)
  touch $fp
  cp --force ./alacritty.toml $fp
  # open --raw $fp
  # alacritty migrate
}

def "main migrate" [] {
  alacritty migrate
}

# nord (首选)
# baitong
# dracula
# catppuccin_mocha
# zenburn
def "main theme" [theme_name: string = "nord"] {
  let target_url = $"https://fastly.jsdelivr.net/gh/alacritty/alacritty-theme@master/themes/($theme_name).toml"
  let url_data = $target_url | url parse
  let basename = $"($url_data.path | path basename)";
  let download_path = $env.PROJECT_DOCKER_DIR | path join "terminal" "alacritty-theme" $basename

  if ($download_path | path exists) {
    print "! File already exists, skipping download..."
  } else {
    print ($"Downloading from: ($target_url)")
    http get $target_url | save --force $download_path
    # print ($"✓ Successfully downloaded to: ($download_path)")
  }

  let config_path = ($env.PROJECT_DOCKER_DIR | path join "terminal" "alacritty.toml")
  if ($config_path | path exists) {
    let content = open --raw $config_path
    let new_content = $content | str replace -r '(?<prefix>\[general\][\s\S]*?import = )\[([\s\S]*?)\]' ($"$prefix[\"($download_path | path expand | str replace --all '\' '/')\"]")
    $new_content | save --force $config_path
    print ($"✓ Updated alacritty.toml import to: ($download_path)")
  } else {
    print ($"✗ Config file not found: ($config_path)")
  }

  main setup
}
