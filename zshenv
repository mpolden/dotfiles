# -*- mode: sh -*-

# Locale
if [[ "$OSTYPE" == darwin* ]]; then
    export LANG="en_US.UTF-8"
    # iTerm may choose to set an invalid LC_CTYPE
    # https://superuser.com/a/1400419
    export LC_CTYPE="en_US.UTF-8"
    # Norwegian time locale
    export LC_TIME="no_NO.UTF-8"
    # Ensure that /etc/zprofile does not mess with our PATH
    unsetopt GLOBAL_RCS
elif [[ "$OSTYPE" == linux* ]]; then
    export LANG="en_US.UTF-8"
    # Norwegian locale on Linux is named differently
    export LC_TIME="nb_NO.UTF-8"
fi

# Set TERM
case "$TERM" in
    xterm*)
        export TERM="xterm-256color"
        ;;
    screen*|tmux*)
        # OS may lack terminfo entry for tmux-256color
        # https://github.com/tmux/tmux/issues/2262
        export TERM="screen-256color"
        ;;
esac

# Homebrew
if [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if (( $+commands[brew] )); then
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

# Set PATH
function path-prepend {
    [[ -d "$1" ]] && path[1,0]=($1)
}
function path-append {
    [[ -d "$1" ]] && path+=($1)
}
path-prepend "/usr/local/sbin"
path-prepend "/usr/local/bin"
path-prepend "/Library/TeX/texbin"
path-prepend "/Applications/IntelliJ IDEA CE.app/Contents/plugins/maven/lib/maven3/bin"
path-prepend "$HOME/.local/bin"
path-prepend "$HOME/.cargo/bin"

# Set CDPATH
function cdpath-append {
    [[ -d "$1" ]] && cdpath+=($1)
}
cdpath-append "$HOME"
cdpath-append "$HOME/p"

# Pager
if (( $+commands[less] )); then
    export LESS="-Ri"
    export PAGER="less"
    # Add colors to man pages
    export LESS_TERMCAP_mb=$'\e[1;32m'      # Begins blinking.
    export LESS_TERMCAP_md=$'\e[1;32m'      # Begins bold.
    export LESS_TERMCAP_me=$'\e[0m'         # Ends mode.
    export LESS_TERMCAP_se=$'\e[0m'         # Ends standout-mode.
    export LESS_TERMCAP_so=$'\e[1;31m'      # Begins standout-mode.
    export LESS_TERMCAP_ue=$'\e[0m'         # Ends underline.
    export LESS_TERMCAP_us=$'\e[4m'         # Begins underline.
fi

# Set EDITOR, from most to least preferred
if (( $+commands[emacsclient] )); then
    export EDITOR="emacsclient"
elif (( $+commands[emacs] )); then
    export EDITOR="emacs"
elif (( $+commands[mg] )); then
    export EDITOR="mg"
elif (( $+commands[jmacs] )); then
    export EDITOR="jmacs"
elif (( $+commands[vim] )); then
    export EDITOR="vim"
elif (( $+commands[vi] )); then
    export EDITOR="vi"
fi

# Set LS_COLORS
if (( $+commands[gdircolors] )); then
    eval "$(gdircolors -b)"
elif (( $+commands[dircolors] )); then
    eval "$(dircolors -b)"
fi

# Use bfs as find command in fzf
if (( $+commands[fzf] && $+commands[bfs] )); then
    export FZF_DEFAULT_COMMAND="bfs"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
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
java_home="$(/usr/libexec/java_home 2> /dev/null)"
[[ -n "$java_home" ]] && export JAVA_HOME="$java_home"
unset java_home

# MAVEN_OPTS
# Prevent Maven from running tasks in the foreground
(( $+commands[mvn] )) && export MAVEN_OPTS="-Djava.awt.headless=true"

# PLAN9
if [[ -d "$HOME/.local/plan9" ]]; then
    export PLAN9="$HOME/.local/plan9"
    path-append "$PLAN9/bin"
fi

# Local environment
[[ -s "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"

# Ensure path and cdpath do not contain duplicates
typeset -gU path cdpath

# Clean up functions
unfunction path-prepend cdpath-append
