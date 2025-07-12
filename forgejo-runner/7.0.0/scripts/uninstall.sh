#!/bin/bash
set -e

CONTEXT_NAME="forgejo-runner-context"
SOCK_PATH="/var/run/docker-forgejo-runner.sock"

# 删除 Docker context
if docker context inspect "$CONTEXT_NAME" >/dev/null 2>&1; then
  docker context rm -f "$CONTEXT_NAME"
  echo "🗑️ 已删除 Docker context: $CONTEXT_NAME"
else
  echo "⚠️ Docker context $CONTEXT_NAME 不存在，跳过删除。"
fi

# 删除 socket 文件（如果存在）
if [ -S "$SOCK_PATH" ]; then
  rm -f "$SOCK_PATH"
  echo "🗑️ 已删除 socket 文件: $SOCK_PATH"
else
  echo "⚠️ Socket 文件 $SOCK_PATH 不存在，跳过删除。"
fi