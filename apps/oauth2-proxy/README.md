# OAuth2 Proxy

[OAuth2 Proxy](https://oauth2-proxy.github.io/oauth2-proxy/) 是一个反向代理与认证中间件，支持通过 Google、GitHub、GitLab、Keycloak、OIDC 等多种身份提供商进行 OAuth2 认证。常用于在已有 Web 服务前增加统一登录认证。

---

## 功能特性

* 支持 OAuth2 和 OpenID Connect (OIDC) 协议
* 多身份提供商支持（Google、GitHub、GitLab、Microsoft、Keycloak 等）
* 提供登录保护（适用于内部应用、管理面板等）
* 支持将认证信息传递给后端应用（Header / Cookie）
* 可与 Nginx、Traefik、Envoy 等反向代理协作使用

---

## 快速开始

### 使用 Docker

```bash
docker run -p 4180:4180 \
    -e OAUTH2_PROXY_PROVIDER=google \
    -e OAUTH2_PROXY_CLIENT_ID=<client-id> \
    -e OAUTH2_PROXY_CLIENT_SECRET=<client-secret> \
    -e OAUTH2_PROXY_COOKIE_SECRET=$(openssl rand -base64 32 | head -c 32 | base64) \
    -e OAUTH2_PROXY_REDIRECT_URL=https://your.domain.com/oauth2/callback \
    -e OAUTH2_PROXY_EMAIL_DOMAINS=* \
    quay.io/oauth2-proxy/oauth2-proxy:latest
```

容器启动后，访问 `http://localhost:4180` 即会跳转到 OAuth2 提供商登录。

---

### 使用 Helm (Kubernetes)

```bash
helm repo add oauth2-proxy https://oauth2-proxy.github.io/manifests
helm repo update
helm install oauth2-proxy/oauth2-proxy \
  --generate-name \
  --set config.clientID=<client-id> \
  --set config.clientSecret=<client-secret> \
  --set config.cookieSecret=$(openssl rand -base64 32 | head -c 32 | base64) \
  --set config.provider=google
```

---

## 配置示例

### 基本配置文件 `oauth2-proxy.cfg`

```ini
provider = "oidc"
client_id = "your-client-id"
client_secret = "your-client-secret"
redirect_url = "https://your.domain.com/oauth2/callback"
oidc_issuer_url = "https://accounts.example.com"
email_domains = ["*"]
cookie_secret = "random-cookie-secret"
```

运行：

```bash
oauth2-proxy --config ./oauth2-proxy.cfg
```

---

## Nginx 反向代理示例

```nginx
server {
    listen 443 ssl;
    server_name app.example.com;

    location / {
        proxy_pass http://127.0.0.1:4180;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

## 常用环境变量

| 变量名                          | 说明                                 |
| ---------------------------- | ---------------------------------- |
| `OAUTH2_PROXY_PROVIDER`      | 身份提供商类型，如 `google`、`github`、`oidc` |
| `OAUTH2_PROXY_CLIENT_ID`     | OAuth2 客户端 ID                      |
| `OAUTH2_PROXY_CLIENT_SECRET` | OAuth2 客户端密钥                       |
| `OAUTH2_PROXY_COOKIE_SECRET` | 随机字符串，用于加密 Cookie                  |
| `OAUTH2_PROXY_REDIRECT_URL`  | 回调地址                               |
| `OAUTH2_PROXY_EMAIL_DOMAINS` | 允许的邮箱域，`*` 表示允许所有                  |

---

## 参考资料

* [官方文档](https://oauth2-proxy.github.io/oauth2-proxy/)
* [GitHub 仓库](https://github.com/oauth2-proxy/oauth2-proxy)
