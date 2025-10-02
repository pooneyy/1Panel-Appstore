# 使用基于NGINX的稳定版本的Alpine Linux镜像作为基础镜像
FROM nginx:stable-alpine-slim

# 设置工作目录为/app
WORKDIR /app

# 更新包信息并安装git和coreutils软件包
RUN apk update && \
    apk add --no-cache git coreutils

# 克隆名为"picx"的GitHub仓库的"gh-pages"分支
RUN git clone -b gh-pages https://github.com/XPoet/picx

# 将entrypoint.sh脚本文件复制到工作目录/app/
COPY apps/picx/latest/entrypoint.sh /app/
# 赋予entrypoint.sh脚本文件可执行权限
RUN chmod +x /app/entrypoint.sh

# 指定要公开的端口
EXPOSE 80

# 切换工作目录至NGINX的默认网页目录
WORKDIR /usr/share/nginx/

# 定义容器启动时的默认命令，执行/app/entrypoint.sh脚本
CMD ["sh", "-c", "/app/entrypoint.sh"]
