# workon: Project List File Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace `~/code/*(N/)` filesystem globbing in `workon` with an explicit project list file, supporting nested paths and a work/personal split via symlink.

**Architecture:** A helper function `_workon_projects()` reads `~/.config/workon/projects` (a symlink) and returns the project list. All three consumers — `workon list`, `workon <project>`, and `_workon` tab completion — use this helper. Two yadm-tracked source files (`projects-work`, `projects-personal`) allow per-machine selection via symlink.

**Tech Stack:** zsh, yadm

---

### Task 1: Create the project list files

**Files:**
- Create: `~/.config/workon/projects-work`
- Create: `~/.config/workon/projects-personal`

**Step 1: Create the directory**

```bash
mkdir -p ~/.config/workon
```

**Step 2: Create `projects-work` with a comment header**

Create `~/.config/workon/projects-work` with this content:
```
# Work projects — one relative path per line from ~/code
# Example: work/my-app
```

**Step 3: Create `projects-personal` with a comment header**

Create `~/.config/workon/projects-personal` with this content:
```
# Personal projects — one relative path per line from ~/code
# Example: personal/side-project
```

**Step 4: Create the symlink for this machine**

Choose whichever applies to the current machine:
```bash
# Work machine:
ln -sf ~/.config/workon/projects-work ~/.config/workon/projects

# Personal machine:
ln -sf ~/.config/workon/projects-personal ~/.config/workon/projects
```

**Step 5: Verify the symlink resolves**

```bash
ls -la ~/.config/workon/projects
```
Expected: shows symlink pointing to `projects-work` or `projects-personal`

---

### Task 2: Add `_workon_projects()` helper to `~/.zshrc`

**Files:**
- Modify: `~/.zshrc` — add helper just above the `_in_cmux()` function (line ~267)

**Step 1: Add the helper function**

Insert this block immediately before the `_in_cmux()` definition:

```zsh
# _workon_projects — read project list from ~/.config/workon/projects
# Returns relative paths from ~/code, one per line. Skips blanks and # comments.
_workon_projects() {
    local list_file="${HOME}/.config/workon/projects"
    if [[ ! -f "$list_file" && ! -L "$list_file" ]]; then
        echo "workon: project list not found: ${list_file}" >&2
        echo "workon: create it or symlink projects-work / projects-personal" >&2
        return 1
    fi
    command grep -v '^\s*#' "$list_file" | command grep -v '^\s*$'
}
```

**Step 2: Source and test the helper**

```bash
source ~/.zshrc
_workon_projects
```
Expected: empty output (file exists but is empty/comments only) with no errors.

**Step 3: Add a test entry and verify**

```bash
echo "dotfiles" >> ~/.config/workon/projects-work
_workon_projects
```
Expected: `dotfiles`

Remove the test entry afterwards:
```bash
sed -i '' '/^dotfiles$/d' ~/.config/workon/projects-work
```

---

### Task 3: Update `workon list` to use `_workon_projects()`

**Files:**
- Modify: `~/.zshrc:313-340`

**Step 1: Replace the list block**

Find this block (lines 313–340):
```zsh
    # workon list — show ~/code dirs and mark active sessions
    if [[ "$project" == "list" ]]; then
        if _in_cmux; then
            # cmux mode: list workspaces and cross-reference with ~/code dirs
            local ws_json
            ws_json=$(cmux list-workspaces --json 2>/dev/null)
            for dir in "${HOME}"/code/*(N/); do
                local name="${dir:t}"
                # Check if any workspace has a status entry with this project name
                if echo "$ws_json" | command grep -q "\"$name\"" 2>/dev/null; then
                    echo "  $name  [active]"
                else
                    echo "  $name"
                fi
            done
        else
            # tmux mode (unchanged)
            local active
            active=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
            for dir in "${HOME}"/code/*(N/); do
                local name="${dir:t}"
                if echo "$active" | command grep -qx "$name"; then
                    echo "  $name  [active]"
                else
                    echo "  $name"
                fi
            done
        fi
        return 0
    fi
```

Replace with:
```zsh
    # workon list — show projects from list file and mark active sessions
    if [[ "$project" == "list" ]]; then
        local projects
        projects=($(_workon_projects)) || return 1
        if _in_cmux; then
            # cmux mode: list workspaces and cross-reference with project list
            local ws_json
            ws_json=$(cmux list-workspaces --json 2>/dev/null)
            for name in "${projects[@]}"; do
                if echo "$ws_json" | command grep -q "\"$name\"" 2>/dev/null; then
                    echo "  $name  [active]"
                else
                    echo "  $name"
                fi
            done
        else
            # tmux mode
            local active
            active=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
            for name in "${projects[@]}"; do
                if echo "$active" | command grep -qx "$name"; then
                    echo "  $name  [active]"
                else
                    echo "  $name"
                fi
            done
        fi
        return 0
    fi
```

