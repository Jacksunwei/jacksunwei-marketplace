# Wei (Jack) Sun's Claude Code Plugins

A small, opinionated marketplace of Claude Code plugins by Wei (Jack) Sun. Each plugin lives in its own repo; this repo
is the index.

The plugins themselves are MCP servers and work in any MCP client (Gemini CLI, Codex CLI, Antigravity, etc.) — see each
plugin repo's README for client-specific install instructions. This index marketplace is the Claude Code-specific
install path.

## Install (Claude Code)

```bash
/plugin marketplace add Jacksunwei/claude-plugins
/plugin install gemini-web@jacksunwei-claude-plugins
```

## Plugins

| Plugin                                                                   | What it does                                                          |
| ------------------------------------------------------------------------ | --------------------------------------------------------------------- |
| [`gemini-web`](https://github.com/Jacksunwei/gemini-web-mcp)             | Gemini-powered web search, multi-URL summarization, image generation. |

## Prerequisites

[`uv`](https://docs.astral.sh/uv/) is required for any plugin that ships a Python MCP server — install via
[their docs](https://docs.astral.sh/uv/getting-started/installation/).

## Local development

This repo is also a workspace for editing the referenced plugin repos side-by-side:

```bash
bin/setup        # clone every referenced plugin into this directory (gitignored)
make help        # list common cross-repo tasks
make smoke-gemini-web
```

Each cloned sub-directory (e.g. `gemini-web-mcp/`) is its own independent git repo — `cd` into it, branch, push, PR as
usual. They are gitignored at the workspace level.

## License

Apache 2.0 — see [LICENSE](LICENSE).
