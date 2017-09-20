# Locale
if [[ "$OSTYPE" == darwin* ]]; then
    export LANG="en_US.UTF-8"
    export LC_CTYPE="en_US.UTF-8"
fi

# Use 256 color terminal inside tmux
if [[ -n "$TMUX" ]]; then
   export TERM="screen-256color"
fi

# Set PATH
function path-prepend {
    [[ -d "$1" ]] && path[1,0]=($1)
}
path-prepend "/usr/local/sbin"
path-prepend "/usr/local/bin"
path-prepend "/usr/local/go/bin"
path-prepend "$HOME/.local/bin"

# Set CDPATH
function cdpath-append {
    [[ -d "$1" ]] && cdpath+=($1)
}
cdpath-append "$HOME"
cdpath-append "$HOME/p"

# Set LESSOPEN
if (( $+commands[lesspipe] )); then
    eval "$(lesspipe)"
elif (( $+commands[lesspipe.sh] )); then
    eval "$(lesspipe.sh)"
fi

# less flags
(( $+commands[less] )) && export LESS="-Ri"

# Add colors to man pages
export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.

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

# Remove mosh prefix from terminal title
(( $+commands[mosh] )) && export MOSH_TITLE_NOPREFIX=1

# GOPATH
if [[ -d "${HOME}/go" ]]; then
    export GOPATH="${HOME}/go"
    path-prepend "${GOPATH}/bin"
    cdpath-append "${GOPATH}/src/github.com/mpolden"
fi

# JAVA_HOME
if [[ -x "/usr/libexec/java_home" ]]; then
    java_home=$(/usr/libexec/java_home 2> /dev/null)
    [[ -n "$java_home" ]] && export JAVA_HOME=$java_home
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
