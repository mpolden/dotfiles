# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Vim bindings
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode

# Change directory without cd
setopt autocd

# Completion
autoload -U compinit && compinit
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2

# Set LS_COLORS
BREW=$(which brew)
if [[ -x "$BREW" ]]; then
    DIRCOLORS=$(brew --prefix coreutils)/libexec/gnubin/dircolors
    eval "$($DIRCOLORS -b)"
else
    eval "$(dircolors -b)"
fi

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

# Fix home, end and delete
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char

# dircolor and locale
case "$OSTYPE" in
    darwin*)
        alias ls='ls -G'
        export LC_ALL='en_US.UTF-8'
        ;;
    *)
        alias ls='ls --color=auto'
        ;;
esac
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rgrep='rgrep --color=auto'

# Prompt
autoload -U colors && colors
autoload -U vcs_info
autoload -U add-zsh-hook
zstyle ':vcs_info:*' formats ' %F{red}%b%c%f'
zstyle ':vcs_info:*' enable git
add-zsh-hook precmd vcs_info
setopt prompt_subst
PROMPT='%{$fg_bold[green]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%~${vcs_info_msg_0_}%{$reset_color%}\$ '

# Edit command line
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

# Window title
case "$TERM" in
    xterm*)
        precmd () {print -Pn "\e]0;%n@%m: %~\a"}
        ;;
esac

# Command not found handler
[[ -s "/etc/zsh_command_not_found" ]] && source "/etc/zsh_command_not_found"

# Setup aliases and environment
[[ -s "$HOME/.sh_aliases" ]] && source "$HOME/.sh_aliases"
[[ -s "$HOME/.sh_aliases.local" ]] && source "$HOME/.sh_aliases.local"
[[ -s "$HOME/.sh_env" ]] && source "$HOME/.sh_env"
