def main [] {
    print 'pypmecli script'
}


# 本地更新覆盖clash verge自定义规则, 未使用
def "main cp" [] {
  cp --progress --force d:/github/meme2046/data/clash/direct.yaml c:/Users/me/AppData/Roaming/io.github.clash-verge-rev.clash-verge-rev/ruleset/my-direct.yaml
  cp --progress --force d:/github/meme2046/data/clash/proxy.yaml c:/Users/me/AppData/Roaming/io.github.clash-verge-rev.clash-verge-rev/ruleset/my-proxy.yaml
  cp --progress --force d:/github/meme2046/data/clash/reject.yaml c:/Users/me/AppData/Roaming/io.github.clash-verge-rev.clash-verge-rev/ruleset/my-reject.yaml
}

# 获取ClashParty(mihomo).js脚本, 并添加自定义配置
def "main getcfg" [] {
-  # https://github.com/IvanSolis1989/Smart-Config-Kit/blob/main/Clash%20Party/ClashParty(mihomo).js
  # 从 GitHub 下载 ClashParty(mihomo).js 配置文件
  let target_url = "https://github.com/IvanSolis1989/Smart-Config-Kit/raw/main/Clash%20Party/ClashParty(mihomo).js";
  let output = $"./(($target_url | url parse).path | path basename)"

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
}
