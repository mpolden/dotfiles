# Set up the prompt

#autoload -Uz promptinit
#promptinit
#prompt walters

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Enable cache for completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Prompt from http://aperiodic.net/phil/prompt/
[[ -s "$HOME/.zshrc_prompt" ]] && source "$HOME/.zshrc_prompt"

# Fix home, end and delete
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char

# Allow comments interactive shell
setopt interactivecomments

# Try setting a 256 color terminal
if [[ -e /usr/share/terminfo/x/xterm-256color || -e /lib/terminfo/x/xterm-256color ]]; then
    export TERM='xterm-256color'
elif [[ -e /usr/share/terminfo/x/xterm-color || -e /lib/terminfo/x/xterm-color ]]; then
    export TERM='xterm-color'
else
    export TERM='xterm'
fi

# Set editor to vim
if [[ -x /usr/bin/vim ]]; then
    export EDITOR='vim'
fi

# Load aliases
if [[ -s ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

# Suggest package for command not found
if [[ -s /etc/zsh_command_not_found ]]; then
    . /etc/zsh_command_not_found
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

