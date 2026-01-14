## Introduction

A modern web music player powered by lightweight backend services, integrating multiple music aggregation interfaces, covering the entire process from search and playback to audio download.

## Features

- **Thematic Aesthetics**: Built-in light/dark modes and a glass morphism interface automatically extract colors from the current track's cover to render immersive backgrounds, delivering an engaging experience.
- **Vertical Mobile Interface**: A new vertical screen layout matches mobile gestures and screen proportions, with buttons, lists, and lyrics optimized for one-handed operation.
- **Cross-Site Music Library Search**: Switch data sources with one click, supporting paginated browsing and batch import to the playback queue.
- **Flexible Queue Management**: Add, delete, and clear operations take effect immediately and are automatically persisted to the browser's localStorage.
- **Favorites List**: Search results and playlists can be added to favorites with one click. The Favorites List features independent playback progress, playback modes, and a batch operation panel.
- **Rich Playback Modes**: Seamlessly switch between list loop, single-track loop, and shuffle play, with preferences remembered from the last session.
- **Dynamic Lyrics View**: Scrolling highlight line-by-line, auto-focus on the current line, with view temporarily locked after manual scrolling.
- **List Import/Export**: Supports unified import/export of playback queue and favorites list, enabling seamless migration or restoration of favorite songs and synchronization to the playback queue.
- **Multi-bitrate Downloads**: Select from 128K / 192K / 320K / FLAC quality options and directly obtain audio files.
- **Lightweight Backend Proxy**: Unifies and aggregates various data sources via Cloudflare Pages Functions while handling audio cross-origin requests.
- **Lock Screen Playback Controls**: Automatically displays album art and playback controls on the lock screen, allowing playback control without unlocking the device.
- **Debug Console**: Press Ctrl + D to summon a real-time log panel, making it easier to troubleshoot interface or interaction issues.