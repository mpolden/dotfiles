# Prezto
[[ -s "$HOME/.zprezto/init.zsh" ]] && source "$HOME/.zprezto/init.zsh"

# Change directory without cd
setopt autocd

# Interactive comments (like bash)
setopt interactivecomments

# Set color of interactive comments
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=white'

# Disable virtualenv prompt
(( $+commands[pyenv] || $+commands[virtualenv] )) && \
    export VIRTUAL_ENV_DISABLE_PROMPT=1

# Chef Development Kit (uses compdef so it must be loaded after prezto)
(( $+commands[chef] )) && eval "$(chef shell-init zsh)"

# Aliases
[[ -s "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"
[[ -s "$HOME/.zsh_aliases.local" ]] && source "$HOME/.zsh_aliases.local"

# Local configuration
[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
