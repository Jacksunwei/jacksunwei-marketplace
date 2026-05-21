# AGENTS.md

Guidance for AI coding agents (Claude Code, Codex CLI, Gemini CLI, Cursor, etc.) working in this repo.

## Repository purpose

This repo is the **index** for Wei (Jack) Sun's plugin marketplaces. It does NOT contain plugin source code — it only
declares which external plugin repos belong to the marketplace, via two parallel manifests:

- **`.claude-plugin/marketplace.json`** — Claude Code marketplace (`jacksunwei-claude-plugins`).
- **`.agents/plugins/marketplace.json`** — Codex CLI marketplace (`jacksunwei-marketplace`).

The referenced plugins are themselves MCP servers and work with any MCP client; this index provides Claude Code- and
Codex-specific install paths. Other clients (Gemini CLI, Antigravity) install each plugin directly from its own repo —
see each plugin's README.

**Codex-readiness lags Claude Code.** A plugin can only appear in the Codex marketplace if its repo ships
`.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json`, and `.mcp.json` (see `plugins/gemini-web-mcp/` as the
reference). Plugins without that packaging are Claude Code-only.

## Multi-repo workflow

Each plugin lives in its own repo on GitHub (e.g. `Jacksunwei/gemini-web-mcp`) and is tracked here as a **git
submodule** under `plugins/`, pinned to `main`. End-user installs use `ref: main` from
`.claude-plugin/marketplace.json` and always resolve to upstream latest — the submodule SHAs recorded in this repo
are a local-dev convenience so cloners get a reproducible snapshot.

### One-time setup

```bash
git clone --recursive https://github.com/Jacksunwei/claude-plugins.git
# or, if already cloned without --recursive:
bin/setup
```

`bin/setup` runs `git submodule update --init --recursive` then `git checkout main` inside each plugin so commits
won't land in detached HEAD.

### Edit a plugin and propagate the change (canonical flow)

```bash
# 1. Edit + push in the plugin repo
cd plugins/<name>
git checkout main && git pull --ff-only          # safety: ensure you're at tip
# ...edit, commit...
git push

# 2. Record the new SHA in the index
cd ../..
make bump-plugin PLUGIN=<name>                   # stages + commits the SHA bump
git push
```

### Pull every plugin to upstream latest

```bash
make sync-plugins                                # fast-forwards all submodules, stages SHA bumps
git commit -m "sync plugins"
git push
```

### Inspect state

```bash
make plugin-status                               # per-plugin: branch, ahead/behind vs origin/main, SHA-vs-index match
```

## Adding a plugin to the index

1. Make sure the plugin's standalone repo exists and has `.claude-plugin/marketplace.json` + `.claude-plugin/plugin.json`
   at its root.
2. Add an entry to `.claude-plugin/marketplace.json` (Claude Code):
   ```json
   {
     "name": "<plugin-name>",
     "source": {
       "source": "url",
       "url": "https://github.com/<owner>/<repo>.git",
       "ref": "main"
     },
     "description": "<one-line description>"
   }
   ```
3. **If the plugin is Codex-ready** (ships `.codex-plugin/plugin.json` + `.agents/plugins/marketplace.json` +
   `.mcp.json`), add a parallel entry to `.agents/plugins/marketplace.json`:
   ```json
   {
     "name": "<plugin-name>",
     "source": {
       "source": "url",
       "url": "https://github.com/<owner>/<repo>.git",
       "ref": "main"
     },
     "policy": {
       "installation": "AVAILABLE",
       "authentication": "ON_INSTALL"
     },
     "category": "<Productivity|Engineering|Research|...>"
   }
   ```
   Otherwise, leave the Codex marketplace alone and note in the README plugin table that the plugin is Claude Code-only.
4. Register the plugin repo as a submodule under `plugins/`:
   ```bash
   git submodule add -b main https://github.com/<owner>/<repo>.git plugins/<dir-name>
   ```
5. Add a row to the README plugin table (including the Claude Code / Codex CLI columns).
6. Optionally pin a `"sha": "..."` in either marketplace entry for reproducibility (Anthropic does this for partner
   plugins).

## Common commands

```bash
bin/setup                                # init submodules + checkout main in each
make help                                # list all make targets
make plugin-status                       # show per-plugin sync state
make sync-plugins                        # pull every plugin to upstream main, stage bumps
make bump-plugin PLUGIN=<name>           # commit the SHA bump for one plugin
make smoke-gemini-web                    # boot gemini-web MCP server briefly
```

## Validating changes

There is no test suite. Validate by:
1. Running `bin/setup` from a clean directory to confirm submodule init succeeds.
2. Running `make smoke-<plugin>` for any modified plugin.
3. Installing this marketplace in Claude Code (use the absolute path to this repo:
   `/plugin marketplace add /path/to/claude-plugins`) and exercising at least one tool per plugin.
4. For Codex marketplace changes: `codex plugin marketplace add /path/to/claude-plugins` and confirm the plugin appears
   in the Codex plugin directory under `jacksunwei-marketplace`.
