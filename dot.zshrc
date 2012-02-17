# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Emacs bindings
bindkey -e

# Change directory without cd
setopt autocd

# Completion
autoload -Uz compinit
compinit
unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end

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

# Load git plugin
[[ -s "$HOME/.zsh-git" ]] && source "$HOME/.zsh-git"

# Prompt
autoload -Uz colors
colors
PS1="%n@%m:%~%# "
setopt prompt_subst
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%}"
PROMPT='%{$fg_bold[green]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%~$(git_prompt_info)%{$reset_color%}\$ '

# Setup environment
[[ -s "$HOME/.bashrc_env" ]] && source "$HOME/.bashrc_env"
