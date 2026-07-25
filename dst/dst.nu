const DST_IMAGE = "superjump22/dontstarvetogether:latest"
const DST_CLUSTER_PATH = "c:/.dst/save/Cluster_1"
const DST_MODS_PATH = "c:/.dst/mods"

def main [] {
  print 'dst script'
}

# 启动饥荒专服, 多容器, 包含森林和洞穴
def "main multi" [] {
  let fp = $"(pwd)/dst.multi.compose.yaml"
  main prepare $fp;
  docker compose -p dst -f $fp up -d;
}

# 启动饥荒专服, 单容器, 包含森林和洞穴
def "main single" [] {
  let fp = $"(pwd)/dst.single.compose.yaml"
  main prepare $fp
  docker compose -p dst-single -f $fp up -d
}

# 单独启动mod安装/更新
def "main dstmod" [fp: string] {
  docker compose -p dstmodupdate -f $fp run --rm mod-update
}
# 开服前准备工作, 1. 更新modoverrides.lua中客户端版本信息 2. 拉取镜像检查游戏否有更新 3. 构建镜像中间镜像
def "main prepare" [fp: string] {
  main convertup
  main modsetup
  main override
  docker compose -f $fp pull;
  docker compose -f $fp build;
}

# 更新 modoverrides.lua中(Convert client mod to server mod)中的客户端模组的version
def "main convertup" [] {
  mkdir -v $"($DST_CLUSTER_PATH)/Master"
  mkdir -v $"($DST_CLUSTER_PATH)/Caves"
  ^dst convert-update $"(pwd)/modoverrides.lua" -o $"($DST_CLUSTER_PATH)/Master/modoverrides.lua" -o $"($DST_CLUSTER_PATH)/Caves/modoverrides.lua"
}

# 设置dedicated_server_mods_setup.lua, dst启动自动更新模组会需要这个配置
def "main modsetup" [] {
  ^dst mod-setup $"(pwd)/modoverrides.lua" -o $"($DST_MODS_PATH)/dedicated_server_mods_setup.lua" -o $"($env.PROJECT_DOCKER_DIR)/dst/dedicated_server_mods_setup.lua"
}

# 复制目录中的配置文件到指定主路径下, 开服必须的文件
def "main override" [] {
  cp --force cluster.ini $"($DST_CLUSTER_PATH)/cluster.ini"
  cp --force c:/.dst/save/cluster_token.txt $"($DST_CLUSTER_PATH)/cluster_token.txt"
  cp --force c:/.dst/save/adminlist.txt $"($DST_CLUSTER_PATH)/adminlist.txt"

  cp --force master/server.ini $"($DST_CLUSTER_PATH)/Master/server.ini"
  cp --force caves/server.ini $"($DST_CLUSTER_PATH)/Caves/server.ini"

  cp --force master/leveldataoverride.lua $"($DST_CLUSTER_PATH)/Master/leveldataoverride.lua"
  cp --force caves/leveldataoverride.lua $"($DST_CLUSTER_PATH)/Caves/leveldataoverride.lua"
}

def "main reset" [] {
  main override
  # 删除备份, 删除存档
  rm --recursive --force --verbose $"($DST_CLUSTER_PATH)/Master/backup" $"($DST_CLUSTER_PATH)/Caves/backup" $"($DST_CLUSTER_PATH)/Master/save" $"($DST_CLUSTER_PATH)/Caves/save" | print --stderr
  # 删除日志
  rm --force --verbose $"($DST_CLUSTER_PATH)/Master/server_chat_log.txt" $"($DST_CLUSTER_PATH)/Caves/server_chat_log.txt" $"($DST_CLUSTER_PATH)/Master/server_log.txt" $"($DST_CLUSTER_PATH)/Caves/server_log.txt" | print --stderr
}
# 打印一些debug信息
def "main echo" [] {
  print $"($DST_MODS_PATH)/dedicated_server_mods_setup.lua"
  print $"($DST_CLUSTER_PATH)/Caves/modoverrides.lua"
  print $"($DST_CLUSTER_PATH)/Master/modoverrides.lua"
  print $"(pwd)/modoverrides.lua"
}
