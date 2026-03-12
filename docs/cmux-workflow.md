# cmux Workflow

cmux is a native macOS terminal (Ghostty-based) with workspace management. It runs side-by-side with tmux — all shell functions detect the environment automatically and behave correctly in both.

## Detection

`_in_cmux()` returns true when `$CMUX_WORKSPACE_ID` is set, which cmux injects automatically into every terminal surface it manages.

---

## Project Workflow

### Open a project

```zsh
workon <project>
```

- **If a workspace for `<project>` already exists** → switches to it.
- **If no workspace exists** → configures the current workspace:
  - Tags it with `project=<name>` (used for future lookups)
  - Left surface: `cd <project> && opencode`
  - Right surface (split): `cd <project> && y` (yazi file manager)
  - Focus returns to the left surface (opencode)

Projects must exist under `~/code/<project>`.

### List projects

```zsh
workon list
```

Shows all directories in `~/code/`, marking ones with an active workspace as `[active]`.

Tab completion is available — press `<Tab>` after `workon` to see project names.

---

## Session Management

| Command | cmux | tmux |
|---------|------|------|
| `tls` | `cmux list-workspaces` | `tmux list-sessions` |
| `ta <id>` | switch to workspace by ref | attach to session |
| `tks <id>` | close workspace by ref | kill session |
| `tka` | close all workspaces | kill server |

---

## Workspace Layout (cmux)

Each `workon` workspace has one tab (pane) with two surfaces:

```
┌─────────────────────┬──────────────┐
│                     │              │
│   opencode          │   yazi (y)   │
│   (left, focused)   │   (right)    │
│                     │              │
└─────────────────────┴──────────────┘
```

---

## Other Shortcuts

| Command | Action |
|---------|--------|
| `code.` | Open VS Code in the current directory |
| `y` | Launch yazi file manager |

---

## Fallback: tmux

All functions (`workon`, `tls`, `ta`, `tks`, `tka`) fall back to standard tmux behavior when not inside a cmux surface. tmux config (`~/.tmux.conf`) is untouched.

tmux workspace layout:

```
┌─────────────────────┬──────────┐
│                     │          │
│   opencode          │  shell   │
│   (left, ~67%)      │  (33%)   │
│                     │          │
└─────────────────────┴──────────┘
```
