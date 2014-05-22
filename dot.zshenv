# Locale
if [[ "$OSTYPE" == darwin* ]]; then
    export LANG="en_US.UTF-8"
    export LC_CTYPE="en_US.UTF-8"
fi

# Set 256 color xterm
[[ -e "/usr/share/terminfo/x/xterm-256color" || \
    -e "/usr/share/terminfo/78/xterm-256color" || \
    -e "/lib/terminfo/x/xterm-256color" ]] && \
    export TERM="xterm-256color"

# Set tmux TERM
[[ -n "$TMUX" ]] && export TERM="screen-256color"

# Set EDITOR to emacs or vim
if [[ -x "/usr/bin/emacsclient" ]]; then
    export EDITOR="emacsclient -q"
elif [[ -x "/usr/bin/vim" ]]; then
    export EDITOR="vim"
fi

# Set LS_COLORS
if [[ -x "/usr/local/bin/gdircolors" ]]; then
    eval "$(/usr/local/bin/gdircolors -b)"
else
    eval "$(dircolors -b)"
fi

# etckeeper does not read .gitconfig for some reason
if [[ -d "/etc/etckeeper" ]]; then
    export GIT_AUTHOR_EMAIL="$(git config --get user.email)"
    export GIT_AUTHOR_NAME="$(git config --get user.name)"
    export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
fi

# Set PATH
path-prepend () {
    [[ -d "$1" ]] && path[1,0]=($1)
}
path-prepend "/usr/local/sbin"
path-prepend "/usr/local/bin"
path-prepend "/usr/local/go/bin"
path-prepend "$HOME/.local/bin"
typeset -U path

# Local environment
[[ -s "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"
