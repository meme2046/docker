const IMAGE = "registry.cn-chengdu.aliyuncs.com/jusu/cron-worker:latest"
const TEST_IMAGE = "cron-test:latest"


def main [] {
    print 'cron script'
}

def "main build" [] {
    let job_dir = "./go-job"
    let worker_dir = "./cron-worker"
    mkdir $job_dir $worker_dir

    let job_items = [comm, domain, jobs, lib, sdk, utils, types, go.mod, go.sum]
    for item in $job_items {
        cp -rv $"d:/codeup/cron/go-job/($item)" $job_dir
    }

    let worker_items = [comm, conf, types, utils, worker, go.mod, go.sum, main.go]
    for item in $worker_items {
        cp -rv $"d:/codeup/cron/cron-worker/($item)" $worker_dir
    }
    # --no-cache
    (DOCKER_BUILDKIT=0 docker build
    -t $IMAGE
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
    -e TZ=Asia/Shanghai
    --restart=always
    mysql:5.7
    # --skip-grant-tables # 这会让 MySQL 跳过权限验证,任何用户无需密码即可登录,包括 root
    --character-set-server=utf8mb4
    --collation-server=utf8mb4_general_ci)
}

def "main mongo" [] {
    (docker run -d
    --name mongo 
    -p 27017:27017
    -v c:/mongodbdata:/data/db
    -e TZ=Asia/Shanghai
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

def "main mysqldebug" [] {
    (docker run -d
    --name=debug-mysql
    -e MYSQL_ROOT_HOST=%
    -e TZ=Asia/Shanghai
    -e MYSQL_ROOT_PASSWORD="abc123"
    -p 3366:3306
    mysql:5.7)
}
# nu cron.nu mysqlbk bot_tx --cn mysql
def "main mysqlbk" [db:string="bot_tx", --cn="mysql"] {
    # --all-databases: 备份所有库(含 mysql 系统库)
    # --databases db1: 指定数据库
    # --single-transaction: InnoDB 一致性快照(避免锁表)
    # --routines --triggers --events: 包含存储过程、触发器、事件
    let fp = $"d:/.backups/mysql/($db)_(date now | format date '%Y-%m-%d_%H_%M_%S').sql"
    let container_name = $cn
    let pwd = $env.MYSQL_PASSWORD
    (docker exec $container_name mysqldump
    -u root $"-p($pwd)"
    --databases $db
    --single-transaction
    --routines --triggers --events | save $fp)
    # 复制到另外的磁盘,避免丢失
    cp $fp c:/.backups/mysql

    print $"mysqldump to ($fp)"
}
# nu cron.nu mysqlrestore d:/.db/backups/mysql/bot_tx_2026-01-05_08_46_52.sql --cn mysql
def "main mysqlrestore" [fp:string="d:/.db/backups/mysql/full_backup.sql",--cn="mysql"] {
    let pwd = $env.MYSQL_PASSWORD
    let container_name = $cn
    open $fp | docker exec -i $container_name mysql -u root $"-p($pwd)"
}

def "main env" [] {
    let env_list = ["PNPM_HOME", "DEV", "CUDA_PATH", "UV_CACHE_DIR", "HOME", "USER", "TEMP"]
    for item in $env_list {
        if $item in $env {
            print $"($item): (nu -c $'$env.($item)')"
        } else {
            print $"$env.($item) not found"
        }
    }
}

def "main test" [] {
    ^example goodbye -f xiaoming
}
