# Kuno

Kuno 是一个轻量级多语言内容管理系统（CMS），采用 Go 后端和 Next.js 前端技术栈，专为创建丰富的内容生态系统而设计。

## 主要特性

- **多语言支持**: 支持 70+ 种语言
- **现代技术栈**: Go 后端 + Next.js 前端
- **响应式设计**: 支持各种屏幕尺寸
- **Markdown 编辑器**: 方便的内容编辑体验
- **深色/浅色模式**: 用户体验友好
- **管理面板**: 完整的后台管理功能
- **分类管理**: 灵活的内容分类系统
- **Docker 部署**: 一键部署，易于维护

## 部署说明

### 首次初始化

Kuno 从 1.4.7 起**不再内置默认账号**。首次访问应用会自动进入初始化向导，在向导中设置管理员用户名和密码。

向导需要填写一次性**初始化码**（防止新部署的实例被他人抢先初始化）。初始化码打印在容器日志中，可在 1Panel「容器」→ Kuno 容器 →「日志」中查看，或执行：

```bash
docker logs <容器名称> 2>&1 | grep "Setup code"
```

完成初始化前，每次重启容器都会生成新的初始化码，请使用最新的一条。

### 从 1.4.6 及更早版本升级

旧版本会自动创建使用公开默认密码的 `admin` 账号（[GHSA-p345-9r45-3529](https://github.com/xuemian168/kuno/security/advisories/GHSA-p345-9r45-3529)）。升级到 1.4.7 后首次启动时：

- 如果你有自己的管理员账号（在初始化向导中创建）：无需操作，旧的 `admin` 账号会被改为随机密码而失效。
- 如果 `admin` 是唯一的管理员且从未改过密码：新的随机密码只会在容器日志中打印一次，请用它登录后立即修改：
  ```bash
  docker logs <容器名称> 2>&1 | grep -A3 "GHSA-p345-9r45-3529"
  ```
- 如果已经改过 `admin` 的密码：不受影响。

## 维护模式和密码重置

### 恢复模式

如果您忘记了管理员密码，可以通过以下步骤重置：

1. 在 1Panel 应用管理界面中，编辑 Kuno 应用配置
2. 将 "恢复模式" 设置为 "启用"，保存并重启应用容器
3. 查看容器日志，记下被重置的管理员用户名和新的随机密码（如果日志中出现多次，以**最后一次**为准）：
   ```bash
   docker logs <容器名称> 2>&1 | grep -E "Username:|Password:"
   ```
4. 将 "恢复模式" 重新设置为 "禁用"，保存并重启应用容器（恢复模式开启期间服务不会对外提供访问）
5. 使用第 3 步的用户名和密码登录，并立即修改密码

**安全提示**: 恢复模式会把第一个管理员账号的密码重置为随机密码，只有能查看容器日志的人才能拿到。

### 数据持久化

应用会将所有数据存储在 `/app/data` 目录中，包括：
- SQLite 数据库文件
- 用户上传的文件
- 配置文件

### 环境变量说明

- `NEXT_PUBLIC_API_URL`: API 端点地址
- `DB_PATH`: SQLite 数据库路径 (默认: `/app/data/kuno.db`)
- `GIN_MODE`: Go 后端运行模式 (生产环境建议使用 `release`)
- `NODE_ENV`: Node.js 环境 (生产环境建议使用 `production`)
- `JWT_SECRET`: JWT 认证密钥 (请使用随机字符串)
- `RECOVERY_MODE`: 恢复模式 (默认: `false`，启用后启动时会把管理员密码重置为随机密码并打印在日志中)

## 使用指南

1. 部署完成后，访问应用地址，自动进入初始化向导
2. 从容器日志中复制初始化码，填写站点信息并创建管理员账号
3. 使用刚创建的管理员账号登录后台
4. 开始创建和管理内容

## 系统要求

- CPU: 1 核心
- 内存: 1GB RAM
- 存储: 10GB 可用空间
- 架构: x86_64/amd64

## 故障排除

### 安装一直处于进行中状态

如果应用在1Panel中显示"安装中"且长时间未完成，请按以下步骤排查：

**立即尝试的解决方案**：
1. **刷新页面** - 有时仅仅是界面显示问题
2. **检查网络** - 确保服务器可以访问 Docker Hub
3. **查看系统资源** - 确保有足够的磁盘空间和内存

**如果问题持续存在**：

#### 1. 检查Docker容器状态
```bash
# 查看所有容器状态
docker ps -a

# 查看Kuno相关容器
docker ps -a | grep kuno
```

#### 2. 检查容器日志
```bash
# 查看容器启动日志
docker logs <容器名称或ID>

# 实时查看日志
docker logs -f <容器名称或ID>
```

#### 3. 检查镜像拉取状态
```bash
# 查看镜像拉取进度
docker pull ictrun/kuno:latest

# 查看本地镜像
docker images | grep kuno
```

#### 4. 检查端口占用
```bash
# 检查端口是否被占用
netstat -tlnp | grep <端口号>
# 或使用
ss -tlnp | grep <端口号>
```

#### 5. 检查磁盘空间
```bash
# 检查磁盘使用情况
df -h

# 检查Docker空间使用
docker system df
```

#### 6. 常见解决方案

1. **重新安装应用**：
   - 删除应用
   - 清理残留容器：`docker container prune`
   - 重新从应用商店安装

2. **手动拉取镜像**：
   ```bash
   docker pull ictrun/kuno:latest
   ```

3. **检查网络连接**：
   - 确保服务器可以访问Docker Hub
   - 检查防火墙设置

4. **查看1Panel系统日志**：
   ```bash
   journalctl -u 1panel -f
   ```

5. **重启Docker服务**：
   ```bash
   systemctl restart docker
   ```

6. **手动验证镜像**：
   ```bash
   # 测试镜像是否可用
   docker run --rm ictrun/kuno:latest --version
   ```

7. **使用1Panel命令行工具**：
   ```bash
   # 查看1Panel应用状态
   1pctl app list
   1pctl app logs kuno
   ```

### 应用无法访问

如果应用安装成功但无法访问：

1. **检查容器是否正常运行**
   ```bash
   docker ps | grep kuno
   docker logs <容器名称>
   ```

2. **验证端口配置是否正确**
   ```bash
   netstat -tlnp | grep <端口号>
   ```

3. **检查防火墙是否开放对应端口**
   ```bash
   # CentOS/RHEL
   firewall-cmd --list-ports
   firewall-cmd --add-port=<端口号>/tcp --permanent
   
   # Ubuntu/Debian
   ufw status
   ufw allow <端口号>
   ```

4. **确认容器健康状态**
   ```bash
   docker inspect <容器名称> | grep Health -A 10
   ```

### 常见错误代码对照

- **错误代码 500**: 通常是数据库初始化问题，检查数据目录权限
- **错误代码 502**: 容器未正常启动，查看容器日志
- **连接超时**: 网络或防火墙问题，检查端口开放状态
- **镜像拉取失败**: 网络问题或镜像不存在，尝试手动拉取镜像

## 备份建议

定期备份 `data` 目录以确保数据安全。

## 更多信息

- GitHub: https://github.com/xuemian168/kuno
- 文档: https://github.com/xuemian168/kuno/blob/main/README.md