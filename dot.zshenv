function add_to_path {
    [[ -d "${1}" && ! "$PATH" =~ (^|:)"${1}"(:|$) ]] && export PATH="$1:$PATH"
}

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

# Set editor to vim
[[ -x "/usr/bin/vim" ]] && export EDITOR="vim"

# Set LS_COLORS
if [[ -x "/usr/local/bin/gdircolors" ]]; then
    eval "$(gdircolors -b)"
else
    eval "$(dircolors -b)"
fi

# Load keychain
[[ -z "$HOSTNAME" ]] && HOSTNAME=$(hostname)
[[ -f "$HOME/.keychain/$HOSTNAME-sh" ]] && \
    source "$HOME/.keychain/$HOSTNAME-sh"

# Add directories to PATH
add_to_path "$HOME/bin"
add_to_path "$HOME/.gem/ruby/1.9.1/bin"
# Homebrew
add_to_path "/usr/local/bin"
add_to_path "/usr/local/sbin"
add_to_path "/usr/local/share/npm/bin"
add_to_path "/usr/local/share/python"
# Heroku toolbelt (Ubuntu)
add_to_path "/usr/local/heroku/bin"

# Java
if [[ -d "/usr/lib/jvm/java-7-oracle" ]]; then
    export JAVA_HOME="/usr/lib/jvm/java-7-oracle"
elif [[ -d "/usr/lib/jvm/java-6-sun" ]]; then
    export JAVA_HOME="/usr/lib/jvm/java-6-sun"
fi

# Maven
[[ -d "/opt/apache-maven" ]] && export M2_HOME="/opt/apache-maven"

# Android
[[ -d "/opt/android-sdk-linux" ]] && \
    export ANDROID_HOME="/opt/android-sdk-linux"

# etckeeper does not read .gitconfig for some reason
if [[ -d "/etc/etckeeper" ]]; then
    export GIT_AUTHOR_EMAIL="$(git config --get user.email)"
    export GIT_AUTHOR_NAME="$(git config --get user.name)"
    export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
fi

# nvm
[[ -f "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"

# Default to Python 2 on Arch
[[ -x "/usr/bin/python2" ]] && export PYTHON="python2"

# rbenv
if [[ -x "$HOME/.rbenv/bin/rbenv" ]]; then
    eval "$(${HOME}/.rbenv/bin/rbenv init -)"
elif [[ -d "/usr/local/opt/rbenv" ]]; then
    export RBENV_ROOT="/usr/local/opt/rbenv"
    eval "$(rbenv init -)"
fi
