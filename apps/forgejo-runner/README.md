# Forgejo Actions Runner

**Forgejo Actions Runner** 是 Forgejo 的官方运行器组件，用于执行 CI/CD 工作流中的各类任务。它与 Forgejo Actions 系统集成，支持本地或远程运行任务，帮助用户构建自动化 DevOps 流程。

适合希望**完全自托管** CI/CD 流水线的个人或组织部署使用。

## ✨ 特性

- 与 Forgejo Actions 完全集成
- 支持自定义容器或直接在主机运行
- 多 Runner 支持并行执行
- 支持 amd64 / arm64 等架构
- 简单易用，部署轻量

## ⚙️ 快速开始（Docker 部署）

### 1. 启动 Forgejo 主服务（略）

确保 Forgejo 主程序已部署并启用了 Actions 功能。

### 2. 运行 Action Runner 容器

```bash
docker run -d --name forgejo-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /opt/runner:/data \
  codeberg.org/forgejo/runner:latest
```

### 3. 初始化注册

首次运行后，进入容器进行注册：

```bash
docker exec -it forgejo-runner forgejo-runner register
```

你需要提供：

- **Forgejo 实例 URL**（例如 `https://git.example.com`）
- **Runner Token**（从仓库或组织设置中获取）
- **运行模式**（Docker / shell 等）
- **标签**（可选，便于任务调度）

## 🔄 自动启动示例（Docker Compose）

```yaml
version: '3'
services:
  forgejo-runner:
    image: codeberg.org/forgejo/runner:latest
    container_name: forgejo-runner
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./runner-data:/data
    restart: unless-stopped
```

## 📘 文档与资源

- 项目主页：https://forgejo.org/docs/latest/admin/actions/
- 源码仓库：https://code.forgejo.org/forgejo/runner

## 🧑‍🤝‍🧑 关于 Forgejo Runner

Forgejo Runner 是社区主导的 CI 执行器，致力于提供安全、可控、可扩展的构建环境。它是 Forgejo 构建完整 DevOps 生态的重要组成部分。
