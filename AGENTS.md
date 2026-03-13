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

## OpenCode Configuration

| File/Dir | Purpose |
|----------|---------|
| `~/.config/opencode/opencode.jsonc` | Main config — models, MCP servers, plugins, agent definitions |
| `~/.config/opencode/command/` | Custom slash commands |
| `~/.config/opencode/skills/` | Skills available to agents |

**Note:** `~/.config/opencode` is a symlink to the machine-specific directory (e.g. `opencode-work` or `opencode-personal`) — always edit via the symlink path.

**Bootstrap:** When adding a new MCP server or plugin that requires a package install, also update:
`~/code/dotfiles/.config/yadm/bootstrap_scripts/packages/opencode_setup`
