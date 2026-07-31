# ClashParty

1. mihomo-party路径: `echo $"($env.APPDATA | path join mihomo-party)"`
2. 我的配置: `./mihomo.yaml`和`./config.yaml`(内核) , 关闭ClashParty, 复制配置文件到 `%APPDATA%\mihomo-party` 覆盖即可.

# 脚本仓库

> https://github.com/IvanSolis1989/Smart-Config-Kit/tree/main/Clash%20Party

# 规则数据库

如果需要手动下载, 下载后放 `%APPDATA%\mihomo-party\work` 目录下.

1. geoip: https://fastly.jsdelivr.net/gh/Loyalsoldier/geoip@release/geoip.dat
2. mmdb: https://fastly.jsdelivr.net/gh/Loyalsoldier/geoip@release/Country.mmdb
3. asn: https://fastly.jsdelivr.net/gh/Loyalsoldier/geoip@release/GeoLite2-ASN.mmdb
4. geosite: https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat

# LightGBM 模型

如果ClashParty要使用LightGBM模型, 默认会下载文件, 如果下载失败, 可以手动下载(文件大小5MB左右):  
windows默认模型路径: `%APPDATA%\mihomo-party\work`

> https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model.bin

# 我的配置

1. 模板  
   https://raw.githubusercontent.com/meme2046/data/main/clash/template.yaml

2. 我的规则  
   https://raw.githubusercontent.com/meme2046/data/main/clash/direct.yaml  
   https://raw.githubusercontent.com/meme2046/data/main/clash/proxy.yaml  
   https://raw.githubusercontent.com/meme2046/data/main/clash/reject.yaml  
   https://raw.githubusercontent.com/meme2046/data/main/clash/round.yaml

   ***

   https://fastly.jsdelivr.net/gh/meme2046/data@main/clash/direct.yaml  
   https://fastly.jsdelivr.net/gh/meme2046/data@main/clash/proxy.yaml  
   https://fastly.jsdelivr.net/gh/meme2046/data@main/clash/reject.yaml  
   https://fastly.jsdelivr.net/gh/meme2046/data@main/clash/round.yaml

3. 生成好的脚本

   https://raw.githubusercontent.com/meme2046/data/main/clash/ClashParty(mihomo).js
   https://raw.githubusercontent.com/meme2046/data/main/clash/ClashParty(mihomo-smart).js
   https://raw.githubusercontent.com/meme2046/data/main/clash/FlClash(mihomo).js
   https://fastly.jsdelivr.net/gh/meme2046/data@main/clash/FlClash(mihomo).js

# 脚本生成

```shell
nu clash.nu config                          # 生成配置自定义配置文件
nu clash.nu config --type clash-party-smart # smart版
```
