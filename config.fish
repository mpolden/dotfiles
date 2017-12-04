# Helper functions
function path-prepend
        set -l p $argv[1]
        if [ -d $p ]
                and not contains $p $PATH
                set -gx PATH $p $PATH
        end
end

function cdpath-append
        set -l p $argv[1]
        if [ -d $p ]
                and not contains $p $CDPATH
                set -gx CDPATH $CDPATH $p
        end
end

function is-command
        command -s $argv[1] > /dev/null
end

function alias-if-in-path
        set -l name $argv[1]
        set -l values (string split ' ' $argv[2])
        set -l cmd $values[1]
        if [ $cmd = 'sudo' ]
                set cmd $values[2]
        end
        if is-command $cmd
                alias $name "$values"
        end
end

function ls-command
        set -l ls_opts '--group-directories-first --color=auto'
        switch (uname)
                case Darwin FreeBSD
                        if is-command exa
                                echo "exa $ls_opts"
                        else if is-command gls
                                echo "gls $ls_opts"
                        else if is-command gnuls
                                echo "gnuls $ls_opts"
                        else
                                echo 'ls -G'
                        end
                case '*'
                        echo "ls $ls_opts"
        end
end

# Remove greeting
set fish_greeting

# Prompt
set -g __fish_git_prompt_color_branch red
set -g fish_color_user green
set -g fish_color_host green
set -g fish_color_at green
set -g fish_color_cwd blue
set -g fish_color_command green
set -g fish_color_param grey
set -g fish_prompt_pwd_dir_length 0

# Set locale on Darwin
if [ (uname) = 'Darwin' ]
        set -gx LANG 'en_US.UTF-8'
        set -gx LC_CTYPE 'en_US.UTF-8'
end

# Set terminal inside tmux
if set -q TMUX
        set -gx TERM 'screen-256color'
end

# Set PATH
path-prepend /usr/local/sbin
path-prepend /usr/local/bin
path-prepend $HOME/Library/Python/3.6/bin
path-prepend $HOME/Library/Python/2.7/bin
path-prepend /usr/local/go/bin
path-prepend $HOME/.local/bin

# Set CDPATH
cdpath-append .
cdpath-append $HOME
cdpath-append $HOME/p

# Configure less
if is-command lesspipe
        set -l lesspipe (command -s lesspipe)
        set -gx LESSOPEN "|$lesspipe %s"
else if is-command lesspipe.sh
        set -l lesspipe (command -s lesspipe.sh)
        set -gx LESSOPEN "|$lesspipe %s"
end

if is-command less
        set -gx LESS '-Ri'
end

# Add colors to man pages
set -gx LESS_TERMCAP_mb (printf '\e[01;31m')
set -gx LESS_TERMCAP_md (printf '\e[01;31m')
set -gx LESS_TERMCAP_me (printf '\e[0m')
set -gx LESS_TERMCAP_se (printf '\e[0m')
set -gx LESS_TERMCAP_so (printf '\e[00;47;30m')
set -gx LESS_TERMCAP_ue (printf '\e[0m')
set -gx LESS_TERMCAP_us (printf '\e[01;32m')

# Set EDITOR to emacs or vim
if is-command emacsclient
        set -gx EDITOR 'emacsclient -q'
else if is-command emacs
        set -gx EDITOR 'emacs'
else if is-command mg
        set -gx EDITOR 'mg'
else if is-command vim
        set -gx EDITOR 'vim'
end

# Remove mosh prefix from terminal title
if is-command mosh
        set -gx MOSH_TITLE_NOPREFIX '1'
end

# GOPATH
if [ -d $HOME/go ]
        set -gx GOPATH $HOME/go
        path-prepend $GOPATH/bin
        cdpath-append $GOPATH/src/github.com/mpolden
end

# JAVA_HOME
if [ -x /usr/libexec/java_home ]
        set -l java_home (/usr/libexec/java_home 2> /dev/null)
        if [ -n $java_home ]
                set -gx JAVA_HOME $java_home
        end
end

# MAVEN_OPTS
# Prevent Maven from running tasks in the foreground
if is-command mvn
        set -gx MAVEN_OPTS '-Djava.awt.headless=true'
end

# Aliases
alias git-root 'cd (git rev-parse --show-toplevel)'
alias week 'date +%V'
alias ls (ls-command)
alias-if-in-path grep 'grep --color=auto'
alias-if-in-path aptup 'sudo apt update; and sudo apt upgrade'
alias-if-in-path autossh 'autossh -M 0 -o "ServerAliveInterval 10"'
alias-if-in-path diff 'colordiff'
alias-if-in-path ec 'emacsclient -nq'
alias-if-in-path mg 'mg -n'

# Local configuration
if [ -s $HOME/.config/fish/local.fish ]
        source $HOME/.config/fish/local.fish
end

# Clean up helper functions
functions -e path-prepend cdpath-append is-command alias-if-in-path ls-command
