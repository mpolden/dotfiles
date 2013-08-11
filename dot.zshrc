# Prezto
[[ -s "$HOME/.zprezto/init.zsh" ]] && source "$HOME/.zprezto/init.zsh"

# Vim bindings
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins '^?' backward-delete-char

# Change directory without cd
setopt autocd

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

# virtualenvwrapper
if [[ -f "/usr/local/bin/virtualenvwrapper_lazy.sh" ]]; then
    export WORKON_HOME="$HOME/.virtualenvs"
    export PROJECT_HOME="$HOME/p"
    source "/usr/local/bin/virtualenvwrapper_lazy.sh"
fi
if [[ -f "/usr/share/doc/virtualenvwrapper/examples/virtualenvwrapper_lazy.sh" ]]; then
    export WORKON_HOME="$HOME/.virtualenvs"
    export PROJECT_HOME="$HOME/p"
    source "/usr/share/doc/virtualenvwrapper/examples/virtualenvwrapper_lazy.sh"
fi

# Local configuration
[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
