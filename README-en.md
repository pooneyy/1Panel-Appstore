[中文](https://github.com/pooneyy/1Panel-appstore/blob/localApps/README.md) | English

* * *

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Disclaimer](#disclaimer)
  - [1. Image Container Adaptation](#1-image-container-adaptation)
  - [2. Compliance with Laws](#2-compliance-with-laws)
  - [3. Acceptance of Disclaimer](#3-acceptance-of-disclaimer)
- [1. Introduction](#1-introduction)
- [2. Usage](#2-usage)
- [3. Remarks](#3-remarks)
- [4. App Overview](#4-app-overview)
- [5. Contributors](#5-contributors)


***

## Disclaimer

### 1. Image Container Adaptation
This project specifically adapts to the `1Panel` app store for original `docker` image container operations. We do not make any explicit or implicit warranties or statements regarding the validity of any original images, and we are not responsible for any effects caused by using applications from this repository. Users undertake the risks associated with using this project on their own.

### 2. Compliance with Laws
When using this repository, users must comply with the laws and regulations of their respective countries and regions. Certain applications may be restricted by specific national laws, and users need to understand and comply with relevant legal requirements. This repository is not responsible for any consequences arising from the user's violation of laws and regulations.

### 3. Acceptance of Disclaimer
By importing and using the applications in this repository, the user signifies that they have read, understood, and accepted all the terms and conditions of this disclaimer.

Please note that this disclaimer applies only to the use of this repository and does not encompass other third-party applications or services. We are not responsible for the accuracy, completeness, reliability, or legality of third-party content linked to this repository.

Before using this repository, please ensure that you have read, understood, and accepted all the terms and conditions of this disclaimer.

***
## 1. Introduction
These are some configurations of docker applications adapted for the `1Panel` store version 2.0.

Dedicated to running various Docker applications with just one click. Enjoy convenience and efficiency without complex configurations.

### Repository Branch Description
- `localApps`：Main branch
- `config`: Configuration file branch, specifically for editing the configuration files of this repository
- `patch/*`: Used for temporary branches during editing
- `renovate/*`: Temporarily created by the renovatebot
- `script`: Branch for storing scripts

## 2. Usage

> [!TIP]
>
> The current script supports specifying the installation path for 1panel using parameters, as well as specifying the Apps to be imported. If your 1panel is installed in /opt, you just need to:
>
> ```bash
> curl -sSL https:// ...  update_local_appstore.sh | bash -s -- --1panel-path /opt --app app_name_1  --app app_name_2
> ```
>
> **app_name must be the name of the folder below the repository apps**

In the `Shell Script` task type in the `1Panel` scheduled tasks, add and execute the following command, or run the following command in the terminal:

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

Then refresh the local applications in the app store.

## 3. Remarks

**If an application is not displayed in the local app list, it means it has not been fully adapted for operation in the app store panel.**

**However, it can still be run directly in the terminal.**

> Most applications in this repository support running directly with `docker-compose up`

Taking `rustdesk` as an example:

```shell
# Enter the latest version directory of rustdesk
cd /opt/1panel/resource/apps/local/rustdesk/versions/latest/

# Copy .env.sample as .env
cp .env.sample .env

# Edit the .env file and modify the parameters
nano .env

# Start RustDesk
docker-compose up -d

# View the necessary key for connecting
cat ./data/hbbs/id_ed25519.pub

```

## 4. App Overview

![](https://github.com/pooneyy/1Panel-appstore/raw/localApps/docs/app-list.png)

## 5. Contributors

Thanks goes to these wonderful people:

[![Contributors](https://contrib.rocks/image?repo=OpenListTeam/OpenList)](https://github.com/OpenListTeam/OpenList/graphs/contributors)
