def main [] {
    print 'pypmecli script'
}


# 更新覆盖clash verge自定义规则
def "main cp" [] {
  cp --progress --force d:/github/meme2046/data/clash/direct.yaml c:/Users/me/AppData/Roaming/io.github.clash-verge-rev.clash-verge-rev/ruleset/my-direct.yaml
  cp --progress --force d:/github/meme2046/data/clash/proxy.yaml c:/Users/me/AppData/Roaming/io.github.clash-verge-rev.clash-verge-rev/ruleset/my-proxy.yaml
  cp --progress --force d:/github/meme2046/data/clash/reject.yaml c:/Users/me/AppData/Roaming/io.github.clash-verge-rev.clash-verge-rev/ruleset/my-reject.yaml
}