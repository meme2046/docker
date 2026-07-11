def main [] {
  print 'pypmecli script'
}

# 本地更新覆盖clash verge自定义规则, 未使用
def "main cp" [] {
  cp --progress --force d:/github/meme2046/data/clash/direct.yaml c:/Users/me/AppData/Roaming/io.github.clash-verge-rev.clash-verge-rev/ruleset/my-direct.yaml
  cp --progress --force d:/github/meme2046/data/clash/proxy.yaml c:/Users/me/AppData/Roaming/io.github.clash-verge-rev.clash-verge-rev/ruleset/my-proxy.yaml
  cp --progress --force d:/github/meme2046/data/clash/reject.yaml c:/Users/me/AppData/Roaming/io.github.clash-verge-rev.clash-verge-rev/ruleset/my-reject.yaml
}

# 获取ClashParty(mihomo).js脚本, 添加自定义配置, 并输出_update文件
def "main cfg" [--smart] {
  # 从 GitHub 下载 ClashParty(mihomo).js 配置文件
  mut target_url = "https://raw.githubusercontent.com/IvanSolis1989/Smart-Config-Kit/main/Clash%20Party/ClashParty(mihomo).js";
  if $smart {
    $target_url = "https://raw.githubusercontent.com/IvanSolis1989/Smart-Config-Kit/main/Clash%20Party/ClashParty(mihomo-smart).js";
  }

  let url_data = $target_url | url parse

  let basename = $"($url_data.path | path basename)";

  let download_path = $"./($basename)";

  print ($"Downloading from: ($target_url)")
  print ($"Downloading to: ($download_path)")

  rm -f $download_path

  http get $target_url | save --force $download_path
  if ($download_path | path exists) {
    print ($"✔ Successfully downloaded to: ($download_path)")
  } else {
    print "✘ Download failed!"
    return
  }

  ^me js clash $download_path ./custom.clash.config.json

  if $smart {
    cp --force --verbose "ClashParty(mihomo-smart)_update.js" $"d:/github/meme2046/data/clash/($basename)"
  } else {
    cp --force --verbose "ClashParty(mihomo)_update.js" $"d:/github/meme2046/data/clash/($basename)"
  }
}
