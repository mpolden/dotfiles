# Prezto
[[ -s "$HOME/.zprezto/init.zsh" ]] && source "$HOME/.zprezto/init.zsh"

# Vim bindings
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins '^?' backward-delete-char

# Change directory without cd
setopt autocd

# Aliases
[[ -s "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"
[[ -s "$HOME/.zsh_aliases.local" ]] && source "$HOME/.zsh_aliases.local"

# Load z
if [[ -f "/usr/local/etc/profile.d/z.sh" ]]; then
    source "/usr/local/etc/profile.d/z.sh"
elif [[ -f "$HOME/.zcmd/z.sh" ]]; then
    source "$HOME/.zcmd/z.sh"
fi

# Local configuration
[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
