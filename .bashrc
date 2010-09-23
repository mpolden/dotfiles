if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

PS1='\[\e[1;34m\]\u\[\e[1;37m\]@\[\e[1;34m\]\h\[\e[1;37m\]:\[\e[1;34m\]\w\[\e[1;37m\]\$\[\e[0m\] '
export PS1

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

