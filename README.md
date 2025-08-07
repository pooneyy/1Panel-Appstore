 中文 | [English](https://github.com/pooneyy/1Panel-appstore/blob/localApps/README-en.md)

* * *
## 目录

- [目录](#目录)
- [免责声明](#免责声明)
  - [1. 镜像容器适配](#1-镜像容器适配)
  - [2. 法律遵守](#2-法律遵守)
  - [3. 免责声明接受](#3-免责声明接受)
- [1. 简介](#1-简介)
- [2. 使用方式](#2-使用方式)
- [3. 备注](#3-备注)
- [4. 应用一览图](#4-应用一览图)
- [5. 致谢](#5-致谢)


***

## 免责声明

### 1. 镜像容器适配
本项目仅针对原`docker`镜像容器运行进行针对`1Panel`应用商店的适配。我们不对任何原始镜像的有效性做出任何明示或暗示的保证或声明，并且不对使用本仓库应用所造成的任何影响负责。用户在使用本项目时应自行承担风险。

### 2. 法律遵守
用户在使用本仓库时必须遵守所在国家与地区的法律法规。某些应用可能受到特定国家法律的限制，用户需自行了解并遵守相关法律要求。本仓库不对用户违反法律法规所产生的任何后果负责。

### 3. 免责声明接受
用户在导入本仓库并使用其中的应用时，即表示用户已经阅读、理解并同意接受本免责声明的所有条款和条件。

请注意，本免责声明仅针对本仓库的使用情况，并不包括其他第三方应用或服务。对于与本仓库链接的第三方内容，我们不对其准确性、完整性、可靠性或合法性负责。

在使用本仓库之前，请确保已经阅读、理解并接受了本免责声明的所有条款和条件。

***
## 1. 简介
这是一些适配`1Panel`商店`2.0`版本的docker应用配置。

致力于一键运行各种 Docker 应用。无需复杂配置，享受便利和高效。

### 本仓库分支说明
- `localApps`：主分支
- `config`：配置文件分支，专门用于编辑本仓库的配置文件
- `patch/*`：用于编辑时的临时分支
- `renovate/*`：机器人产生的临时分支
- `script`：用于存放脚本的分支

## 2. 使用方式

`1Panel`计划任务类型`Shell 脚本`的计划任务框里，添加并执行以下命令，或者终端运行以下命令，

```shell
curl -sSL https://raw.githubusercontent.com/pooneyy/1Panel-Appstore/refs/heads/script/update_local_appstore.sh | bash
```
jsdelivr
```shell
curl -sSL https://fastly.jsdelivr.net/gh/pooneyy/1Panel-Appstore@script/update_local_appstore.sh | bash
```
JSDMirror(Tencent EdgeOne)
```shell
curl -sSL https://cdn.jsdmirror.com/gh/pooneyy/1Panel-Appstore@script/update_local_appstore.sh | bash
```
gh-proxy.com(Cloudflare)
```shell
curl -sSL https://gh-proxy.com/raw.githubusercontent.com/pooneyy/1Panel-Appstore/refs/heads/script/update_local_appstore.sh | bash
```

然后应用商店刷新本地应用即可。


## 3. 备注

**未显示在本地应用列表里的，表示未完全适配应用商店面板操作**

**但是支持直接终端运行。**

> 本仓库应用基本支持直接 `docker-compose up` 运行

以`rustdesk`为例

```shell
# 进入 rustdesk 的最新版本目录
cd /opt/1panel/resource/apps/local/rustdesk/versions/latest/

# 复制 .env.sample 为 .env
cp .env.sample .env

# 编辑 .env 文件，修改参数
nano .env

# 启动 RustDesk
docker-compose up -d

# 查看连接所需密钥
cat ./data/hbbs/id_ed25519.pub

```

## 4. 应用一览图

![](https://github.com/pooneyy/1Panel-appstore/raw/localApps/docs/app-list.png)

## 5. 致谢

历史不会埋没每一个人，感谢每一位为开源做出贡献的人

[![Contributors](https://contrib.rocks/image?repo=pooneyy/1Panel-appstore)](https://github.com/pooneyy/1Panel-appstore/graphs/contributors)
