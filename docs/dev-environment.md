# Dev Environment

## Terminal: cmux

cmux is a native macOS terminal (Ghostty-based) with workspace management. It runs side-by-side with tmux — shell functions detect the environment automatically via `$CMUX_WORKSPACE_ID`.

### Project Workflow

```zsh
workon <project>    # open or switch to a project workspace
workon list         # list ~/code/ dirs, marking active ones
```

`workon <project>` behaviour:
- **Workspace exists** → switches to it
- **No workspace** → configures the current workspace:
  - Left surface: `opencode`
  - Right surface: `yazi` (`y`)
  - Focus returns to left (opencode)

Projects must exist under `~/code/<project>`. Tab completion available.

### Shortcuts

| Command | Action |
|---------|--------|
| `code.` | Open VS Code in the current directory |
| `y` | Launch yazi file manager |

### Fallback: tmux

`workon` falls back to tmux when not inside cmux — creates a session with opencode (left, ~67%) + idle shell (right, 33%). `~/.tmux.conf` is untouched.

---

## Editor: Neovim

### leap.nvim — Quick Navigation

Leap lets you jump anywhere on screen in 2–3 keystrokes. Type the trigger key, then type the first 1–2 characters of your target, then pick a label.

| Key | Mode | Action |
|-----|------|--------|
| `s` | normal, visual, operator | Leap forward |
| `S` | normal, visual, operator | Leap backward |
| `<Leader>l` | normal | Leap to any location (bidirectional) |

**Workflow:**
1. Press `s` (forward) or `S` (backward)
2. Type 1–2 characters of the target word
3. If multiple matches appear, type the highlighted label to jump

**With operators** (e.g. delete/yank to a target):
```
d s <chars> <label>   # delete up to target
y s <chars> <label>   # yank up to target
```

### Window Navigation

| Key | Action |
|-----|--------|
| `<C-h>` | Move to left window |
| `<C-j>` | Move to window below |
| `<C-k>` | Move to window above |
| `<C-l>` | Move to right window |

### Commenting

| Key | Mode | Action |
|-----|------|--------|
| `<Leader>c` | normal | Toggle comment on line |
| `<Leader>c` | visual | Toggle comment on selection |
