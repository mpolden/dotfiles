# Fallback prompt
function prompt_setup {
    autoload -Uz colors && colors
    local -r ssh_prefix="%{$fg_bold[green]%}%n@%m%{$reset_color%}:"
    PROMPT="${SSH_TTY:+$ssh_prefix}""%{$fg_bold[blue]%}%~%{$reset_color%}$ "
}

# Prezto
if [[ -s "$HOME/.zprezto/init.zsh" ]]; then
    source "$HOME/.zprezto/init.zsh"
else
    prompt_setup
fi

# Change directory without cd
setopt autocd

# Interactive comments (like bash)
setopt interactivecomments

# Correct commands
setopt correct

# Set color of interactive comments
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=white'

# Print message if reboot is required
[[ -f "/var/run/reboot-required" ]] && print "reboot required"

# Aliases
[[ -s "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"
[[ -s "$HOME/.zsh_aliases.local" ]] && source "$HOME/.zsh_aliases.local"

# Local configuration
[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

unfunction prompt_setup
