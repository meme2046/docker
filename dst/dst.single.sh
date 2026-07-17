#!/bin/bash
set -e

# ==================== 调试信息 ====================
echo "[DEBUG] ======================================="
echo "[DEBUG] 当前用户: $(whoami)"
echo "[DEBUG] 当前目录: $(pwd)"
echo "[DEBUG] 检查存档目录..."
ls -la /home/steam/dst/save/ 2> /dev/null || echo "[DEBUG] 存档目录不存在"
echo "[DEBUG] 检查 Cluster_1 目录..."
ls -la /home/steam/dst/save/Cluster_1/ 2> /dev/null || echo "[DEBUG] Cluster_1 目录不存在"
echo "[DEBUG] 检查 token 文件内容..."
cat /home/steam/dst/save/Cluster_1/cluster_token.txt 2> /dev/null || echo "[DEBUG] token 文件不存在或无法读取"
echo "[DEBUG] ======================================="
# ================================================

# 全局固定参数（与成功配置完全一致）
DST_ROOT="/home/steam/dst"
CLUSTER_NAME="Cluster_1"
UGC_PATH="/home/steam/dst/game/ugc_mods"

# 启动参数（保持与成功配置相同的顺序！）
START_ARGS=(
  -skip_update_server_mods
  -ugc_directory "$UGC_PATH"
  -persistent_storage_root "$DST_ROOT"
  -conf_dir save
  -cluster "$CLUSTER_NAME"
)

# 1. 后台启动 Master 地面分片
echo "[启动] 正在启动 Master 分片..."
./dontstarve_dedicated_server_nullrenderer_x64 "${START_ARGS[@]}" -shard Master &
MASTER_PID=$!
echo "[启动] Master 分片已启动 (PID: $MASTER_PID)"

# 等待 Master 初始化完成
sleep 20

# 2. 后台启动 Caves 洞穴分片
echo "[启动] 正在启动 Caves 分片..."
./dontstarve_dedicated_server_nullrenderer_x64 "${START_ARGS[@]}" -shard Caves &
CAVES_PID=$!
echo "[启动] Caves 分片已启动 (PID: $CAVES_PID)"

# 保持容器前台运行
echo "[启动] 双分片启动完成，保持容器运行..."
wait
