# Prezto
[[ -s "$HOME/.zprezto/init.zsh" ]] && source "$HOME/.zprezto/init.zsh" && \
    prezto_loaded=1

# Vim bindings
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins '^?' backward-delete-char

# Change directory without cd
setopt autocd

# Keep stuff usable if prezto isn't loaded
if [[ "$prezto_loaded" -ne 1 ]]; then
    # History
    HISTFILE=$HOME/.zsh_history
    HISTSIZE=10000
    SAVEHIST=10000

    # Completion
    autoload -U compinit && compinit
    zstyle ':completion:*' auto-description 'specify: %d'
    zstyle ':completion:*' completer _expand _complete _correct _approximate
    zstyle ':completion:*' format 'Completing %d'
    zstyle ':completion:*' group-name ''
    zstyle ':completion:*' menu select=2
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*' list-colors ''
    zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
    zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
    zstyle ':completion:*' menu select=long
    zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
    zstyle ':completion:*' use-compctl false
    zstyle ':completion:*' verbose true
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
    zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

    # Prompt
    autoload -U colors && colors
    autoload -U is-at-least
    # vcs_info appeared in 4.3.7
    if is-at-least "4.3.7"; then
        autoload -U vcs_info
        autoload -U add-zsh-hook
        zstyle ':vcs_info:*' formats ' %F{red}%b%c%f'
        zstyle ':vcs_info:*' enable git
        add-zsh-hook precmd vcs_info
    fi
    setopt prompt_subst
    PROMPT='%{$fg_bold[green]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%~${vcs_info_msg_0_}%{$reset_color%}\$ '

    # Window title
    case "$TERM" in
        xterm*)
            precmd () {print -Pn "\e]0;%n@%m: %~\a"}
            ;;
    esac
fi

# Edit command line using editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Display current edit mode
function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Command not found handler
[[ -s "/etc/zsh_command_not_found" ]] && source "/etc/zsh_command_not_found"
[[ -s "/usr/share/doc/pkgfile/command-not-found.zsh" ]] && \
    source "/usr/share/doc/pkgfile/command-not-found.zsh"

# Aliases
[[ -s "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"
[[ -s "$HOME/.zsh_aliases.local" ]] && source "$HOME/.zsh_aliases.local"

# Load z
if [[ -f "/usr/local/etc/profile.d/z.sh" ]]; then
    source "/usr/local/etc/profile.d/z.sh"
elif [[ -f "$HOME/.zcmd/z.sh" ]]; then
    source "$HOME/.zcmd/z.sh"
fi

# Set PATH
path-append () {
    [[ -d "$1" ]] && path+=($1)
}
path-append "$HOME/bin"
path-append "/usr/local/bin"
path-append "/usr/local/sbin"
path-append "/usr/local/share/npm/bin"
path-append "/usr/local/share/python"
path-append "/usr/local/heroku/bin"

# Ensure unique paths in PATH
typeset -U path

# Local configuration
[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
