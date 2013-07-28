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
fi
unset prezto_loaded

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
if [[ "$TERM" == xterm* ]]; then
    precmd () {print -Pn "\e]0;%n@%m: %~\a"}
fi

# Edit command line using editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Display current edit mode
vim_ins_mode='[i]'
vim_cmd_mode='[n]'
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish
RPROMPT='${vim_mode}'

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
path-prepend () {
    [[ -d "$1" ]] && path[1,0]=($1)
}
path-prepend "/usr/local/sbin"
path-prepend "/usr/local/bin"
path-prepend "$HOME/.local/bin"
typeset -U path

# nvm
[[ -f "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"

# virtualenvwrapper
if [[ -f "/usr/local/bin/virtualenvwrapper.sh" ]]; then
    export WORKON_HOME="$HOME/.virtualenvs"
    export PROJECT_HOME="$HOME/p"
    source "/usr/local/bin/virtualenvwrapper.sh"
fi
if [[ -f "/etc/bash_completion.d/virtualenvwrapper" ]]; then
    export WORKON_HOME="$HOME/.virtualenvs"
    export PROJECT_HOME="$HOME/p"
    source "/etc/bash_completion.d/virtualenvwrapper"
fi

# Local configuration
[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
