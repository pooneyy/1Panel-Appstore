#!/bin/bash
set -e

# 创建数据目录并设置权限
mkdir -p data
touch data/.runner
touch data/config.yml
mkdir -p data/.cache

# 设置为 forgejo-runner 镜像中的默认非 root 用户
chown -R 1000:1000 data
chmod 775 data/.runner
chmod 775 data/.cache
chmod g+s data/.runner
chmod g+s data/.cache

# 创建自定义 docker context 指向 /var/run/docker-forgejo-runner.sock
SOCK_PATH="/var/run/docker-forgejo-runner.sock"
CONTEXT_NAME="forgejo-runner-context"

# 如果 context 已存在，则先删除
if docker context inspect "$CONTEXT_NAME" >/dev/null 2>&1; then
  docker context rm -f "$CONTEXT_NAME"
  echo "已删除旧的 Docker context: $CONTEXT_NAME"
fi

docker context create "$CONTEXT_NAME" \
  --docker "host=unix://$SOCK_PATH"

echo "✅ 初始化完成："
echo " - 已创建 ./data 并配置权限"
echo " - 已创建 Docker context: $CONTEXT_NAME -> $SOCK_PATH"
