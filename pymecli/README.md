# 七牛证书,letsencrypt

letsencrypt证书有效期只有90天，需要定期更新. 到期后, 登录七牛网站, 只需要将这两个位置的证书上传并配置下即可:

1. `d:/.letsencrypt/dnspod/memeniu.xyz`
2. `d:/.letsencrypt/dnspod/cdn.memeniu.xyz`

# mkcert本地证书

mkcert 本地证书过期时间很长(豆包说默认有825天), 可以直接使用, 生成代码:

```shell
mkcert -cert-file D:\.mkcert\cert.pem -key-file D:\.mkcert\key.pem 192.168.123.7
```

# 测试

```shell
curl https://api.memeniu.xyz:8888/echo                     # dnspod
curl --ssl-revoke-best-effort https://meme.us.kg:8888/echo # cloudflare
curl --ssl-revoke-best-effort https://192.168.123.7:8000   # local mkcert
```
