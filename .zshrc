export TERM=xterm-256color

if [[ -n "$ZSH_PROFILE_STARTUP" ]]; then
    zmodload zsh/zprof
fi

# -----------------------------------------------------------------------------
# Yadm Drop-in: OS-specific Configuration
# -----------------------------------------------------------------------------
# Load early so PATH (e.g. Homebrew) is available for plugins and aliases
if [[ -r "$HOME/.zshrc.os" ]]; then
    source "$HOME/.zshrc.os"
fi

# -----------------------------------------------------------------------------
# VS Code Integration
# -----------------------------------------------------------------------------
# Check if running inside VS Code's integrated terminal
if [[ "$GIT_PAGER" == "cat" ]]; then
    PROMPT='🤖 copilot %% '
    export AWS_PAGER=""

    # Auto-attach to the tmux session matching this workspace, if one exists.
    # VS Code starts the terminal in the workspace root — match it to ~/code/<name>.
    # Only attach if: not already inside tmux, tmux is running, and PWD is a ~/code/* project.
    if [[ -z "$TMUX" ]] && command -v tmux &>/dev/null; then
        local _vscode_project="${PWD#$HOME/code/}"
        if [[ "$_vscode_project" != "$PWD" && "$_vscode_project" != */* ]]; then
            if tmux has-session -t "$_vscode_project" 2>/dev/null; then
                echo "tmux session '$_vscode_project' is running. Attach with: ta $_vscode_project"
            fi
        fi
        unset _vscode_project
    fi
else
    # -------------------------------------------------------------------------
    # Antidote Plugin Manager
    # -------------------------------------------------------------------------
    ANTIDOTE_HOME="${ZDOTDIR:-$HOME}/.antidote"
    ANTIDOTE_PLUGINS_FILE="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
    ANTIDOTE_BUNDLE_FILE="${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"

    if [[ -r "$ANTIDOTE_HOME/antidote.zsh" ]]; then
        source "$ANTIDOTE_HOME/antidote.zsh"

        if [[ -r "$ANTIDOTE_PLUGINS_FILE" ]]; then
            if [[ ! -r "$ANTIDOTE_BUNDLE_FILE" || "$ANTIDOTE_PLUGINS_FILE" -nt "$ANTIDOTE_BUNDLE_FILE" ]]; then
                antidote bundle < "$ANTIDOTE_PLUGINS_FILE" >| "$ANTIDOTE_BUNDLE_FILE"
            fi

            if [[ "$ANTIDOTE_BUNDLE_FILE" -nt "$ANTIDOTE_BUNDLE_FILE.zwc" ]]; then
                zcompile "$ANTIDOTE_BUNDLE_FILE" 2>/dev/null
            fi

            source "$ANTIDOTE_BUNDLE_FILE"
        fi
    fi
fi

# -----------------------------------------------------------------------------
# History Configuration
# -----------------------------------------------------------------------------
# Isolate shell history per session — no sharing between tabs
unsetopt SHARE_HISTORY
unsetopt INC_APPEND_HISTORY

# -----------------------------------------------------------------------------
# General Aliases
# -----------------------------------------------------------------------------
alias watch='timeout 1h watch'
alias k="kubectl"
alias vim="nvim"
alias myip='curl ipinfo.io/ip'
alias reload='source ~/.zshrc'
alias kx='kubectx'
alias kns='kubens'

# Use modern alternatives for better output
alias ls='lsd'
alias du='dust'
alias df='duf'
alias tree='broot'

# -----------------------------------------------------------------------------
# YADM Aliases
# -----------------------------------------------------------------------------
alias yst='yadm status'
alias yco='yadm checkout'
alias yp='yadm pull'
alias ya='yadm add'
alias ycam='yadm commit -m'
alias ypsup='yadm push'

# Quick file search (using ripgrep if available, fallback to find)
 ff() {
    if command -v rg &>/dev/null; then
        rg --files --glob "*${1}*" 2>/dev/null
    else
        find . -type f -name "*$1*"
    fi
}

# Extract various archive formats
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# -----------------------------------------------------------------------------
# zoxide — smarter cd
# -----------------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
    # Match the fzf style used elsewhere in this config
    export _ZO_FZF_OPTS="--height=50% --layout=reverse --border=rounded"

    _zoxide_init_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zoxide_init.zsh"
    _zoxide_bin="$(command -v zoxide)"
    if [[ ! -f "$_zoxide_init_cache" || "$_zoxide_bin" -nt "$_zoxide_init_cache" ]]; then
        mkdir -p "${_zoxide_init_cache:h}"
        zoxide init zsh >| "$_zoxide_init_cache"
    fi
    source "$_zoxide_init_cache"
    unset _zoxide_init_cache _zoxide_bin
fi

y() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colored completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Completion UX
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format 'no matches for: %d'
zstyle ':completion:*' squeeze-slashes true
zstyle ':fzf-tab:complete:*' fzf-flags '--height=50% --layout=reverse --border=rounded'

# you-should-use plugin keybinding
if (( $+functions[create_completion] )); then
    bindkey '^X' create_completion
fi

# Fish-like history search with arrow keys
if (( $+functions[history-substring-search-up] )) && (( $+functions[history-substring-search-down] )); then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey '^[OA' history-substring-search-up
    bindkey '^[OB' history-substring-search-down
fi

# -----------------------------------------------------------------------------
# External Tool Management (Managed Sections)
# -----------------------------------------------------------------------------

_setup_atuin_completion() {
    if (( $+functions[_atuin] )); then
        return
    fi

    local atuin_comp_file="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions/_atuin"
    local atuin_bin
    atuin_bin="$(command -v atuin 2>/dev/null)"

    if [[ -z "$atuin_bin" ]]; then
        return
    fi

    if [[ ! -s "$atuin_comp_file" || "$atuin_bin" -nt "$atuin_comp_file" ]]; then
        mkdir -p "${atuin_comp_file:h}"
        atuin gen-completions --shell zsh >| "$atuin_comp_file" 2>/dev/null || return
    fi

    if [[ ${fpath[(Ie)"${atuin_comp_file:h}"]} -eq 0 ]]; then
        fpath=("${atuin_comp_file:h}" $fpath)
    fi

    autoload -Uz _atuin
    if (( $+functions[compdef] )); then
        compdef _atuin atuin
    fi
}

# Atuin - Shell history sync and search
if command -v atuin &> /dev/null; then
    _setup_atuin_completion
    if (( $+functions[zsh-defer] )); then
        zsh-defer eval "$(atuin init zsh)"
    else
        eval "$(atuin init zsh)"
    fi
fi

# Starship prompt
if [[ "$GIT_PAGER" != "cat" ]] && command -v starship &> /dev/null; then
    eval "$(starship init zsh)"

    # Transient prompt — collapse previous prompts to a minimal character
    # after each command, giving a cleaner scrollback (like Powerlevel10k)
    _starship_accept_line() {
        local _starship_old_prompt="$PROMPT"
        PROMPT="$(starship module character) "
        zle reset-prompt
        PROMPT="$_starship_old_prompt"
        unset _starship_old_prompt
        zle .accept-line
    }
    zle -N accept-line _starship_accept_line
fi

# -----------------------------------------------------------------------------
# Broot
# -----------------------------------------------------------------------------
if [[ -r "${HOME}/.config/broot/launcher/bash/br" ]]; then
    if (( $+functions[zsh-defer] )); then
        zsh-defer source "${HOME}/.config/broot/launcher/bash/br"
    else
        source "${HOME}/.config/broot/launcher/bash/br"
    fi
fi

# -----------------------------------------------------------------------------
# tmux Workflow
# -----------------------------------------------------------------------------

# workon <project> — create or attach to a project tmux session
# Each session gets a 2-pane layout: opencode (left) + shell (right)
workon() {
    local project="${1}"

    # workon list — show ~/code dirs and mark active tmux sessions
    if [[ "$project" == "list" ]]; then
        local active
        active=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
        for dir in "${HOME}"/code/*(N/); do
            local name="${dir:t}"
            if echo "$active" | grep -qx "$name"; then
                echo "  $name  [active]"
            else
                echo "  $name"
            fi
        done
        return 0
    fi

    if [[ -z "$project" ]]; then
        echo "Usage: workon <project-name|list>" >&2
        return 1
    fi

    local project_dir="${HOME}/code/${project}"

    if [[ ! -d "$project_dir" ]]; then
        echo "workon: directory not found: ${project_dir}" >&2
        return 1
    fi

    # Session already exists — attach or switch to it
    if tmux has-session -t "$project" 2>/dev/null; then
        if [[ -n "$TMUX" ]]; then
            tmux switch-client -t "$project"
        else
            tmux attach-session -t "$project"
        fi
        return 0
    fi

    # Create a new session (detached so we can configure it first)
    tmux new-session -d -s "$project" -n "opencode" -c "$project_dir"

    # Start opencode in the first (left) pane
    tmux send-keys -t "${project}:opencode.1" "opencode" Enter

    # Split right at 35% width, starting a plain shell
    tmux split-window -t "${project}:opencode" -h -p 33 -c "$project_dir"

    # Focus the left pane (opencode)
    tmux select-pane -t "${project}:opencode.1"

    # Attach or switch to the new session
    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$project"
    else
        tmux attach-session -t "$project"
    fi
}

# Tab completion for workon — offers 'list' and directories in ~/code/
_workon() {
    local -a projects
    projects=(list "${HOME}"/code/*(N/:t))
    compadd "${projects[@]}"
}
if (( $+functions[compdef] )); then
    compdef _workon workon
else
    autoload -Uz add-zsh-hook
    add-zsh-hook -Uz precmd _workon_register_compdef
    _workon_register_compdef() {
        if (( $+functions[compdef] )); then
            compdef _workon workon
            add-zsh-hook -d precmd _workon_register_compdef
        fi
    }
fi

# tmux session aliases
alias tls='tmux list-sessions'       # List all project sessions
alias tks='tmux kill-session -t'     # Kill a specific session: tks <name>
alias tka='tmux kill-server'         # Kill all sessions (nuclear)
alias ta='tmux attach -t'            # Attach to a session: ta <name>

# -----------------------------------------------------------------------------
# Local Environment Overrides
# -----------------------------------------------------------------------------
# Load machine-specific configuration (not tracked by yadm)
if [[ -r "$HOME/.env.zshrc" ]]; then
    source "$HOME/.env.zshrc"
fi

if [[ -n "$ZSH_PROFILE_STARTUP" ]]; then
    zprof
fi
