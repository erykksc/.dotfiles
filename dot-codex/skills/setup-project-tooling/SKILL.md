---
name: setup-project-tooling
description: Configure a project's mise-managed language servers and diagnostic tools, plus Neovim and agent instructions. Use when explicitly asked to set up or refresh project tooling.
---

# Set up project language and diagnostic tools

Inspect the project and configure mise so its language servers, linters, and useful diagnostic commands are available to both agents and Neovim. Use this skill only when explicitly invoked.

## Workflow

1. Inspect the project manifests, existing `mise.toml` or `.mise.toml`, lockfiles, package scripts, CI commands, Neovim project config, `AGENTS.md`, and shared mise config. Identify each language, the project's existing linters and formatters, globally available mise tools, and the canonical aggregate lint task (such as `mise run lint`).
2. Reuse project-pinned linters and formatters already declared by the project's package manager or build system. Also reuse suitable tools already available through shared mise without redeclaring them in the project. Ensure each selected linter is actually invoked by the project's aggregate lint task; if no such task exists, create a concise `lint` task that runs the existing package-manager lint scripts and selected language linters. For Go projects, include `golangci-lint run ./...` when `golangci-lint` is available; if it is not available through project or shared mise, add it to the project mise config. Add mise tools for missing language servers and useful command-line diagnostics, including tools agents can run directly. Do not duplicate tool declarations, lint commands, or existing checks.
3. For each new tool, verify its current mise backend and executable name using the mise registry and the tool's official installation documentation. Confirm that the server name and executable match `nvim-lspconfig`. Add required runtimes such as Node or Go only when the selected mise backend needs them. If mise cannot provide a needed tool, explain the gap instead of installing it with another manager.
4. Add tools to the existing project mise config, preserving its comments, settings, tasks, and unrelated tools. If there is no project config, create `mise.toml`. Follow the project's existing version-range style. If its policy is unclear, ask the user which range to use before editing; do not assume `latest`.
5. Do not create or update a mise lockfile by default. If the project already has one, preserve it and ask before changing it. Install the declared tools with `mise install`. Project owners can refresh tools within their configured ranges by running `mise upgrade` from the project directory.
6. Add project Neovim integration only when a needed server is not already enabled by the shared Neovim configuration. Use the trusted project `.nvim.lua` to enable the server with `vim.lsp.enable('server_name')`; add server-specific `vim.lsp.config` only when project settings require it. Preserve existing local config. Neovim's `exrc` trust prompt must be honored; never bypass trust.
7. Update or create a concise project `AGENTS.md` section named `Diagnostics and language tools`. List available server and diagnostic tool commands, each configured linter command, the aggregate lint task, and the project's other relevant check commands. Include `mise install` for setup and `mise upgrade` for explicitly refreshing project tools. Preserve all unrelated agent instructions.

## Constraints

- Assume the agent and Neovim are launched from a mise-activated project directory. Use normal tool commands without `mise exec` prefixes.
- Make repeated runs idempotent: do not duplicate tool declarations, lint commands, Neovim enables, or AGENTS sections; do not rewrite existing versions or lockfiles automatically.
- Keep uncommon stack servers and diagnostics project-local. Shared common servers are already declared in the user's global mise config and enabled in Neovim.
- Do not install tools globally or edit the user's dotfiles while setting up an individual project.
- Report which tools and files changed, the setup commands run, and any tool that could not be provided through mise.
