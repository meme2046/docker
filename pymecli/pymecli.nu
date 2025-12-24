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