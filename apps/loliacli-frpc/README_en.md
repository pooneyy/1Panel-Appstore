## Introduction

Fast, simple, and elegant one-click launch of LoliaFRP intranet penetration.

Lolia-FRP is an open-source reverse proxy project based on fatedier/frp, supporting TCP, UDP, HTTP, and HTTPS protocols.

## Configuration and Usage Instructions

1. Visit [Tunnel Management - Lolia FRP](https://dash.lolia.link/dash/tunnel) to create a tunnel;
2. Obtain the tunnel ID and node token.
     ![](https://im.gurl.eu.org/file/AgACAgEAAxkDAAEBsZZqulE4aMn1lRCx0S532G7hT7sCUQACPQxrG4zm2UWZdPbdDFlexAEAAwIAA3kAAz0E.png)
3. The application supports multiple nodes. Assume the following nodes exist:

   <table>
     <thead>
       <tr>
         <th>Tunnel ID</th>
         <th>Node token</th>
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

    3.1 Install the application via the 1Panel form. It supports enabling multiple tunnels under the same node at the same time.

    Fill in as follows:
    ![](https://im.gurl.eu.org/file/AgACAgEAAxkDAAEBt7Fq0RE-eeVVSiLqsxVQpI8kvqwtGQACaw1rG8aFiEaJynulqiLL3AEAAwIAA20AAz0E.png)

    3.2 If multiple tunnels are on different nodes, you need to modify `docker-compose.yml` yourself.

    ```yaml
    services:
      loliacli-frpc-1panel:
        command: -t 10000,10001:chinatelecom -t 10085,10086:chinamobile
        container_name: ${CONTAINER_NAME}
    ```
