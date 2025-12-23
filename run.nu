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


