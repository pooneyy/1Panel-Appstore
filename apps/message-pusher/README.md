# Message Pusher

  > 自托管消息推送服务，支持 Web UI + 多平台推送通道。

  本项目使用 [songquanpeng/message-pusher](https://github.com/songquanpeng/message-pusher) 镜像通过 Docker Compose 快速部署，支持通过网页管理和 API 接口进行消息推送。

  ## ✨ 项目特点

  - 支持 Telegram、Bark、企业微信、Server 酱等消息推送方式
  - 提供简洁易用的 Web UI 管理界面
  - 支持用户注册、Token 管理
  - 提供 RESTful API 接口，适合自动化集成

---

  ## 📦 快速部署

  ### 1. 拉取项目

  ```bash
  git clone https://github.com/your-username/message-pusher-docker.git
  cd message-pusher-docker
  ~~~

  ### 2. 启动服务

  ```bash
  docker compose up -d
  ```

  启动成功后访问：

  ```
  http://localhost:3000
  ```

  若部署在服务器，请替换为服务器的 IP 或域名。

  ### 3. 默认配置说明

  Docker Compose 配置中：

  - **端口映射**：`3000:3000`
  - **数据挂载目录**：`./data:/data`
  - **时区设置**：`Asia/Shanghai`

------

  ## 🧾 Docker Compose 文件示例

  ```yaml
  version: '3'
  
  services:
    message-pusher:
      image: songquanpeng/message-pusher
      container_name: message-pusher
      restart: always
      ports:
        - "3000:3000"
      environment:
        - TZ=Asia/Shanghai
      volumes:
        - ./data:/data
  ```

------

  ## 🛠 更新与维护

  更新镜像并重启服务：

  ```bash
  docker compose pull
  docker compose up -d
  ```

------

  ## 🔗 官方链接

  - 官方项目主页: https://github.com/songquanpeng/message-pusher
  - 在线体验地址: [https://push.sbs](https://push.sbs/)
  - Docker Hub 镜像: https://hub.docker.com/r/songquanpeng/message-pusher

------

  ## 📄 License

  MIT License

  由 [@songquanpeng](https://github.com/songquanpeng) 开发维护。

