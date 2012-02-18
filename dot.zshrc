# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Emacs bindings
bindkey -e

# Change directory without cd
setopt autocd

# Completion
autoload -Uz compinit && compinit

# Fix home, end and delete
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char

# dircolor
eval "$(dircolors -b)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Prompt
autoload -Uz colors && colors
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
zstyle ':vcs_info:*' formats ' %F{red}%b%c%f'
zstyle ':vcs_info:*' enable git
add-zsh-hook precmd vcs_info
setopt prompt_subst
PROMPT='%{$fg_bold[green]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%~${vcs_info_msg_0_}%{$reset_color%}\$ '

# Setup environment
[[ -s "$HOME/.bashrc_env" ]] && source "$HOME/.bashrc_env"
