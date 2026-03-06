# tmux + Ghostty Workflow Guide

## Daily Workflow

```
1.  Open Ghostty
2.  workon <project>          create/attach tmux workspace for that project
3.  Cmd+T                     new Ghostty tab
4.  workon <other-project>    second workspace in the new tab
5.  Cmd+1 / Cmd+2             jump between project tabs
6.  Ctrl-b z                  zoom OpenCode pane full-screen (again to restore)
7.  Ctrl-b d                  detach — session stays alive, tab is freed
8.  tls                       see all running sessions
9.  tks <name>                clean up a finished session
```

---

## Ghostty Tab Keys

| Keys | Action |
|------|--------|
| `Cmd+T` | New tab |
| `Cmd+W` | Close tab |
| `Cmd+1` – `Cmd+8` | Go to tab by number |
| `Cmd+9` | Go to last tab |
| `Ctrl+Tab` | Next tab |
| `Cmd+Shift+[` | Previous tab |

---

## tmux Keys

> All commands require the **prefix** `Ctrl-b` first, then the key.
> Example: `Ctrl-b d` means press `Ctrl-b`, release, then press `d`.

### Sessions

| Keys | Action |
|------|--------|
| `Ctrl-b d` | **Detach** — leave session running in background |
| `Ctrl-b s` | List sessions and switch interactively |
| `Ctrl-b $` | Rename current session |

### Windows (tabs inside tmux)

| Keys | Action |
|------|--------|
| `Ctrl-b c` | New window |
| `Ctrl-b n` | Next window |
| `Ctrl-b p` | Previous window |
| `Ctrl-b 1`–`9` | Go to window by number |
| `Ctrl-b ,` | Rename current window |
| `Ctrl-b &` | Kill current window |

### Panes (splits inside a window)

| Keys | Action |
|------|--------|
| `Ctrl-b %` | Split **vertically** (left/right) |
| `Ctrl-b "` | Split **horizontally** (top/bottom) |
| `Ctrl-b ←↑↓→` | Move between panes |
| `Ctrl-b z` | **Zoom** pane to full screen / restore |
| `Ctrl-b x` | Kill current pane |
| `Ctrl-b {` | Swap pane with the one above/left |
| `Ctrl-b }` | Swap pane with the one below/right |
| `Ctrl-b Space` | Cycle through pane layouts |

### Scroll & Copy

| Keys | Action |
|------|--------|
| `Ctrl-b [` | Enter scroll mode |
| `q` | Exit scroll mode |
| `PgUp` / `PgDn` | Scroll up/down |
| `Space` | Start text selection (in scroll mode) |
| `Enter` | Copy selection (in scroll mode) |
| `Ctrl-b ]` | Paste copied text |

---

## Shell Aliases

| Alias | Expands to | Purpose |
|-------|-----------|---------|
| `tls` | `tmux list-sessions` | List all running sessions |
| `tks <name>` | `tmux kill-session -t` | Kill a specific session |
| `tka` | `tmux kill-server` | Kill all sessions |
| `ta <name>` | `tmux attach -t` | Attach to a session by name |
| `code <path>` | VS Code stable CLI | Open VS Code (stable only) |

---

## VS Code Integration

| Action | How |
|--------|-----|
| Open VS Code for current project | `Ctrl-b o` (from any pane) |
| Opens in pane's working directory | Works wherever you are in the session |
| VS Code terminal font | FiraCode Nerd Font (matches Ghostty) |
| tmux session hint | VS Code terminal shows `ta <project>` if a session is running |

**Workflow:** Need to browse files, review a diff, or use the debugger visually?
Press `Ctrl-b o` — VS Code opens at the exact directory your active pane is in.

---

## Tips

- **Detach, don't close.** `Ctrl-b d` keeps your session alive. Closing the tab or terminal kills nothing.
- **Mouse works.** Scroll, click to focus panes, drag borders to resize.
- **Zoom is your friend.** `Ctrl-b z` toggles OpenCode between full-screen and split view.
- **workon reconnects.** Running `workon <project>` from any tab attaches to the existing session — no state lost.
- **Rename sessions.** `Ctrl-b $` to rename if you started tmux without `workon`.
