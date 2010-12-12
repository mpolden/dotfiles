# Try setting 256 color xterm
if [[ -e /usr/share/terminfo/x/xterm-256color || -e /lib/terminfo/x/xterm-256color ]]; then
    TERM='xterm-256color'
elif [[ -e /usr/share/terminfo/x/xterm-color || -e /lib/terminfo/x/xterm-color ]]; then
    TERM='xterm-color'
else
    TERM='xterm'
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
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Load aliases
if [[ -s ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

# Load rvm
if [[ -s $HOME/.rvm/scripts/rvm ]]; then
    . $HOME/.rvm/scripts/rvm
fi

# Add npm to path
if [[ -d $HOME/npm/bin ]]; then
    export PATH=$HOME/npm/bin:$PATH
fi

# Add play to path
if [[ -d $HOME/play ]]; then
    export PATH=$HOME/play:$PATH
fi

