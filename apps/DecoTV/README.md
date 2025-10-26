# DecoTV

<div align="center">
  <img src="https://cdn.jsdmirror.com/gh/Decohererk/DecoTV@main/public/logo.png" alt="MoonTV Logo" width="120">
</div>

> 🎬 **DecoTV** 是一个开箱即用的、跨平台的影视聚合播放器。它基于 **Next.js 14** + **Tailwind&nbsp;CSS** + **TypeScript** 构建，支持多资源搜索、在线播放、收藏同步、播放记录、本地/云端存储，让你可以随时随地畅享海量免费影视内容。

---

### ⚠️ 重要提醒

> **注意**：部署后项目为空壳项目，无内置播放源和直播源，需要自行收集配置。  
> **免责声明**：请不要在 B 站、小红书、微信公众号、抖音、今日头条或其他中国大陆社交平台发布视频或文章宣传本项目，不授权任何"科技周刊/月刊"类项目或站点收录本项目。

## ✨ 功能特性

- 🔍 **多源聚合搜索**：内置数十个免费资源站点，一次搜索立刻返回全源结果。
- 📄 **丰富详情页**：支持剧集列表、演员、年份、简介等完整信息展示。
- ▶️ **流畅在线播放**：集成 HLS.js & VidStack。
- ❤️ **收藏 + 继续观看**：LocalStorage 存储，后续扩展 DB 存储。
- 📱 **PWA**：离线缓存、安装到桌面/主屏，移动端原生体验。
- 🌗 **响应式布局**：桌面侧边栏 + 移动底部导航，自适应各种屏幕尺寸。
- 🚀 **极简部署**：一条 Docker 命令即可将完整服务跑起来，或免费部署到 Vercel。
- 👿 **智能去广告**：自动跳过视频中的切片广告（实验性）

<details>
  <summary>点击查看项目截图</summary>
  <img src="https://cdn.jsdmirror.com/gh/Decohererk/DecoTV@main/public/screenshot1.png" alt="项目截图" style="max-width:600px">
  <img src="https://cdn.jsdmirror.com/gh/Decohererk/DecoTV@main/public/screenshot2.png" alt="项目截图" style="max-width:600px">
</details>

## 🗺 目录

