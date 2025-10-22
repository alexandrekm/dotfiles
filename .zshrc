# -----------------------------------------------------------------------------
# Oh My Zsh Configuration
# -----------------------------------------------------------------------------
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="amuse"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
plugins=(git aws docker zsh-autosuggestions)
bindkey '^X' create_completion

# -----------------------------------------------------------------------------
# VS Code Integration
# -----------------------------------------------------------------------------
# Check if running inside VS Code's integrated terminal
if [[ "$GIT_PAGER" == "cat" ]]; then
    PROMPT='🤖 copilot %% '
    export AWS_PAGER=""
else
    source $ZSH/oh-my-zsh.sh
fi

# -----------------------------------------------------------------------------
# Prompt Customization
# -----------------------------------------------------------------------------
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)am"
  fi
}
prompt_aws(){}

# -----------------------------------------------------------------------------
# General Aliases
# -----------------------------------------------------------------------------
alias watch='timeout 1h watch'
alias k="kubectl"
alias vim="nvim"
alias myip='curl ipinfo.io/ip'

# -----------------------------------------------------------------------------
# YADM Aliases
# -----------------------------------------------------------------------------
alias yst='yadm status'
alias yco='yadm checkout'
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

# Load additional completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colored completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# -----------------------------------------------------------------------------
# External Tool Management (Managed Sections)
# -----------------------------------------------------------------------------

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
