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

# Set terminal
[[ -x "/usr/bin/urxvt" ]] && export TERMINAL="urxvt"

# Set LS_COLORS
if [[ -x "/usr/local/bin/gdircolors" ]]; then
    eval "$(/usr/local/bin/gdircolors -b)"
else
    eval "$(dircolors -b)"
fi

# Load keychain
[[ -f "$HOME/.keychain/$HOST-sh" ]] && source "$HOME/.keychain/$HOST-sh"

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

# Local environment
[[ -s "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"
