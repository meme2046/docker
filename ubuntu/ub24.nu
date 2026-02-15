const IMAGE = "registry.cn-chengdu.aliyuncs.com/memeking/ub24:latest"

def main [] {
  print 'ub24 script'
}

def "main build" [] {
  (
    docker build
    -t $IMAGE
    -f ub24.Dockerfile .
  )
}

def "main run" [] {
  (
    docker run -d --privileged
    --name=ub24
    $IMAGE
  )
}

def "main push" [] {
  docker push $IMAGE
}

def "main debug" [] {
  (
    docker run -it --rm --privileged
    --name=debug-ub24
    $IMAGE /bin/bash
  )
}
