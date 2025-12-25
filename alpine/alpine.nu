
const IMAGE = "registry.cn-chengdu.aliyuncs.com/jusu/alpine:latest"

def "main" [] {
    print "alpine script"
}

def "main build" [] {
    (docker build
    -t $IMAGE
    -f alpine.Dockerfile .)
}

def "main debug" [] {
    (docker run -it --rm --privileged
    --name=debug-alpine
    $IMAGE /bin/sh)
}