- [技术栈](#技术栈)
- [部署](#部署)
- [环境变量](#环境变量)
- [配置说明](#配置说明)
- [Roadmap](#roadmap)
- [安全与隐私提醒](#安全与隐私提醒)
- [License](#license)
- [致谢](#致谢)

## 技术栈

| 分类      | 主要依赖                                                                          |
| --------- | --------------------------------------------------------------------------------- |
| 前端框架  | [Next.js 14](https://nextjs.org/) · App Router                                    |
| UI & 样式 | [Tailwind&nbsp;CSS 3](https://tailwindcss.com/)                                   |
| 语言      | TypeScript 4                                                                      |
| 播放器    | [VidStack](https://vidstack.io/) · [HLS.js](https://github.com/video-dev/hls.js/) |
| 代码质量  | ESLint · Prettier · Jest                                                          |
| 部署      | Docker · Vercel                                                                   |

## 部署

本项目**仅支持 Docker 或其他基于 Docker 的平台** 部署。

### 📦 Docker 镜像标签

DecoTV 提供以下 Docker 镜像标签：

| 标签     | 说明         | 使用场景                         |
| -------- | ------------ | -------------------------------- |
| `latest` | 最新构建版本 | 总是使用最新代码，包含所有小更新 |
| `v0.4.0` | 特定版本号   | 固定版本部署，便于版本管理和回滚 |  

## 🔄 自动更新

可借助 [watchtower](https://github.com/containrrr/watchtower) 自动更新镜像容器

dockge/komodo 等 docker compose UI 也有自动更新功能

## 环境变量

| 变量                                | 说明                               | 可选值                                                           | 默认值       |
| ----------------------------------- | ---------------------------------- | ---------------------------------------------------------------- | ------------ |
| PASSWORD                            | 实例访问密码，留空则不启用密码保护 | 任意字符串                                                       | （空）       |
| NEXT_PUBLIC_STORAGE_TYPE            | 播放记录/收藏的存储方式            | localstorage（本地浏览器存储）、database（后端数据库，暂不支持） | localstorage |
| NEXT_PUBLIC_ENABLE_BLOCKAD          | 开启智能去广告功能（实验性）       | true / false                                                     | false        |
| NEXT_PUBLIC_SEARCH_MAX_PAGE         | 搜索接口可拉取的最大页数           | 1-50                                                             | 5            |
| NEXT_PUBLIC_AGGREGATE_SEARCH_RESULT | 搜索结果默认是否按标题和年份聚合   | true / false                                                     | true         |

## 配置说明

所有可自定义项集中在根目录的 `config.json` 中：

```json
{
  "cache_time": 7200,
  "api_site": {
    "dyttzy": {
      "api": "http://caiji.dyttzyapi.com/api.php/provide/vod",
      "name": "电影天堂资源",
      "detail": "http://caiji.dyttzyapi.com"
    }
    // ...更多站点
  }
}
```

- `cache_time`：接口缓存时间（秒）。
- `api_site`：你可以增删或替换任何资源站，字段说明：
    - `key`：唯一标识，保持小写字母/数字。
    - `api`：资源站提供的 `vod` JSON API 根地址。
    - `name`：在人机界面中展示的名称。
    - `detail`：（可选）部分无法通过 API 获取剧集详情的站点，需要提供网页详情根 URL，用于爬取。
- `custom_category`：自定义分类配置，用于在导航中添加个性化的影视分类。以 type + query 作为唯一标识。支持以下字段：
  - `name`：分类显示名称（可选，如不提供则使用 query 作为显示名）
  - `type`：分类类型，支持 `movie`（电影）或 `tv`（电视剧）
  - `query`：搜索关键词，用于在豆瓣 API 中搜索相关内容

custom_category 支持的自定义分类已知如下：

- movie：热门、最新、经典、豆瓣高分、冷门佳片、华语、欧美、韩国、日本、动作、喜剧、爱情、科幻、悬疑、恐怖、治愈
- tv：热门、美剧、英剧、韩剧、日剧、国产剧、港剧、日本动画、综艺、纪录片

也可输入如 "哈利波特" 效果等同于豆瓣搜索

DecoTV 支持标准的苹果 CMS V10 API 格式。

修改后 **无需重新构建**，服务会在启动时读取一次。

## 安全与隐私提醒

### 强烈建议设置密码保护

为了您的安全和避免潜在的法律风险，我们**强烈建议**在部署时设置密码保护：

- **避免公开访问**：不设置密码的实例任何人都可以访问，可能被恶意利用
- **防范版权风险**：公开的视频搜索服务可能面临版权方的投诉举报
- **保护个人隐私**：设置密码可以限制访问范围，保护您的使用记录

### 部署建议

1. **设置环境变量 `PASSWORD`**：为您的实例设置一个强密码
2. **仅供个人使用**：请勿将您的实例链接公开分享或传播
3. **遵守当地法律**：请确保您的使用行为符合当地法律法规

### 重要声明

- 本项目仅供学习和个人使用
- 请勿将部署的实例用于商业用途或公开服务
- 如因公开分享导致的任何法律问题，用户需自行承担责任
- 项目开发者不对用户的使用行为承担任何法律责任

## License

[MIT](LICENSE) © 2025 DecoTV & Contributors

## 致谢

- [ts-nextjs-tailwind-starter](https://github.com/theodorusclarence/ts-nextjs-tailwind-starter) — 项目最初基于该脚手架。
- [LibreTV](https://github.com/LibreSpark/LibreTV) — 由此启发，站在巨人的肩膀上。
- [ArtPlayer](https://github.com/zhw2590582/ArtPlayer) — 提供强大的网页视频播放器。
- [HLS.js](https://github.com/video-dev/hls.js) — 实现 HLS 流媒体在浏览器中的播放支持。
- [Zwei](https://github.com/bestzwei) — 提供获取豆瓣数据的 cors proxy
- [CMLiussss](https://github.com/cmliu) — 提供豆瓣 CDN 服务
- 感谢所有提供免费影视接口的站点。
