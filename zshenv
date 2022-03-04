# -*- mode: sh -*-

if [[ "$OSTYPE" == darwin* ]]; then
    # Locale
    export LANG="en_US.UTF-8"
    # iTerm may choose to set an invalid LC_CTYPE
    # https://superuser.com/a/1400419
    export LC_CTYPE="en_US.UTF-8"
    # Ensure that /etc/zprofile does not mess with our PATH
    unsetopt GLOBAL_RCS
    # Set mail location
    export MAIL="/var/mail/$LOGNAME"
fi

# Set TERM
case "$TERM" in
    xterm*)
        export TERM="xterm-256color"
        ;;
    screen*)
        export TERM="screen-256color"
        ;;
esac

# Set PATH
function path-prepend {
    [[ -d "$1" ]] && path[1,0]=($1)
}
function path-append {
    [[ -d "$1" ]] && path+=($1)
}
path-append "/usr/sbin"
path-append "/sbin"
path-prepend "/usr/local/sbin"
path-prepend "/usr/local/bin"
# Prefer Homebrew curl because the pre-installed curl doesn't support TLS 1.3
path-prepend "/usr/local/opt/curl/bin"
path-prepend "$HOME/Library/Python/3.8/bin"
path-prepend "$HOME/Library/Python/3.9/bin"
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

# Use fd as find command in fzf
if (( $+commands[fzf] )); then
    fd_opts="--type f --hidden"
    if (( $+commands[fdfind] )); then
        # fd binary is named fdfind on Debian
        export FZF_DEFAULT_COMMAND="fdfind ${fd_opts}"
    elif (( $+commands[fd] )); then
        export FZF_DEFAULT_COMMAND="fd ${fd_opts}"
    fi
    unset fd_opts
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
java_home="$(/usr/libexec/java_home 2> /dev/null)"
[[ -n "$java_home" ]] && export JAVA_HOME="$java_home"
unset java_home

# CLASSPATH
# Add Eclipse JDT to the classpath so that eglot finds it
jdt_jar=$(echo "${HOME}/.emacs.d/eclipse.jdt.ls/plugins"/org.eclipse.equinox.launcher_*.jar(N))
[[ -f "$jdt_jar" ]] && export CLASSPATH=".:$jdt_jar"
unset jdt_jar

# MAVEN_OPTS
# Prevent Maven from running tasks in the foreground
(( $+commands[mvn] )) && export MAVEN_OPTS="-Djava.awt.headless=true"

# Homebrew
if (( $+commands[brew] )); then
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

# Local environment
[[ -s "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"

# Ensure path and cdpath do not contain duplicates
typeset -gU path cdpath

# Clean up functions
unfunction path-prepend path-append cdpath-append
