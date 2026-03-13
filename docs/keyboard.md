# Dev Environment

### Keyboard Shortcuts

**Split Panes**

| Shortcut | Action |
|----------|--------|
| `⌘D` | Split right |
| `⌘⇧D` | Split down |
| `⌥⌘←/→/↑/↓` | Focus pane directionally |

---

## File Manager: yazi

### Navigation

### Search & Jump

| Key | Action |
|-----|--------|
| `/` | Filter files in current dir (fuzzy, live) |
| `f` | Jump to file by first characters (incremental) |
| `s` | Search filenames recursively (uses **fd**) |
| `S` | Search file contents recursively (uses **ripgrep**) |
| `z` | Jump to directory via zoxide |
| `Z` | Jump to directory via zoxide + fzf (interactive) |

### Opening

| Key | Action |
|-----|--------|
| `Enter` / `l` | Open file / enter directory |
| `o` | Open with default app |
| `O` | Open with app picker |
| `!` | Open shell in current directory |

---

## Editor: Neovim

### leap.nvim — Quick Navigation

Leap lets you jump anywhere on screen in 2–3 keystrokes. Type the trigger key, then type the first 1–2 characters of your target, then pick a label.

| Key | Mode | Action |
|-----|------|--------|
| `s` | normal, visual, operator | Leap forward |
| `S` | normal, visual, operator | Leap backward |


### Commenting

| Key | Mode | Action |
|-----|------|--------|
| `<;>c` | normal | Toggle comment on line |

---

## Keyboard: Moonlander Layer Ideas

Ideas for a dedicated dev navigation layer (activate via a thumb key hold). None of these are implemented yet — pick what makes sense after trying the workflow.

### Pane focus on HJKL (highest value)

`⌥⌘` + arrow is a 3-key combo on a split keyboard, pressed constantly when switching between opencode and yazi. A layer makes it a single keypress.

| Layer + key | Sends | Action |
|-------------|-------|--------|
| `H` | `⌥⌘←` | Focus left pane |
| `L` | `⌥⌘→` | Focus right pane |
| `K` | `⌥⌘↑` | Focus pane above |
| `J` | `⌥⌘↓` | Focus pane below |

### cmux workspace and surface shortcuts

| Layer + key | Sends | Action |
|-------------|-------|--------|
| `1–8` | `⌘1–8` | Jump to workspace |
| `9` | `⌘9` | Jump to last workspace |
| `T` | `⌘T` | New surface |
| `W` | `⌘⇧W` | Close workspace |
| `D` | `⌘D` | Split right |
| `⇧D` | `⌘⇧D` | Split down |

### Thumb key tap-hold

If not already configured, thumb keys can double up:

| Key | Tap | Hold |
|-----|-----|------|
| Right inner thumb | `Space` | Layer activate |
| Left inner thumb | `Backspace` | One-shot `⌘` |

### One-shot modifiers on the layer

Put `⌘`, `⌥`, `⌃`, `⇧` as one-shot keys on the home row so combos like `⌘N` or `⌘⇧W` don't require holding — tap modifier, tap key.

### Notes

- The HJKL pane focus mapping works in both cmux (sends `⌥⌘` + arrow) and can be kept consistent with nvim's `⌃HJKL` window nav — they use different modifiers so there's no conflict.
- Avoid putting anything on `S` at the layer level if you use it for leap in nvim — it will fire in both contexts.

---

## Window Management: Moom Flows

5120×2160 on a 40" ultrawide. Each flow is a saved Moom snapshot triggered by a keyboard shortcut.

Suggested trigger modifier: `⌃⌥` (rarely grabbed by apps). Maps cleanly onto the Moonlander layer too — the layer can send `⌃⌥1–5` for one-key flow switching.

### Flow 1 — Dev: cmux + browser

```
┌────────────────────────────────┬──────────────────┐
│                                │                  │
│   cmux (~70%)                  │  Browser (~30%)  │
│   [opencode | yazi]            │  docs / PRs      │
│                                │                  │
└────────────────────────────────┴──────────────────┘
```

Shortcut: `⌃⌥1`

### Flow 2 — Dev: VS Code + browser

```
┌────────────────────────────────┬──────────────────┐
│                                │                  │
│   VS Code (~70%)               │  Browser (~30%)  │
│                                │                  │
└────────────────────────────────┴──────────────────┘
```

Shortcut: `⌃⌥2`

### Flow 3 — Communication (work)

```
┌─────────────────┬──────────────────┬──────────────┐
│                 │                  │              │
│   Slack (~40%)  │  Browser (~35%)  │  Calendar /  │
│                 │                  │  email (~25%)│
└─────────────────┴──────────────────┴──────────────┘
```

Shortcut: `⌃⌥3`

### Flow 4 — Personal

```
┌───────────────┬───────────────┬───────────────────┐
│               │               │                   │
│ Telegram +    │  Browser      │  emClient (~30%)  │
│ WhatsApp(~35%)│  (~35%)       │                   │
└───────────────┴───────────────┴───────────────────┘
```

Shortcut: `⌃⌥4`

### Flow 5 — Focus / reading

```
┌────────┬──────────────────────────┬────────┐
│        │                          │        │
│        │   single app (centered   │        │
│        │   ~50% width)            │        │
└────────┴──────────────────────────┴────────┘
```

Good for long reading, writing, or video calls — stops your eyes from travelling the full width of the screen.

Shortcut: `⌃⌥5`

### Moonlander layer integration

Add `⌃⌥1–5` to the dev layer so flow switching is a single keypress:

| Layer + key | Flow |
|-------------|------|
| `1` | Dev: cmux + browser |
| `2` | Dev: VS Code + browser |
| `3` | Communication (work) |
| `4` | Personal |
| `5` | Focus |

### Setup in Moom

1. Arrange windows manually into the desired layout
2. Moom → Preferences → Snapshots → Save current window arrangement
3. Assign the `⌃⌥N` shortcut to the snapshot
4. Repeat for each flow
