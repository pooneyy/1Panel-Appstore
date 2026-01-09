## Introduction

authentik is an open-source Identity Provider (IdP) for modern SSO.

## Configuration and Usage Instructions

1. To start the initial setup, navigate to `http://<your server's IP or hostname>:port/if/flow/initial-setup/`

    > You will get a Not Found error if initial setup URL doesn't include the trailing forward slash /. Make sure you use the complete url (http://<your server's IP or hostname>:port/if/flow/initial-setup/) including the trailing forward slash.

2. After installing the application, you can edit `docker-compose.yml` to add other environment variables. Refer to the [documentation](https://docs.goauthentik.io/install-config/configuration/) for environment variables.

    For example
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

3. After installing the application, copy `GeoLite2-City.mmdb` and `GeoLite2-ASN.mmdb` to the `geoip` directory to enable [GeoIP](https://support.maxmind.com/knowledge-base/articles/create-a-maxmind-account) support.