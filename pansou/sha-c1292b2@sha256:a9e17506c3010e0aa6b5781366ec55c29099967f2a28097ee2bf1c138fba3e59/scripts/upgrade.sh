#!/bin/bash

# 替换docker-compose.yml中的ghcr.io为ghcr.nju.edu.cn
echo "开始替换镜像源地址..."
if sed -i 's/ghcr.io/ghcr.nju.edu.cn/g' ./docker-compose.yml; then
    echo "成功: 已将ghcr.io替换为ghcr.nju.edu.cn"
else
    echo "错误: 替换镜像源地址失败"
    exit 1
fi
