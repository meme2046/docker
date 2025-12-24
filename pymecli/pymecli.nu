const IMAGE = "registry.cn-chengdu.aliyuncs.com/jusu/pymecli:latest"

def main [] {
    print 'pypmecli script'
}

def "main build" [] {
    (docker build
    -t $IMAGE
    -f Dockerfile .)
}

def "main push" [] {
    docker push $IMAGE
}

def "main run" [] {
    (docker run -d
    --name pymecli-fast
    -v $"(pwd)/certbot/conf:/etc/letsencrypt"
    -p 8888:80
    --restart unless-stopped
    $IMAGE
    fast 0.0.0.0 --port 80
    --ssl-keyfile /etc/letsencrypt/live/meme.us.kg/privkey.pem
    --ssl-certfile /etc/letsencrypt/live/meme.us.kg/fullchain.pem
    --rule https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release
    --my-rule https://raw.githubusercontent.com/meme2046/data/refs/heads/main/clash
    --proxy socks5://192.168.123.7:7890)
}

def "main debug" [] {
    (docker run -it --rm
    --name=debug-pymecli
    $IMAGE /bin/bash)
}

def "main compose" [] {
    docker compose -p fast up -d
}