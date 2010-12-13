# Pull in Ubuntu defaults if they exist
if [[ -s /usr/share/base-files/dot.bashrc ]]; then
    . /usr/share/base-files/dot.bashrc
fi

# Try setting 256 color xterm
if [[ -e /usr/share/terminfo/x/xterm-256color || -e /lib/terminfo/x/xterm-256color ]]; then
    export TERM='xterm-256color'
fi

# Enable completion
if [[ -s /etc/bash_completion ]]; then
    . /etc/bash_completion
fi

# Set editor to vim
if [[ -x /usr/bin/vim ]]; then
    export EDITOR='vim'
fi

# Set prompt (with colors)
if [[ -n "$PS1" ]]; then
    export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# Load aliases
if [[ -s ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

# Load rvm
if [[ -s ~/.rvm/scripts/rvm ]]; then
    . ~/.rvm/scripts/rvm
fi

# Add npm to path
if [[ -d ~/npm/bin ]]; then
    export PATH=$HOME/npm/bin:$PATH
fi

# Add play to path
if [[ -d ~/play ]]; then
    export PATH=$HOME/play:$PATH
fi

