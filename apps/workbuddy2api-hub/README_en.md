## Risk Notice

Reverse-proxying Workbuddy carries risks of risk control and account bans. Before use, please check the [project issues](https://github.com/ardeyouxipianyi/workbuddy2api-hub/issues) for recent reports.

## Configuration and Usage Instructions

- A high-strength API Key is automatically generated at startup, written to `./accounts/settings.json`, and printed in the startup logs.
- The default panel password is `admin`. Please change it immediately after the first startup.
- After entering the container, you can reset the panel password using the following command:
```bash
python3 -c "import wb_settings; wb_settings.set_panel_password('accounts', 'your-new-password')"
```

## Product Introduction

Workbuddy2API Hub is a centralized API gateway for Workbuddy tools, designed to help developers access the various large language models offered by Workbuddy from other Agents.

## Key Features

- **OpenAI-compatible API wrapping with dual-region routing**: Provides standard endpoints such as `/v1/chat/completions`, `/v1/responses`, and `/v1/models`, with independent configuration and scheduling for the international and China editions, plus one-click egress switching from the dashboard. The model catalog is aligned with the official desktop client (excluding completion channels and dedicated-line variants, while declaring context window, maximum output, vision support, and reasoning tiers), so new upstream models enter `/v1/models` without requiring a release. Also offers experimental Anthropic Messages conversion (mapping fields such as `system`/`tool_use`/`tool_result`); because long-session cache hit rates are low and credit consumption is high, it is disabled by default and must be explicitly enabled with `WB_ENABLE_ANTHROPIC_MESSAGES=1`.

- **Multi-account pool scheduling with quota guardrails**: Derives device fingerprints via one-way hashing of account UIDs (`derive_id`), ensuring the same account does not drift and different accounts remain unlinked, reducing cross-account risk-control correlation. Provides four account-level guardrails (reserved credits, daily tokens, daily credits, and per-model daily tokens), with independent counting per account, local midnight reset, automatic account switching when limits are reached, and a 429 response when all accounts hit limits. Model cooldown throttling and pinned-address calls (`/u/<ref>/v1/...`) allow precise control over account assignment.

- **Daily automation and background scheduler**: For the China edition, automatic check-in, consecutive-login management, growth and credit task completion/claiming, and cat-travel dispatch/claiming; for the international edition, daily activity check-in. A resident scheduler runs at fixed times 09:00 & 21:00, 22:00 (token keep-alive inspection), and 01:00 (night-owl tasks), with manual immediate triggering also supported. Activity history can be filtered server-side by interval/task/result/account.

- **Web dashboard and usage analytics**: The built-in dashboard (Gateway & Accounts / Data Dashboard / Agent Configuration / Settings / Runtime Logs) provides metric cards, model performance tables, account usage pivots, request logs, and credit acquisition history; statistics can be switched by today/week/month/all/custom range. Also offers an "API-equivalent cost" estimate based on OpenRouter published pricing (input priced separately by cache hit, CNY/USD switchable, automatic pricing for new models), plus a "remaining usage estimate" inferred from limit-hit samples.

- **One-click agent configuration and multi-Key egress binding**: The dashboard can detect locally installed AI clients and rewrite their configuration in one click to point to this gateway (Claude Code via Anthropic Messages, Codex CLI via Responses, OpenCode/DSH/Crush/ZCode via OpenAI compatibility), with automatic backup before writing, byte-level restore support, and non-intrusive incremental editing; a `wb_agents.py` CLI is also provided for remote access when the client is not on the gateway host. Multiple API Keys can each be bound to an international/China egress and a restricted model whitelist, with usage attributed per Key.

- **Multi-form deployment and operations**: Windows portable package with double-click launch, macOS startup script, Docker prebuilt multi-architecture images (GHCR / Docker Hub, with one-click scripts, NAS Compose, and Watchtower auto-update), and LAN sharing mode; includes configurable items such as dashboard password (PBKDF2-SHA256 storage), request body size limit (default 16MB), self-signed certificate `WB_CA_BUNDLE`, China-edition upstream address switching, and backend model redirection.