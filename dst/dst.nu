const DMP_IMAGE = "registry.cn-chengdu.aliyuncs.com/memeking/dmp:latest"

def main [] {
    print 'dst script'
}

def "main dmp" [] {
    docker compose -p dstmanagementplatform -f $"(pwd)/steam.dmp.compose.yaml" up -d
}

def "main dstadmingo" [] {
    docker compose -p dstadmingo -f $"(pwd)/steam.dst-admin-go.compose.yaml" up -d
}

def "main dmpbuild" [] {
    (docker build
    -t $DMP_IMAGE
    -f steam.dmp.Dockerfile .)
}

def "main dmppush" [] {
    docker push $DMP_IMAGE
}

# 完整启动饥荒转服, 包含森林和洞穴
def "main dst" [] {
    docker compose -p dontstarvetogether -f $"(pwd)/dst.compose.yaml" up -d
}

# 只启动dst-master
def "main dstmaster" [] {
    docker compose -p dstmaster -f $"(pwd)/dst.compose.yaml" up -d dst-master
}
# mod安装/更新
def "main dstmod" [] {
    docker compose -p dstmodupdate -f $"(pwd)/dst.compose.yaml" run --rm mod-update
}

# 镜像更新
def "main dstimage" [] {
    if (docker images -q --filter "reference=*dst-master" | lines | is-empty) {
        print $"No image to remove"
    } else {
        docker images -q --filter "reference=*dst-master" | lines | docker rmi -f ...$in
    }
    docker compose -f $"(pwd)/dst.compose.yaml" pull
    docker compose -f $"(pwd)/dst.compose.yaml" build
}

# udp测试

def "main udp" [] {
    nc -zu 125.80.87.239 10999
    $env.LAST_EXIT_CODE
}