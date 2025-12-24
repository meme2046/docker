# certbot-cloudflare 证书生成
(docker run -it --rm
--name certbot-cloudflare
-v $"(pwd)/certbot/conf:/etc/letsencrypt"
-e CF_API_TOKEN=$"($env.CF_TOKEN)"
certbot/dns-cloudflare:latest
certonly --dns-cloudflare
--email memeking2046@gmail.com --agree-tos --no-eff-email --force-renewal
-d meme.us.kg)
# 手动续期certbot-cloudflare
(docker run -it --rm
--name certbot-cloudflare-renew
-v $"(pwd)/certbot/conf:/etc/letsencrypt"
-e CF_API_TOKEN=$"($env.CF_TOKEN)"
certbot/dns-cloudflare:latest
renew --force-renewal --dns-cloudflare)

# 直接启动pymecli FastAPI
(docker run -d
--name pymecli-fast
-v $"(pwd)/certbot/conf:/etc/letsencrypt"
-p 8888:80
--restart unless-stopped
registry.cn-chengdu.aliyuncs.com/jusu/pymecli:latest
fast 0.0.0.0 --port 80
--ssl-keyfile /etc/letsencrypt/live/meme.us.kg/privkey.pem
--ssl-certfile /etc/letsencrypt/live/meme.us.kg/fullchain.pem
--rule https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release
--my-rule https://raw.githubusercontent.com/meme2046/data/refs/heads/main/clash
--proxy socks5://192.168.123.7:7890)

# 调试容器
docker compose run --rm certbot-renew sh