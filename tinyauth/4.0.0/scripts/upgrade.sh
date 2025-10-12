#!/bin/bash
set -e

# 1️⃣ 确保.env存在
if [ ! -f ".env" ]; then
  echo "❌ 未找到 .env 文件"
  exit 1
fi

# 2️⃣ 读取 PANEL_TINYAUTH_PROVIDER_ID 变量
PANEL_TINYAUTH_PROVIDER_ID=$(grep '^PANEL_TINYAUTH_PROVIDER_ID=' .env | cut -d '=' -f2- | tr -d '"')

if [ -z "$PANEL_TINYAUTH_PROVIDER_ID" ]; then
  echo "❌ 未在 .env 中找到 PANEL_TINYAUTH_PROVIDER_ID"
  exit 1
fi

# 3️⃣ 生成大写版本
UPPER_ID=$(echo "$PANEL_TINYAUTH_PROVIDER_ID" | tr '[:lower:]' '[:upper:]')

# 5️⃣ 替换 docker-compose.yml 中的 PROVIDERS_PLACEHOLDER
if [ ! -f "docker-compose.yml" ]; then
  echo "❌ 未找到 docker-compose.yml 文件"
  exit 1
fi

echo "🧩 替换 docker-compose.yml 文件中的 PROVIDERS_PLACEHOLDER → PROVIDERS_${UPPER_ID}"
sed -i "s/PROVIDERS_PLACEHOLDER/PROVIDERS_${UPPER_ID}/g" docker-compose.yml

# 6️⃣ 提示完成
echo "✅ 替换完成！"
