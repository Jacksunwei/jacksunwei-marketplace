# AGENTS.md

Guidance for AI coding agents (Claude Code, Codex CLI, Gemini CLI, Cursor, etc.) working in this repo.

## Repository purpose

This repo is the **index** for Wei (Jack) Sun's Claude Code plugin marketplace. It does NOT contain plugin source code —
it only declares which external plugin repos belong to the marketplace, via `.claude-plugin/marketplace.json`.

The referenced plugins are themselves MCP servers and work with any MCP client; this index just provides the
Claude Code-specific install path. Other clients (Gemini CLI, Codex CLI, Antigravity) install each plugin directly from
its own repo — see each plugin's README.

## Multi-repo workflow

Each plugin lives in its own repo on GitHub (e.g. `Jacksunwei/gemini-web-mcp`). For local development:

1. `bin/setup` clones every referenced plugin into this directory as a sibling sub-repo. Sub-repos are gitignored at the
   workspace level — they are independent git repos with their own remotes.
2. To edit a plugin: `cd <plugin-dir>`, branch + commit + push as usual.
3. To add a new plugin to the index: append a new entry to `.claude-plugin/marketplace.json` AND a new
   `clone_if_missing` line to `bin/setup` (keep the two in sync — hand-maintained).

This pattern mirrors `~/Github/jacksunwei.me`, which uses the same gitignored-sibling-clone approach (no submodules —
deliberately, for ergonomic per-repo branching).

## Adding a plugin to the index

1. Make sure the plugin's standalone repo exists and has `.claude-plugin/marketplace.json` + `.claude-plugin/plugin.json`
   at its root.
2. Add an entry to `.claude-plugin/marketplace.json`:
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
3. Add a `clone_if_missing <dir-name> <owner>/<repo>` line to `bin/setup`.
4. Add a row to the README plugin table.
5. Optionally pin a `"sha": "..."` in the marketplace entry for reproducibility (Anthropic does this for partner
   plugins).

## Common commands

```bash
bin/setup                 # clone every referenced plugin sub-repo
make help                 # list cross-repo make targets
make smoke-gemini-web     # boot the gemini-web MCP server briefly
```

## Validating changes

There is no test suite. Validate by:
1. Running `bin/setup` from a clean directory to confirm clones succeed.
2. Running `make smoke-<plugin>` for any modified plugin.
3. Installing this marketplace in Claude Code (use the absolute path to this repo:
   `/plugin marketplace add /path/to/claude-plugins`) and exercising at least one tool per plugin.
