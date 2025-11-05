#!/bin/bash
set -e

BASE_DIR="./data"
TEMP_DIR="./data_temp"
CONF_FILE_OLD="$BASE_DIR/conf.ini"
CONF_FILE_NEW="$BASE_DIR/data/conf.ini"

# 1. 如果 data_temp 存在，直接删除
if [ -d "$TEMP_DIR" ]; then
    echo "发现 $TEMP_DIR，正在删除..."
    rm -rf "$TEMP_DIR"
fi

# 2. 判断当前结构
if [ -f "$CONF_FILE_NEW" ]; then
    echo "检测到新结构 ($CONF_FILE_NEW 存在)，无需迁移。"
    exit 0
elif [ -f "$CONF_FILE_OLD" ]; then
    echo "检测到旧结构 ($CONF_FILE_OLD 存在)，开始迁移..."

    # 2.1 将 data 重命名为 data_temp
    mv "$BASE_DIR" "$TEMP_DIR"

    # 2.2 创建新的目录结构
    mkdir -p "$BASE_DIR/data" "$BASE_DIR/themes" "$BASE_DIR/static" "$BASE_DIR/backup"

    # 2.3 把旧数据移到新的 data 目录
    cp -a "$TEMP_DIR"/* "$BASE_DIR/data/" 2>/dev/null || true
    cp -a "$TEMP_DIR"/.[!.]* "$BASE_DIR/data/" 2>/dev/null || true

    echo "迁移完成！旧数据已移入 $BASE_DIR/data/ 下。"
    echo "请检查无误后再次运行脚本，以彻底删除 $TEMP_DIR"
else
    echo "未找到 $CONF_FILE_OLD 或 $CONF_FILE_NEW，无法确认目录结构，退出。"
    exit 1
fi
