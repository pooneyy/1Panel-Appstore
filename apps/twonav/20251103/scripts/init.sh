#!/bin/sh

# 设置下载目录
download_dir="./data"

# 下载文件
wget -P "$download_dir" "https://ghproxy.com/https://github.com/tznb1/TwoNav/archive/refs/heads/master.zip"

# 解压文件
unzip -o -d "$download_dir" "$download_dir/master.zip"

# 复制文件
cp -rf "$download_dir/TwoNav-master/"* "$download_dir/"

# 删除不需要的文件和目录
rm -rf "$download_dir/TwoNav-master"
rm -rf "$download_dir/master.zip"

# 更改文件所有者
chown -R www-data "$download_dir"
