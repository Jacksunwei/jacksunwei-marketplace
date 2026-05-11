.PHONY: help setup smoke-gemini-web

help:
	@awk 'BEGIN{FS=":.*##"; printf "Targets:\n"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Clone all referenced plugin sub-repos
	@bin/setup

smoke-gemini-web: ## Boot the gemini-web MCP server briefly to catch import/syntax errors
	@cd gemini-web-mcp && timeout 10 uv run --script server/server.py < /dev/null 2>&1 | head -20 || true
	@echo "✓ gemini-web smoke test complete (clean exit or timeout = OK; tracebacks = bad)"