**Step 2: Reload and test**

```bash
source ~/.zshrc
workon list
```
Expected: lists entries from the project file (empty if file is empty), no glob errors.

**Step 3: Add a real entry and verify**

Add an actual project path that exists under `~/code` to the active list file, then run:
```bash
workon list
```
Expected: that project appears in the output.

---

### Task 4: Update `workon <project>` path resolution

**Files:**
- Modify: `~/.zshrc:348-353`

**Step 1: Replace the path resolution block**

Find:
```zsh
    local project_dir="${HOME}/code/${project}"

    if [[ ! -d "$project_dir" ]]; then
        echo "workon: directory not found: ${project_dir}" >&2
        return 1
    fi
```

Replace with:
```zsh
    local project_dir="${HOME}/code/${project}"

    # Validate the project is in the list
    if ! _workon_projects | command grep -qx "$project"; then
        echo "workon: '${project}' not in project list (~/.config/workon/projects)" >&2
        return 1
    fi

    if [[ ! -d "$project_dir" ]]; then
        echo "workon: directory not found: ${project_dir}" >&2
        return 1
    fi
```

**Step 2: Reload and test with a valid project**

```bash
source ~/.zshrc
workon <a-project-in-your-list>
```
Expected: opens the session as before.

**Step 3: Test with an unknown project name**

```bash
workon nonexistent-project
```
Expected: `workon: 'nonexistent-project' not in project list (~/.config/workon/projects)`

---

### Task 5: Update tab completion to use `_workon_projects()`

**Files:**
- Modify: `~/.zshrc:432-436`

**Step 1: Replace the completion function**

Find:
```zsh
_workon() {
    local -a projects
    projects=(list close "${HOME}"/code/*(N/:t))
    compadd "${projects[@]}"
}
```

Replace with:
```zsh
_workon() {
    local -a projects
    projects=(list close $(_workon_projects 2>/dev/null))
    compadd "${projects[@]}"
}
```

**Step 2: Reload and test tab completion**

```bash
source ~/.zshrc
workon <TAB>
```
Expected: `list`, `close`, and the entries from your project list file.

---

### Task 6: Update yadm bootstrap to document the symlink step

**Files:**
- Modify: `~/code/dotfiles/.config/yadm/bootstrap_scripts/packages/setup`

**Step 1: Find a good location**

Look for a section near the end of the file or in a "post-install" / "dotfiles config" area.

**Step 2: Add a note/function for the workon symlink**

Add this at the end of the setup script (before the final `exit 0` if any):

```bash
setup_workon_projects() {
    local workon_dir="${HOME}/.config/workon"
    local symlink="${workon_dir}/projects"

    if [[ -L "$symlink" || -f "$symlink" ]]; then
        print_status "green" "workon project list already configured"
        return 0
    fi

    mkdir -p "$workon_dir"
    print_status "yellow" "workon: project list symlink not set."
    print_status "yellow" "Run one of:"
    print_status "yellow" "  ln -sf ${workon_dir}/projects-work ${symlink}"
    print_status "yellow" "  ln -sf ${workon_dir}/projects-personal ${symlink}"
}

setup_workon_projects
```

**Step 3: Verify bootstrap script is still valid bash**

```bash
bash -n ~/code/dotfiles/.config/yadm/bootstrap_scripts/packages/setup
```
Expected: no output (no syntax errors).

---

### Task 7: Track new files with yadm and commit

**Step 1: Add the new files**

```bash
yadm add ~/.config/workon/projects-work
yadm add ~/.config/workon/projects-personal
yadm add ~/code/dotfiles/.config/yadm/bootstrap_scripts/packages/setup
yadm add ~/.zshrc
```

**Step 2: Verify what's staged**

```bash
yadm status
```
Expected: the four files above show as staged.

**Step 3: Commit**

```bash
yadm commit -m "feat(workon): read projects from list file instead of ~/code glob

- Add ~/.config/workon/projects-work and projects-personal list files
- Add _workon_projects() helper that reads the active symlink
- workon list, workon <project>, and tab completion all use the helper
- Update bootstrap to remind about the symlink setup"
```
