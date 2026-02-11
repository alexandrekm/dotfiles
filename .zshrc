export TERM=xterm-256color

if [[ -n "$ZSH_PROFILE_STARTUP" ]]; then
    zmodload zsh/zprof
fi

# -----------------------------------------------------------------------------
# VS Code Integration
# -----------------------------------------------------------------------------
# Check if running inside VS Code's integrated terminal
if [[ "$GIT_PAGER" == "cat" ]]; then
    PROMPT='🤖 copilot %% '
    export AWS_PAGER=""
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
# Isolate shell history between running sessions (no live sharing)
unsetopt SHARE_HISTORY
# Write commands to history file immediately (so new tabs see them)
setopt INC_APPEND_HISTORY
setopt APPEND_HISTORY

# -----------------------------------------------------------------------------
# General Aliases
# -----------------------------------------------------------------------------
alias watch='timeout 1h watch'
alias k="kubectl"
alias vim="nvim"
alias myip='curl ipinfo.io/ip'
alias reload='source ~/.zshrc'

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

# Quick file search
ff() {
    find . -type f -name "*$1*"
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
    compdef _atuin atuin
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
fi

# -----------------------------------------------------------------------------
# Yadm Drop-in System
# -----------------------------------------------------------------------------
# Load OS-specific configuration (auto-selected by yadm)
if [[ -r "$HOME/.zshrc.os" ]]; then
    source "$HOME/.zshrc.os"
fi

# Load system-specific configuration (selected by local.class)
if [[ -r "$HOME/.zshrc.system" ]]; then
    source "$HOME/.zshrc.system"
fi

if [[ -r "${HOME}/.config/broot/launcher/bash/br" ]]; then
    if (( $+functions[zsh-defer] )); then
        zsh-defer source "${HOME}/.config/broot/launcher/bash/br"
    else
        source "${HOME}/.config/broot/launcher/bash/br"
    fi
fi
export PATH="/Users/alexandre/.antigravity/antigravity/bin:$PATH"

if [[ -n "$ZSH_PROFILE_STARTUP" ]]; then
    zprof
fi
