## 产品介绍

快速，简单，优雅地一键启动 LoliaFRP 内网穿透。

Lolia-FRP 是一个基于 fatedier/frp 的开源反向代理项目，支持 TCP、UDP、HTTP 和 HTTPS 协议。

## 配置和使用说明

1. 访问 [隧道管理 - Lolia FRP](https://dash.lolia.link/dash/tunnel)，创建一个隧道；

2. 获取隧道 id 与节点 token
     ![](https://im.gurl.eu.org/file/AgACAgEAAxkDAAEBsZZqulE4aMn1lRCx0S532G7hT7sCUQACPQxrG4zm2UWZdPbdDFlexAEAAwIAA3kAAz0E.png)

3. 应用支持多节点，假设有以下节点

   <table>
     <thead>
       <tr>
         <th>隧道 id</th>
         <th>节点 token</th>
       </tr>
     </thead>
     <tbody>
       <tr>
         <td>10000</td>
         <td rowspan="2">chinatelecom</td>
       </tr>
       <tr>
         <td>10001</td>
       </tr>
       <tr>
         <td>10085</td>
         <td rowspan="2">chinamobile</td>
       </tr>
       <tr>
         <td>10086</td>
       </tr>
     </tbody>
   </table>

    3.1 经由 1Panel 表单安装应用，支持同时开启同一节点下的多个隧道。

      按照以下方式填写
      ![](https://im.gurl.eu.org/file/AgACAgEAAxkDAAEBt7hq0WuutMgRF5JTHc0fzTYLrgEfBwACRg1rG8aFkEZfhu5dwsaJAwEAAwIAA3gAAz0E.png)

    3.2 如果多条隧道在多个不同的节点，需要自行修改 `docker-compose.yml`

    ```yaml
    services:
      loliacli-frpc-1panel:
        command: -t 10000,10001:chinatelecom -t 10085,10086:chinamobile
        container_name: ${CONTAINER_NAME}
    ```
