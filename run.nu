def main [] {
    print 'my docker cli collection'
}

def "main pymecli-fastapi" [] {
    cd pymecli
    docker compose -p fast up -d
}

def "main ub24" [] {
    (docker run -d
    --privileged
    --name=ub24
    --restart=on-failure:3
    -p 7777:22/tcp
    registry.cn-chengdu.aliyuncs.com/jusu/ub24)
}