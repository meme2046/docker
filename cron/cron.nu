const IMAGE = "registry.cn-chengdu.aliyuncs.com/jusu/cron-worker:latest"
const TEST_IMAGE = "cron-test:latest"


def main [] {
    print 'cron script'
}

def "main build" [] {
    let job_dir = "./go-job"
    let worker_dir = "./cron-worker"
    mkdir $job_dir $worker_dir

    let job_items = [comm, domain, jobs, lib, sdk, utils, go.mod, go.sum]
    for item in $job_items {
        cp -rv $"d:/codeup/cron/go-job/($item)" $job_dir
    }

    let worker_items = [comm, conf, types, utils, worker, go.mod, go.sum, main.go]
    for item in $worker_items {
        cp -rv $"d:/codeup/cron/cron-worker/($item)" $worker_dir
    }
    # --no-cache
    (DOCKER_BUILDKIT=0 docker build
    -t $TEST_IMAGE
    -f build.Dockerfile .)

    rm -rp $job_dir $worker_dir
}

def "main mysql" [] {
    (docker run -d
    --name mysql57
    -p 3307:3306
    -v d:/mysql/data:/var/lib/mysql
    -e MYSQL_ROOT_HOST=%
    -e MYSQL_ROOT_PASSWORD=your_password
    -e TZ=Asia/Chongqing
    --restart=always
    mysql:5.7
    --skip-grant-tables
    --character-set-server=utf8mb4
    --collation-server=utf8mb4_general_ci)
}

def "main mongo" [] {
    (docker run -d
    --name mongo 
    -p 27017:27017
    -v c:/mongodbdata:/data/db
    -e TZ=Asia/Chongqing
    --restart=always
    mongo:latest)
}

def "main etcd-install" [] {
    # scoop install etcd -g
    # 安装nssm
    scoop install nssm 
    # 安装etcd服务 
    (nssm install EtcdService etcd --name etcd_1 
    --data-dir c:\etcd\data\etcd_1 -
    -auto-compaction-retention=1 
    --listen-client-urls http://192.168.123.7:2379 
    --advertise-client-urls http://192.168.123.7:2380)
    # 卸载服务
    # nssm remove EtcdService confirm
}

def "main cron-api" [] {
    (docker run -d 
    --name=cron-api 
    -p 8000:80
    registry.cn-chengdu.aliyuncs.com/jusu/cron-api:latest)
}

def "main cron-worker" [] {
    let v = "latest"
    print $v

    (docker run -d
    --privileged
    --name=cron-worker-1
    --restart=on-failure:3
    $"registry.cn-chengdu.aliyuncs.com/jusu/cron-worker:($v)")

    (docker run -d
    --privileged
    --name=cron-worker-2
    --restart=on-failure:3
    $"registry.cn-chengdu.aliyuncs.com/jusu/cron-worker:($v)")

    (docker run -d
    --privileged
    --name=cron-worker-3
    --restart=on-failure:3
    $"registry.cn-chengdu.aliyuncs.com/jusu/cron-worker:($v)")
}

def "main compose" [] {
    docker compose -p cron -f $"(pwd)/docker.compose.yml" up -d
}

def "main db" [] {
    # docker compose -f $"(pwd)/db.docker.compose.yml" run --rm redis
    docker compose -p db -f $"(pwd)/db.docker.compose.yml" up -d
}