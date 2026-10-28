## 风险提示

反代 Workbuddy 具有风控、封号的风险，使用前请前往[项目 issue](https://github.com/ardeyouxipianyi/workbuddy2api-hub/issues) 查看近期报告。

## 配置和使用说明

- 启动时自动生成高强度 API Key 写入 `./accounts/settings.json` 并打印在启动日志中。
- 默认的面板密码为 `admin`，请在首次启动后立即修改。
- 进入容器后使用下面的命令可以重设面板密码：
```bash
python3 -c "import wb_settings; wb_settings.set_panel_password('accounts', '你的新密码')"
```

## 产品介绍

Workbuddy2API Hub 是一个面向 Workbuddy 工具的中心化 API 接口枢纽，旨在帮助开发者在其它 Agent 中访问 Workbuddy 提供的各个大模型。

## 主要功能

- **OpenAI 兼容接口封装与双区域路由**: 提供 `/v1/chat/completions`、`/v1/responses`、`/v1/models` 等标准端点，国际版与国内版各自独立配置与调度、看板一键切换出口；模型目录对齐官方桌面端（剔除补全通道与专线变体，宣告上下文窗口、最大输出、视觉与推理档位），上游新模型无需发版即进入 `/v1/models`。另提供实验性 Anthropic Messages 转换（`system`/`tool_use`/`tool_result` 等字段映射），因长会话缓存命中率低、积分消耗高，默认禁用、需显式设置 `WB_ENABLE_ANTHROPIC_MESSAGES=1` 开启。

- **多账号池调度与限额护栏**: 以账号 UID 单向哈希派生设备指纹（`derive_id`），同一账号不漂移、不同账号互不关联，降低跨账号风控关联风险；提供四条账号级护栏（保留积分、每日 Token、每日积分、按模型每日 Token），单账号独立计数、本地 0 点解封，达额自动切号，全部账号达限时返回 429。模型冷却限流、定址调用（`/u/<ref>/v1/...`）等能力支持精确控制账号归属。

- **每日自动化与后台调度器**: 国内版自动签到、连登管家、成长与积分任务点亮领奖、猫猫旅行派出/领奖；国际版每日活跃打卡；常驻调度器按 09:00 & 21:00、22:00（Token 保活巡检）、01:00（夜猫子任务）固定整点排程，并支持手动立即触发。活动历史按区间/任务/结果/账号在服务端筛选查询。

- **Web 看板与用量分析**: 内置看板（网关与账号 / 数据看板 / 智能体配置 / 设置 / 运行日志）提供指标卡片、模型性能表、账号用量透视、请求流水与积分获取历史；统计口径可按今日/本周/本月/全部/自定义切换。另提供基于 OpenRouter 公布价的"API 等价花费"估算（输入按缓存命中拆分计价、人民币/美元可切、新模型自动取价），以及基于撞线样本反推的"剩余用量估算"。

- **智能体一键配置与多 Key 出口绑定**: 看板可检测本机已装的 AI 客户端并一键改写其配置指向本网关（Claude Code 走 Anthropic Messages、Codex CLI 走 Responses、OpenCode/DSH/Crush/ZCode 走 OpenAI 兼容），写入前自动备份、支持字节级还原、非侵入式增量编辑；另提供 `wb_agents.py` CLI供客户端不在网关本机时的远程接入。多 API Key 各自可绑定国际版/国内版出口与限定模型白名单，用量按 Key 归因。

- **多形态部署与运维**: Windows 绿色包双击即启、macOS 启动脚本、Docker 预编译双架构镜像（GHCR / Docker Hub，支持一键脚本、NAS Compose、Watchtower 自动更新）、局域网共享模式；含面板密码（PBKDF2-SHA256 存储）、请求体大小上限（默认 16MB）、自签证书 `WB_CA_BUNDLE`、国内版上游地址切换、后台模型重定向等可配置项。