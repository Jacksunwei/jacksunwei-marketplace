.PHONY: help setup smoke-gemini-web bump-plugin sync-plugins plugin-status

help: ## List available targets
	@awk 'BEGIN{FS=":.*##"; printf "Targets:\n"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Init/update plugin submodules and check out main in each
	@bin/setup

smoke-gemini-web: ## Boot the gemini-web MCP server briefly to catch import/syntax errors
	@cd plugins/gemini-web-mcp && timeout 10 uv run --script server/server.py < /dev/null 2>&1 | head -20 || true
	@echo "✓ gemini-web smoke test complete (clean exit or timeout = OK; tracebacks = bad)"

bump-plugin: ## Bump recorded SHA for one plugin (usage: make bump-plugin PLUGIN=<name>)
	@if [ -z "$(PLUGIN)" ]; then echo "Usage: make bump-plugin PLUGIN=<name>" >&2; exit 1; fi
	@if [ ! -d "plugins/$(PLUGIN)" ]; then echo "✗ plugins/$(PLUGIN) does not exist" >&2; exit 1; fi
	@other=$$(git diff --cached --name-only | grep -v "^plugins/$(PLUGIN)$$" || true); \
	  if [ -n "$$other" ]; then \
	    echo "✗ other paths are already staged; bump-plugin needs a clean index:" >&2; \
	    printf "    %s\n" $$other >&2; \
	    echo "  commit or unstage those changes first." >&2; \
	    exit 1; \
	  fi
	@sha=$$(git -C plugins/$(PLUGIN) rev-parse --short HEAD); \
	  git add plugins/$(PLUGIN); \
	  git commit -m "bump $(PLUGIN) to $$sha"; \
	  echo "✓ bumped $(PLUGIN) to $$sha (push with 'git push')"

sync-plugins: ## Fast-forward all plugin submodules to upstream main and stage SHA bumps
	@bin/sync-plugins

plugin-status: ## Show per-plugin branch, ahead/behind vs origin/main, and index SHA match
	@bin/plugin-status
