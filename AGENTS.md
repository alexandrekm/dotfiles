# Agents Guide for Dotfiles Repository

This document provides AI agents with a structured overview of this dotfiles repository to enable efficient navigation, understanding, and modification of configuration files.

## Repository Overview

| Attribute | Value |
|-----------|-------|
| **Purpose** | Personal dotfiles managed with [Yadm](https://yadm.io/) (Yet Another Dotfiles Manager) |
| **Owner** | alexandrekm |
| **Platform Support** | macOS (Darwin), Linux (Debian/Ubuntu) |
| **Primary Tools** | Neovim, Zsh, Ghostty Terminal |

## Directory Structure

```
~/dotfiles/
├── .config/
│   ├── ghostty/           # Ghostty terminal configuration
│   │   └── config         # Theme, opacity, fonts
│   ├── nvim/              # Neovim configuration (Lua-based)
│   │   ├── init.lua       # Entry point, bootstraps lazy.nvim
│   │   └── lua/
│   │       ├── core/      # Core settings
│   │       │   ├── options.lua   # vim.opt settings
│   │       │   └── keymaps.lua   # Key mappings
│   │       └── plugins/   # Plugin configuration
│   │           ├── init.lua      # Plugin list (lazy.nvim)
│   │           └── configs/      # Plugin-specific configs
│   ├── opencode/          # OpenCode AI configuration
│   │   └── opencode.jsonc # Provider, TUI, and tool settings
│   └── yadm/              # Yadm configuration
│       ├── bootstrap      # Main bootstrap symlink
│       └── bootstrap_scripts/
│           ├── bootstrap         # Main orchestrator
│           ├── packages/setup    # Package manager setup
│           ├── shell/setup       # Shell configuration
│           └── utils/functions.sh # Cross-platform utilities
├── .local/share/          # Local data (fonts, etc.)
├── .zshrc                 # Main Zsh configuration
├── .zshrc.os##os.Darwin   # macOS-specific Zsh config
├── .zshrc.os##os.Linux    # Linux-specific Zsh config
└── README.md              # Human-readable documentation
```

## Key Components

### 1. Zsh Shell Configuration

**Location:** `~/.zshrc`

**Features:**
- Oh My Zsh with plugins: `git`, `aws`, `docker`, `zsh-autosuggestions`, `zsh-completions`, `you-should-use`
- Theme: `intheloop`
- VS Code integration detection
- Modern CLI tool aliases (`lsd`, `dust`, `duf`, `broot`)
- Yadm workflow aliases (`yst`, `yco`, `yp`, `ya`, `ycam`, `ypsup`)
- Atuin shell history integration
- History isolation: Per-session history with immediate appending (`INC_APPEND_HISTORY`, `no SHARE_HISTORY`)

**OS-Specific Files:**
- `.zshrc.os##os.Darwin` - macOS-specific settings (Homebrew paths, etc.)
- `.zshrc.os##os.Linux` - Linux-specific settings

### 2. Neovim Configuration

**Location:** `~/.config/nvim/`

**Architecture:** Modern Lua-based configuration using lazy.nvim plugin manager.

**Key Files:**
| File | Purpose |
|------|---------|
| `init.lua` | Entry point, lazy.nvim bootstrap |
| `lua/core/options.lua` | Editor settings (indentation, clipboard, line numbers) |
| `lua/core/keymaps.lua` | Custom key mappings |
| `lua/plugins/init.lua` | Plugin declarations |
| `lua/plugins/configs/*.lua` | Per-plugin configuration |

**Included Plugins:**
- `nvim-treesitter` - Syntax highlighting
- `nvim-lspconfig` - LSP support (pyright, lua_ls, tsserver)
- `telescope.nvim` - Fuzzy finder
- `nvim-tree` - File explorer
- `nerdcommenter` - Code commenting
- `vim-easymotion` - Quick navigation
- `which-key` - Keybinding hints

### 3. Ghostty Terminal

**Location:** `~/.config/ghostty/config`

**Configuration:**
- Theme: Catppuccin Mocha
- Font: FiraCode Nerd Font (size 14)
- Background: 90% opacity with blur
- Window: 120x30 cells

- Window: 120x30 cells

### 4. OpenCode AI Configuration

**Location:** `~/.config/opencode/opencode.jsonc`

**Features:**
- Provider: OpenAI (gpt-4o)
- Theme: Catppuccin Mocha
- Tool permissions: `ask` for write/edit/bash, `allow` for read/webfetch
- Custom modes: `engineer`, `researcher`
- MCP integration: GitHub server support

### 5. Bootstrap System

**Location:** `~/.config/yadm/bootstrap_scripts/`

**Purpose:** Automated setup for new machines.

**Components:**
| Script | Function |
|--------|----------|
| `bootstrap` | Main orchestrator |
| `packages/setup` | Install Homebrew/apt packages |
| `shell/setup` | Configure Zsh, Git, directories |
| `utils/functions.sh` | Cross-platform helper functions |

**Usage:**
```bash
~/.config/yadm/bootstrap           # Full setup
~/.config/yadm/bootstrap --packages # Packages only
~/.config/yadm/bootstrap --nvim    # Neovim only
~/.config/yadm/bootstrap --shell   # Shell only
```

## Yadm-Specific Concepts

### Alternate Files

Yadm uses file suffixes to manage platform/class-specific configurations:

| Suffix Pattern | Purpose |
|----------------|---------|
| `##os.Darwin` | macOS-specific file |
| `##os.Linux` | Linux-specific file |
| `##class.motive` | "motive" class-specific file |

### Common Commands

```bash
yadm status              # Check tracked file status
yadm add <file>          # Track a new file
yadm commit -m "msg"     # Commit changes
yadm push                # Push to remote
yadm pull                # Pull latest changes
yadm config local.class  # Check current class
yadm encrypt             # Encrypt sensitive files
yadm decrypt             # Decrypt files
```

## Agent Guidelines

### When Modifying Configurations

1. **Zsh changes:** Edit `.zshrc` for cross-platform changes. Use OS-specific files for platform-dependent settings.

2. **Neovim changes:**
   - New plugins → Add to `lua/plugins/init.lua`
   - Plugin configs → Create/edit `lua/plugins/configs/<plugin>.lua`
   - Editor options → Edit `lua/core/options.lua`
   - Key mappings → Edit `lua/core/keymaps.lua`

3. **New applications:** Create config directory under `.config/<app>/`

4. **Bootstrap additions:** Add new setup scripts under `.config/yadm/bootstrap_scripts/`

### Testing Changes

```bash
# Reload shell configuration
source ~/.zshrc

# Validate Neovim configuration
nvim --headless "+Lazy! sync" +qa

# Check Neovim health
nvim +checkhealth
```

### Committing Changes

```bash
yadm add <files>
yadm commit -m "Descriptive message"
yadm push
```

## External Resources

- [Yadm Documentation](https://yadm.io/docs/)
- [Lazy.nvim Documentation](https://github.com/folke/lazy.nvim)
- [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html)
- [Ghostty Documentation](https://ghostty.org/)
