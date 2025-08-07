#!/bin/bash
set -e

echo "🚀 正在初始化 Forgejo Runner 所需目录..."

# 进入项目目录
mkdir -p data
cd data

## ----------------------------
## Runner 数据目录及权限设置
## ----------------------------

mkdir -p runner-data
touch runner-data/.runner
touch runner-data/config.yml
mkdir -p runner-data/.cache

# 设置权限为 forgejo-runner 镜像中默认用户（UID 1000）
chown -R 1000:1000 runner-data
chmod 775 runner-data/.runner
chmod 775 runner-data/.cache
chmod g+s runner-data/.runner
chmod g+s runner-data/.cache

## ----------------------------
## Docker-in-Docker 数据目录
## ----------------------------

mkdir -p dind-data
echo "📦 已创建 ./data/dind-data 目录（用于持久化 dind 镜像和元数据）"

## ----------------------------
## daemon.json 镜像加速配置
## ----------------------------

if [ -f /etc/docker/daemon.json ]; then
  echo "📥 检测到宿主机的 /etc/docker/daemon.json，正在复制..."
  cp /etc/docker/daemon.json ./daemon.json
else
  echo "📄 未检测到宿主机 daemon.json，正在生成默认镜像加速配置..."
  cat > ./daemon.json <<EOF
{
  "registry-mirrors": [
    "https://docker.1panel.live",
    "https://docker.1ms.run"
  ]
}
EOF
fi

cd ..

# 设置 register.sh 可执行权限
chmod +x ./scripts/register.sh

# 完成信息
echo "✅ 初始化完成："
echo " - ./data/runner-data 已就绪并设置权限"
echo " - ./data/dind-data 创建完毕（dind 镜像缓存目录）"
echo " - ./data/daemon.json 已生成或复制"
echo " - ./scripts/register.sh 设置为可执行文件"
