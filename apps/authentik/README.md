## 产品介绍

authentik 是一款面向现代单点登录 (SSO) 的开源身份提供商 (IdP)。

## 配置和使用说明

1. 要开始初始设置，请导航到 `http://<your server's IP or hostname>:port/if/flow/initial-setup/` 。

   > 您如果在初始设置 URL 中不包括末尾的反斜杠 Not Found ，将会收到一个 / 错误。请确保您使用包括末尾反斜杠的完整 URL `http://<your server's IP or hostname>:port/if/flow/initial-setup/` 。

2. 安装应用后，可以编辑 `docker-compose.yml` 添加其它环境变量。环境变量参考[文档](https://docs.goauthentik.io/install-config/configuration/)。

   示例
   ```yaml
    x-authentik-envs: &a1
      # Reference https://docs.goauthentik.io/install-config/configuration/
      # SMTP Host Emails are sent to
      AUTHENTIK_EMAIL__HOST: localhost
      AUTHENTIK_EMAIL__PORT: 25
      # Optionally authenticate (don't add quotation marks to your password)
      AUTHENTIK_EMAIL__USERNAME: 
      AUTHENTIK_EMAIL__PASSWORD: 
      # Use StartTLS
      AUTHENTIK_EMAIL__USE_TLS: false
      # Use SSL
      AUTHENTIK_EMAIL__USE_SSL: false
      AUTHENTIK_EMAIL__TIMEOUT: 10
      # Email address authentik will send from, should have a correct @domain
      AUTHENTIK_EMAIL__FROM: authentik@localhost
   ```

3. 安装应用后，可将 `GeoLite2-City.mmdb` 与 `GeoLite2-ASN.mmdb` 拷贝到 `geoip` 目录下以启用 [GeoIP](https://support.maxmind.com/knowledge-base/articles/create-a-maxmind-account) 支持。