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
