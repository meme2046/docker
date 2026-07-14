# 脚本地址

https://github.com/IvanSolis1989/Smart-Config-Kit/tree/main/Clash%20Party

# 我的配置

1. jsdelivr cdn 规则

   https://fastly.jsdelivr.net/gh/meme2046/data@main/clash/direct.yaml  
   https://fastly.jsdelivr.net/gh/meme2046/data@main/clash/proxy.yaml  
   https://fastly.jsdelivr.net/gh/meme2046/data@main/clash/reject.yaml  
   https://fastly.jsdelivr.net/gh/meme2046/data@main/clash/round.yaml

2. github 规则

   https://raw.githubusercontent.com/meme2046/data/main/clash/direct.yaml  
   https://raw.githubusercontent.com/meme2046/data/main/clash/proxy.yaml  
   https://raw.githubusercontent.com/meme2046/data/main/clash/reject.yaml  
   https://raw.githubusercontent.com/meme2046/data/main/clash/round.yaml

3. 生成好的脚本

   https://raw.githubusercontent.com/meme2046/data/main/ClashParty(mihomo).js
   https://raw.githubusercontent.com/meme2046/data/main/ClashParty(mihomo-smart).js
   https://raw.githubusercontent.com/meme2046/data/main/clash/FlClash(mihomo).js
   https://fastly.jsdelivr.net/gh/meme2046/data@main/clash/FlClash(mihomo).js

# 脚本生成

```shell
nu clash.nu config                          # 生成配置自定义配置文件
nu clash.nu config --type clash-party-smart # smart版
```

# UI补充配置

## 操作说明

1. 默认配置文件地址: `%APPDATA%\mihomo-party\mihomo.yaml`
2. 打开配置文件, 将下方配置粘贴**覆盖** `%APPDATA%\mihomo-party\mihomo.yaml` 中的内容

```yaml
geodata-mode: true
geox-url:
  geoip: https://fastly.jsdelivr.net/gh/Loyalsoldier/geoip@release/geoip.dat
  geosite: https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat
  mmdb: https://fastly.jsdelivr.net/gh/Loyalsoldier/geoip@release/GeoLite2-ASN.mmdb
  asn: https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb
geo-auto-update: true
geo-update-interval: 24
sniffer:
  enable: true
  parse-pure-ip: true
  force-dns-mapping: true
  override-destination: true
  sniff:
    HTTP:
      ports:
        - "80"
        - 8080-8880
      override-destination: true
    TLS:
      ports:
        - "443"
        - "8443"
    QUIC:
      ports:
        - "443"
        - "8443"
        - "4433"
  skip-domain:
    - +.push.apple.com
    - +.binance.com
    - +.binancefuture.com
    - +.binance.vision
    - MIjia Cloud
  skip-dst-address:
    - 91.105.192.0/23
    - 91.108.4.0/22
    - 91.108.8.0/21
    - 91.108.16.0/21
    - 91.108.56.0/22
    - 95.161.64.0/20
    - 149.154.160.0/20
    - 185.76.151.0/24
    - 2001:67c:4e8::/48
    - 2001:b28:f23c::/47
    - 2001:b28:f23f::/48
    - 2a0a:f280:203::/48
  force-domain: []
  skip-src-address: []
```

```

```
