#!/bin/bash

# ===== 1. 定义当前应用的镜像类别 =====
# 可选值：ghcr / quay / gcr / k8s_gcr / k8s_reg
MIRROR_TYPE="ghcr"

# ===== 2. 配置文件路径 =====
CONFIG_FILE="/opt/mirror-config.env"

# ===== 3. 检查配置文件是否存在 =====
if [ ! -f "$CONFIG_FILE" ]; then
    echo "未找到配置文件 $CONFIG_FILE，跳过镜像替换步骤。"
else
    # ===== 4. 加载配置文件 =====
    set -a
    source "$CONFIG_FILE"
    set +a

    # ===== 5. 根据镜像类别获取变量 =====
    case "$MIRROR_TYPE" in
        ghcr)
            ENABLE_VAR="$GHCR_ENABLE"
            OLD_DOMAIN="ghcr.io"
            NEW_DOMAIN="$GHCR_MIRROR"
            ;;
        quay)
            ENABLE_VAR="$QUAY_ENABLE"
            OLD_DOMAIN="quay.io"
            NEW_DOMAIN="$QUAY_MIRROR"
            ;;
        gcr)
            ENABLE_VAR="$GCR_ENABLE"
            OLD_DOMAIN="gcr.io"
            NEW_DOMAIN="$GCR_MIRROR"
            ;;
        k8s_gcr)
            ENABLE_VAR="$K8S_GCR_ENABLE"
            OLD_DOMAIN="k8s.gcr.io"
            NEW_DOMAIN="$K8S_GCR_MIRROR"
            ;;
        k8s_reg)
            ENABLE_VAR="$K8S_REG_ENABLE"
            OLD_DOMAIN="registry.k8s.io"
            NEW_DOMAIN="$K8S_REG_MIRROR"
            ;;
        *)
            echo "未知的 MIRROR_TYPE: $MIRROR_TYPE"
            ;;
    esac

    # ===== 6. 检查是否启用镜像替换 =====
    if [ "$ENABLE_VAR" == "true" ]; then
        # ===== 7. 检查 docker-compose 文件 =====
        if [ -f "./docker-compose.yml" ]; then
            COMPOSE_FILE="./docker-compose.yml"
        elif [ -f "./docker-compose.yaml" ]; then
            COMPOSE_FILE="./docker-compose.yaml"
        else
            echo "未找到 docker-compose 文件，跳过替换。"
            COMPOSE_FILE=""
        fi

        # ===== 8. 执行替换 =====
        if [ -n "$COMPOSE_FILE" ]; then
            echo "开始替换 $OLD_DOMAIN -> $NEW_DOMAIN ..."
            if sed -i "s|$OLD_DOMAIN|$NEW_DOMAIN|g" "$COMPOSE_FILE"; then
                echo "成功: 已将 $OLD_DOMAIN 替换为 $NEW_DOMAIN"
            else
                echo "错误: 替换镜像源地址失败"
            fi
        fi
    else
        echo "镜像替换未启用（$MIRROR_TYPE）"
    fi
fi

# ===== 9. 后续其他步骤 =====
echo "这里执行 init.sh 的其他操作..."
