const IMAGE = "registry.cn-chengdu.aliyuncs.com/memeking/pymecli:latest"
const CERTBOT_CLOUDFLARE_IMAGE = "certbot/dns-cloudflare:latest"
def main [] {
    print 'pypmecli script'
}
# --no-cache
def "main build" [] {
    (DOCKER_BUILDKIT=0 docker build
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
    -e PROXY=socks5://192.168.123.7:7897
    -p 8888:80
    --restart unless-stopped
    $IMAGE
    )
}

def "main compose" [] {
    docker compose -p fast -f $"(pwd)/docker.compose.yml" up -d
}
# 生成证书
def "main certbot_gen" [--force] {
    mut args = [
        "certonly",
        "--dns-cloudflare",
        # -h # 帮助
        "-m memeking2046@gmail.com",
        "--agree-tos", # 同意协议（不弹窗）
        "--no-eff-email", # 不订阅邮件（不弹窗）
        --non-interactive # 完全静默运行(绝不提问)
        "-d meme.us.kg",
        --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini # 这个文件已在 .gitignore 忽略,不用担心泄露
        # "-d memeniu.xyz",
    ];

    if $force { $args = ($args | append "--force-renewal") }
    (docker run -it
    --rm
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

def "main debug" [] {
    (docker run -it --rm
    --name=debug-pymecli
    -v $"(pwd)/certbot/conf:/etc/letsencrypt"
    -e REDIS_PASSWORD=$env.REDIS_PASSWORD
    -e CLASH_PROXY=socks5://192.168.123.7:7897
    -p 9911:80
    $IMAGE /bin/sh)
}

def "main nginx_debug" [] {
    (docker run -d
    --name=nginx-debug
    -p 8888:80
    -p 443:443
    -v $"(pwd)/certbot/conf:/etc/letsencrypt"
    -v $"(pwd)/files/debug.nginx:/etc/nginx/nginx.conf:ro"
    nginx:alpine)
}

def "main dpgen" [] {
    docker compose -p acme-dnspod -f $"(pwd)/docker.compose.yml" up -d acme-dnspod;
    docker exec -it acme-dnspod acme.sh --issue --dns dns_dp -d api.memeniu.xyz --email meme2046@outlook.com
}

def "main cfgen" [] {
    docker compose -p acme-cloudflare -f $"(pwd)/docker.compose.yml" up -d acme-cloudflare;
    docker exec -it acme-cloudflare acme.sh --issue --dns dns_cf -d meme.us.kg --email meme2046@outlook.com
}

def "main nginx" [] {
    docker compose -p nginx-test -f $"(pwd)/docker.compose.yml" up -d nginx;
}