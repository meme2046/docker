const IMAGE = "registry.cn-chengdu.aliyuncs.com/jusu/pymecli:latest"
const CERTBOT_CLOUDFLARE_IMAGE = "certbot/dns-cloudflare:latest"
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
    -e PROXY=socks5://192.168.123.7:7890
    -p 8888:80
    --restart unless-stopped
    $IMAGE
    )
}

def "main debug" [] {
    (docker run -it --rm
    --name=debug-pymecli
    -v $"(pwd)/certbot/conf:/etc/letsencrypt"
    -e PROXY=socks5://192.168.123.7:7890
    -p 8888:80
    $IMAGE /bin/bash)
}

def "main compose" [] {
    docker compose -p fast -f $"(pwd)/docker-compose.yml" up -d
}
# 生成证书
def "main certbot_gen" [--force] {
    mut args = [
        "certonly",
        "--dns-cloudflare",
        "--email memeking2046@gmail.com",
        "--agree-tos",
        "--no-eff-email",
        "-d meme.us.kg",
    ];
    if $force { $args = ($args | append "--force-renewal") }
    (docker run -it --rm
    --name certbot-cloudflare
    -v $"(pwd)/certbot/conf:/etc/letsencrypt"
    -e CF_API_TOKEN=$"($env.CF_TOKEN)"
    $CERTBOT_CLOUDFLARE_IMAGE
    ...$args)
}

def "main certbot_renew" [--force] {
    mut args = ["renew", "--dns-cloudflare"] 
    if $force { $args = ($args | append "--force-renewal") }
    (docker run -it --rm
    --name certbot-cloudflare-renew
    -v $"(pwd)/certbot/conf:/etc/letsencrypt"
    -e CF_API_TOKEN=$"($env.CF_TOKEN)"
    $CERTBOT_CLOUDFLARE_IMAGE
    ...$args)
}