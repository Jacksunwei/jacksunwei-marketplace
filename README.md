# Wei (Jack) Sun's Plugins

A small, opinionated marketplace of plugins by Wei (Jack) Sun. Each plugin lives in its own repo; this repo is the
index — packaged as both a **Claude Code marketplace** and a **Codex CLI marketplace**.

The plugins themselves are MCP servers and work in any MCP client (Gemini CLI, Antigravity, etc.) — see each plugin
repo's README for client-specific install instructions.

## Install (Claude Code)

```bash
/plugin marketplace add jacksunwei/jacksunwei-marketplace
/plugin install gemini-web@jacksunwei-marketplace
/plugin install telegram-buddy@jacksunwei-marketplace
```

## Install (Codex CLI)

```bash
codex plugin marketplace add Jacksunwei/jacksunwei-marketplace
```

Then open the Codex plugin directory and install **Gemini Web** from the `jacksunwei-marketplace` marketplace.

## Plugins

| Plugin                                                                       | Claude Code | Codex CLI | What it does                                                          |
| ---------------------------------------------------------------------------- | :---------: | :-------: | --------------------------------------------------------------------- |
| [`gemini-web`](https://github.com/Jacksunwei/gemini-web-mcp)                 |      ✓      |     ✓     | Gemini-powered web search, multi-URL summarization, image generation. |
| [`telegram-buddy`](https://github.com/Jacksunwei/claude-telegram-buddy)      |      ✓      |     —     | Hand off your Claude Code session from terminal to phone (and back).  |

## Prerequisites

[`uv`](https://docs.astral.sh/uv/) is required for any plugin that ships a Python MCP server — install via
[their docs](https://docs.astral.sh/uv/getting-started/installation/).

## Local development

This repo is also a workspace for editing the referenced plugin repos side-by-side. Each plugin is tracked as a git
submodule pinned to `main`:

```bash
git clone --recursive https://github.com/Jacksunwei/jacksunwei-marketplace.git
# or, if already cloned:
bin/setup                          # runs git submodule update --init --recursive

git submodule update --remote      # pull latest main for every plugin
make help                          # list common cross-repo tasks
make smoke-gemini-web
```

Each sub-directory under `plugins/` (`plugins/gemini-web-mcp/`, `plugins/claude-telegram-buddy/`) is its own
independent git repo with its own remote — `cd` into it, branch, push, PR as usual.

## License

Apache 2.0 — see [LICENSE](LICENSE).
