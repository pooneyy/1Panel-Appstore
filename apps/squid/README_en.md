## Introduction

Squid is an open-source proxy server that supports protocols such as HTTP and HTTPS. It offers extensive access control and security features, making it suitable for scenarios such as internet service providers and corporate networks.

## Features

- **Web Content Caching and Acceleration:** By caching frequently accessed web content, it significantly reduces bandwidth usage and improves client response speed, effectively lowering server load and enhancing content distribution efficiency.

- **Multi-Protocol Proxy Support:** Provides comprehensive support for mainstream network protocols such as HTTP, HTTPS, and FTP, with extensible support for protocols like ICAP and eCAP to meet diverse proxy requirements.

- **Access Control and Security Policies:** Offers flexible Access Control Lists (ACLs) and security policy configurations for content filtering, user authentication, traffic management, and network security protection.

- **Load Balancing and Server Acceleration:** Supports the construction of cache hierarchies and content clusters to enable intelligent request routing and load balancing, serving as a server accelerator to improve overall system performance.

- **Cross-Platform Operation and High Scalability:** Can run on various operating systems including Windows, Linux, and macOS, with support for enhanced functionality through plugins, authentication modules, and extension interfaces to adapt to different deployment environments.

## Configuration and Usage Instructions

1. Please enable **External access** when installing the application.
2. The container will create configuration files based on environment variables at startup. Existing configuration files will not be overwritten. Restart the container for any configuration changes to take effect.  
3. Configuring an HTTPS proxy requires an SSL certificate. When the container starts for the first time, it will generate a self‑signed X.509 certificate and private key with a validity period of 100 years. It is recommended to replace it with a server IP certificate issued by a trusted CA later.  

   - The certificate is stored as `app folder/cert/squid.crt`.

   - The private key is stored as `app folder/cert/squid.key`.

   Restart the container after replacing the certificate for the changes to take effect.
4. Add/Remove Accounts

   After entering the container, execute the following command to add an account:
   ```bash
   htpasswd -b /etc/squid/passwd <user> <password>
   ```
   After entering the container, execute the following command to remove an account:
   ```bash
   htpasswd -D /etc/squid/passwd <user>
   ```
5. Test the proxy server connection:  
   ```bash
   curl --proxy-insecure -vk -x https://<proxy-server-ip>:<proxy-port> -U <username>:<password> https://httpbin.org/get
   ```