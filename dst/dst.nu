const DST_IMAGE = "superjump22/dontstarvetogether:latest"

def main [] {
  print 'dst script'
}

# 启动饥荒专服, 包含森林和洞穴
def "main compose" [] {
  # 更新 modoverrides.lua中的客户端mod version
  main prepare;
  docker compose -p dontstarvetogether -f $"(pwd)/dst.compose.yaml" up -d;
}

# 只启动森林(地面)
def "main dstmaster" [] {
  docker compose -p dstmaster -f $"(pwd)/dst.compose.yaml" up -d dst-master
}
# 单独启动mod安装/更新
def "main dstmod" [] {
  docker compose -p dstmodupdate -f $"(pwd)/dst.compose.yaml" run --rm mod-update
}
#  开服前准备工作, 1. 更新modoverrides.lua中客户端版本信息 2. 拉取镜像检查游戏否有更新 3. 构建镜像中间镜像
def "main prepare" [] {
  dst convert-update d:/github/meme2046/docker/dst/modoverrides.lua -o c:/.dst/save/Cluster_1/Master/modoverrides.lua -o c:/.dst/save/Cluster_1/Caves/modoverrides.lua;
  docker compose -f $"(pwd)/dst.compose.yaml" pull;
  docker compose -f $"(pwd)/dst.compose.yaml" build;
}

# 设置dedicated_server_mods_setup.lua, dst启动自动更新模组会需要这个配置
def "main modsetup" [] {
  dst mod-setup d:/github/meme2046/docker/dst/modoverrides.lua -o c:/.dst/mods/dedicated_server_mods_setup.lua -o ./dedicated_server_mods_setup.lua
}
# 更新 modoverrides.lua中(Convert client mod to server mod)中的客户端模组的version
def "main convertup" [path = "c:/.dst/save/Cluster_1"] {
  dst convert-update d:/github/meme2046/docker/dst/modoverrides.lua -o $"($path)/Master/modoverrides.lua" -o $"($path)/Caves/modoverrides.lua";
}

# 复制目录中的配置文件到指定主路径下, 开服必须的文件
def "main override" [path = "c:/.dst/save/Cluster_1"] {
  cp --force cluster.ini $"($path)/cluster.ini"

  cp --force master/server.ini $"($path)/Master/server.ini"
  cp --force caves/server.ini $"($path)/Caves/server.ini"

  cp --force master/leveldataoverride.lua $"($path)/Master/leveldataoverride.lua"
  cp --force caves/leveldataoverride.lua $"($path)/Caves/leveldataoverride.lua"
}
