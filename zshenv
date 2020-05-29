# -*- mode: sh -*-

# Locale
if [[ "$OSTYPE" == darwin* ]]; then
    export LANG="en_US.UTF-8"
    export LC_CTYPE="en_US.UTF-8"
fi

# Use 256 color terminal inside tmux
if [[ -n "$TMUX" ]]; then
   export TERM="screen-256color"
fi

# Load nix
if [[ -s "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
    export NIX_PAGER="cat"
fi

# Set PATH
function path-prepend {
    [[ -d "$1" ]] && path[1,0]=($1)
}
path-prepend "/usr/local/sbin"
path-prepend "/usr/local/bin"
path-prepend "$HOME/Library/Python/3.7/bin"
path-prepend "/Library/TeX/texbin"
path-prepend "/Applications/IntelliJ IDEA CE.app/Contents/plugins/maven/lib/maven3/bin"
path-prepend "$HOME/.local/bin"

# Set CDPATH
function cdpath-append {
    [[ -d "$1" ]] && cdpath+=($1)
}
cdpath-append "$HOME"
cdpath-append "$HOME/p"

# less flags
if (( $+commands[less] )); then
    export LESS="-Ri"
    export PAGER="less"
    # Respect less flags in bat pager
    (( $+commands[bat] )) && export BAT_PAGER="$PAGER $LESS"
fi

# Add colors to man pages
if (( $+commands[bat] )); then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Set EDITOR to emacs or vim
if (( $+commands[emacsclient] )); then
    export EDITOR="emacsclient -q"
elif (( $+commands[emacs] )); then
    export EDITOR="emacs"
elif (( $+commands[mg] )); then
    export EDITOR="mg -n"
elif (( $+commands[vim] )); then
    export EDITOR="vim"
fi

# Set LS_COLORS
if (( $+commands[gdircolors] )); then
    eval "$(gdircolors -b)"
elif (( $+commands[dircolors] )); then
    eval "$(dircolors -b)"
fi

# Use fd as find command in fzf
if (( $+commands[fzf] )); then
    # fd binary is named fdfind on Debian
    if (( $+commands[fdfind] )); then
        export FZF_DEFAULT_COMMAND="fdfind --type f"
    elif (( $+commands[fd] )); then
        export FZF_DEFAULT_COMMAND="fd --type f"
    fi
    # Use fd when finding files with C-t
    [[ -n "$FZF_DEFAULT_COMMAND" ]] && export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Remove mosh prefix from terminal title
(( $+commands[mosh] )) && export MOSH_TITLE_NOPREFIX=1

# Kill mosh-server if it has been inactive for a week
(( $+commands[mosh-server] )) && export MOSH_SERVER_NETWORK_TMOUT=604800

# GOPATH
if [[ -d "${HOME}/go" ]]; then
    export GOPATH="${HOME}/go"
    path-prepend "${GOPATH}/bin"
fi

# JAVA_HOME
if [[ -x "/usr/libexec/java_home" ]]; then
    java_home=$(/usr/libexec/java_home 2> /dev/null)
    [[ -n "$java_home" ]] && export JAVA_HOME="$java_home"
    unset java_home
fi

# MAVEN_OPTS
# Prevent Maven from running tasks in the foreground
(( $+commands[mvn] )) && export MAVEN_OPTS="-Djava.awt.headless=true"

# Local environment
[[ -s "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"

# Ensure path and cdpath do not contain duplicates
typeset -gU path cdpath

# Clean up functions
unfunction path-prepend cdpath-append
