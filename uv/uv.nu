const IMAGE = "registry.cn-chengdu.aliyuncs.com/jusu/uv:debian-slim"

def "main" [] {
  print "debian slim script"
}

def "main build" [] {
  (
    docker build
    -t $IMAGE
    -f uv.Dockerfile .
  )
}

def "main debug" [] {
  (
    docker run -it --rm --privileged
    --name=debug-slim
    -e REDIS_PASSWORD=$env.REDIS_PASSWORD
    -e CLASH_PROXY=socks5://192.168.123.7:7890
    $IMAGE /bin/sh
  )
}
