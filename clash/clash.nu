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
  
  let basename = $"(($target_url | url parse).path | path basename)";

  let output = $"./($basename)";

  print ($"Downloading from: ($target_url)")
  print ($"Downloading to: ($output)")

  rm -f $output

  http get $target_url | save --force $output
  if ($output | path exists) {
    print ($"✔ Successfully downloaded to: ($output)")
  } else {
    print "✘ Download failed!"
    return
  }

  ^me js clash $output

  cp --progress --force $output $"d:/github/meme2046/data/clash/($basename)"
}
