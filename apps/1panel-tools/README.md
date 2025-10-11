# 1Panel-Tools

## 概述

1Panel-Tools 是一个专门设计的工具集，旨在简化为 1Panel AppStore 创建应用程序的过程。该集合中的主要工具是 Docker Compose 到 1Panel AppStore 的转换器，它将标准的 Docker Compose 文件转换为 1Panel AppStore 所需的格式。

![1Panel-Tools](https://cdn.jsdelivr.net/gh/arch3rPro/1Panel-Tools@main/public/1Panel-Tools.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 热知识

当前这个1Panel-Appstore应用，就是用该项目创建的，俄罗斯套娃，传说中我生了我自己。

## 功能特点

- **Docker Compose 转换**：自动将 Docker Compose 文件转换为 1Panel AppStore 格式
- **参数配置**：轻松定义和管理应用程序参数
- **元数据管理**：设置应用程序名称、描述、标签和其他元数据
- **多语言支持**：配置中英文描述
- **导出功能**：下载转换后的文件，准备提交到 1Panel AppStore


## 使用方法

1. **输入 Docker Compose**：将您的 Docker Compose 文件粘贴到编辑器中
2. **配置应用程序**：设置应用程序名称、键值、描述和其他元数据
3. **定义参数**：为您的应用程序添加参数（端口、环境变量等）
4. **预览转换**：查看生成的 1Panel AppStore 文件
5. **导出**：下载转换后的文件，用于 1Panel AppStore


## 1Panel AppStore 格式

转换器生成的文件遵循 1Panel AppStore 格式：

```
├── app-key/
    ├── logo.png
    ├── data.yml
    ├── README.md
    └── version/
        ├── data.yml
        ├── docker-compose.yml
        └── scripts/
```
