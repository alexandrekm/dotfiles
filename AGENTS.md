# Agents Guide for Configuration

This file defines how agents should act when the user requests changes to the computer configuration.

## Mental Model

Configuration files live at their **canonical system paths** and are tracked in-place by **yadm**. Edit them directly (e.g. `~/.zshrc`). The user pushes changes manually via `yadm commit` / `yadm push` — agents do not need to run yadm commands.

The repo at `~/code/dotfiles` is **only relevant when a new tool is being added** and needs bootstrap support for fresh machine setup. In that case, edit the relevant script under `~/code/dotfiles/.config/yadm/bootstrap_scripts/`.

## Documentation

When documentation needs to be created or updated, save it to `~/code/dotfiles/docs/`.

## ZSH Configuration

| File | Purpose |
|------|---------|
| `~/.zshrc` | Main shell config — cross-platform |
| `~/.zshrc.os##os.Darwin` | macOS-specific overrides |
| `~/.zshrc.os##os.Linux` | Linux-specific overrides |
| `~/.zsh_plugins.txt` | Antidote plugin list |

**Editing:** Use `~/.zshrc` for cross-platform changes. Use the OS-specific file for platform-only settings.

**Testing:** Always test after every change:

```bash
source ~/.zshrc
```

**Bootstrap:** When adding a new tool that requires installation, also update:
`~/code/dotfiles/.config/yadm/bootstrap_scripts/packages/setup`

## Neovim Configuration

| File/Dir | Purpose |
|----------|---------|
| `~/.config/nvim/init.lua` | Entry point — bootstraps lazy.nvim and loads core/plugins |
| `~/.config/nvim/lua/core/options.lua` | Editor options (tab width, line numbers, etc.) |
| `~/.config/nvim/lua/core/keymaps.lua` | Key mappings |
| `~/.config/nvim/lua/core/configs/` | Core plugin configs (e.g. LSP, treesitter) |
| `~/.config/nvim/lua/plugins/` | Plugin specs loaded by lazy.nvim |
| `~/.config/nvim/lazy-lock.json` | Plugin version lockfile — do not edit manually |

**Editing:** Add new plugins as `.lua` files in `lua/plugins/`. Extend keymaps in `lua/core/keymaps.lua`. Tweak editor behaviour in `lua/core/options.lua`.

**Testing:** After changes, verify the config loads cleanly:

```bash
nvim --headless +checkhealth +qa 2>&1 | head -40
```

Or open Neovim and run `:checkhealth` interactively.

**Bootstrap:** When adding plugins that require system dependencies (e.g. language servers, linters), also update:
`~/code/dotfiles/.config/yadm/bootstrap_scripts/packages/setup`

## OpenCode Configuration

`~/.config/opencode` is a **symlink** to a machine-specific directory (`opencode-work` or `opencode-personal`). Always edit via the symlink path.

| File/Dir | Purpose |
|----------|---------|
| `~/.config/opencode/opencode.jsonc` | Main config — models, MCP servers, provider settings |
| `~/.config/opencode/command/` | Custom slash commands (`.md` files) |
| `~/.config/opencode/skills/` | Skills available to agents, organized by category |
| `~/.config/opencode/skills/superpowers/` | Core workflow skills (brainstorming, debugging, TDD, etc.) |
| `~/.config/opencode/skills/motive/` | Work-specific skills (PRs, Jira, Datadog, etc.) — work only |
| `~/.config/opencode/skills/gws/` | Google Workspace skills (Gmail, Sheets, etc.) — work only |
| `~/.config/opencode/plugins/` | JS plugins (e.g. `superpowers.js`) — work only |
| `~/.config/opencode/tui.json` | TUI layout/theme settings |

**work vs personal:** `opencode-work` has `skills/motive/`, `skills/gws/`, and `plugins/superpowers.js`. `opencode-personal` does not. When editing skills or commands, check whether the change belongs in one or both profiles.

**Note:** `~/.config/opencode` is a symlink to the machine-specific directory (e.g. `opencode-work` or `opencode-personal`) — always edit via the symlink path.

**Bootstrap:** When adding a new MCP server or plugin that requires a package install, also update:
`~/code/dotfiles/.config/yadm/bootstrap_scripts/packages/opencode_setup`
