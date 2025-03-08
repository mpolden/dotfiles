# -*- mode: fish -*-

########## Environment ##########

set -l uname (uname)

# Locale
switch $uname
    case Darwin
        set -gx LANG en_US.UTF-8
        # Norwegian time locale
        set -gx LC_TIME no_NO.UTF-8
    case Linux
        set -gx LANG en_US.UTF-8
        # Norwegian locale on Linux is named differently
        set -gx LC_TIME nb_NO.UTF-8
end

# Set TERM
switch $TERM
    case "xterm*"
        set -gx TERM xterm-256color
    case "screen*" "tmux*"
        # OS may lack terminfo entry for tmux-256color
        # https://github.com/tmux/tmux/issues/2262
        set -gx TERM screen-256color
end

# Homebrew
if [ -x /opt/workbrew/bin/brew ]
    eval $(/opt/workbrew/bin/brew shellenv)
else if [ -x /usr/local/bin/brew ]
    eval $(/usr/local/bin/brew shellenv)
else if [ -x /opt/homebrew/bin/brew ]
    eval $(/opt/homebrew/bin/brew shellenv)
end
if command -q brew
    set -gx HOMEBREW_NO_ANALYTICS 1
    set -gx HOMEBREW_NO_AUTO_UPDATE 1
end

# Set PATH
fish_add_path --prepend --move /usr/local/sbin
fish_add_path --prepend --move /usr/local/bin
# Pre-Sonoma macOS lacks trash command
fish_add_path --prepend --move /usr/local/opt/trash/bin
fish_add_path --prepend --move "/Applications/IntelliJ IDEA CE.app/Contents/plugins/maven/lib/maven3/bin"
fish_add_path --prepend --move "$HOME/.local/bin"
fish_add_path --prepend --move "$HOME/.cargo/bin"

# Set CDPATH
set -gx CDPATH $HOME $HOME/git

# Configure less
if command -q less
    set -gx LESS -Ri
    set -gx PAGER less
    # Add colors to man pages
    set -gx LESS_TERMCAP_mb (printf "\e[1;32m") # Begins blinking.
    set -gx LESS_TERMCAP_md (printf "\e[1;32m") # Begins bold.
    set -gx LESS_TERMCAP_me (printf "\e[0m") # Ends mode.
    set -gx LESS_TERMCAP_se (printf "\e[0m") # Ends standout-mode.
    set -gx LESS_TERMCAP_so (printf "\e[1;31m") # Begins standout-mode.
    set -gx LESS_TERMCAP_ue (printf "\e[0m") # Ends underline.
    set -gx LESS_TERMCAP_us (printf "\e[4m") # Begins underline.
end

# Set EDITOR, from most to least preferred
if command -q emacsclient
    set -gx EDITOR emacsclient
else if command -q emacs
    set -gx EDITOR emacs
else if command -q mg
    set -gx EDITOR mg
else if command -q vim
    set -gx EDITOR vim
else if command -q vi
    set -gx EDITOR vi
end

# Use bfs as find command in fzf
if command -q fzf
    and command -q bfs
    set -gx FZF_DEFAULT_COMMAND bfs
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
end

# Kill mosh-server if it has been inactive for a week
if command -q mosh-server
    set -gx MOSH_SERVER_NETWORK_TMOUT 604800
end

# GOPATH
if [ -d "$HOME/go" ]
    set -gx GOPATH $HOME/go
    fish_add_path --prepend $GOPATH/bin
end

# JAVA_HOME
if [ -x /usr/libexec/java_home ]
    set -l java_home (/usr/libexec/java_home 2> /dev/null)
    if [ -n "$java_home" ]
        set -gx JAVA_HOME $java_home
    end
end

# Config below is only relevant for interactive use
if not status is-interactive
    return 0
end

########## Keybindings ##########

# C-o edits command
bind \co edit_command_buffer

########## Aliases ##########

# Show restic diff for the most recent snapshot. If offset is given, show the
# diff for the nth most recent snapshot instead
function restic-review
    set offset $argv[1]
    if [ -z "$offset" ]
        set offset 0
    end
    set matched (string match --regex "^[0-9]+" $offset)
    if [ (count $argv) -gt 1 ]
        or [ "$matched" != "$offset" ]
        echo "usage: restic-review [OFFSET]" 1>&2
        return 1
    end
    restic snapshots --group-by host --host (hostname -s) |
        grep -Eo "^[a-f0-9]{8,}" | tail -(math 2 + $offset) |
        head -2 |
        xargs -r restic diff
end

# Fuzzy-finding wrapper for brew install, info and uninstall
function brew-fzf
    switch $argv[1]
        case info install uninstall
            cat (brew formulae | psub) (brew casks | sed "s/^/--cask /" | psub) | fzf --multi | xargs -r brew "$argv[1]"
        case "*"
            echo "usage: brew-fzf [ info | install | uninstall ]" 1>&2
            return 1
    end
end

# ls alias
set -l ls_opts "--group-directories-first --color=auto"
switch $uname
    case Darwin FreeBSD
        if command -q gls
            alias ls "gls $ls_opts"
            alias ll "gls $ls_opts -lh"
        else if command -q gnuls
            alias ls "gnuls $ls_opts"
            alias ll "gnuls $ls_opts -lh"
        else
            alias ls "ls -G"
            alias ll "ls -Glh"
        end
    case "*"
        alias ls "ls $ls_opts"
        alias ll "ls $ls_opts -lh"
end

# Activate or deactivate a virtualenv in the directory venv
function venv
    set venv $argv[1]
    if [ -z "$venv" ]
        set venv .venv
    end
    set venv (realpath $venv)
    set activate "$venv/bin/activate.fish"
    if [ -n "$VIRTUAL_ENV" ]
        echo "venv: deactivating $VIRTUAL_ENV" 1>&2
        deactivate
    else if [ -f "$activate" ]
        echo "venv: activating $venv" 1>&2
        source "$activate"
    else
        echo "venv: $activate not found" 1>&2
        return 1
    end
end

# A shell variant of the locate-dominating-file function found in Emacs
function locate-dominating-file
    if [ (count $argv) -lt 2 ]
        echo "usage: locate-dominating-file START-PATH FILE" 1>&2
        return 1
    end
    set file $argv[1]
    set name $argv[2]
    set dir $file
    # If given file is indeed a file, we start in its directory
    if not [ -d "$dir" ]
        set dir (path dirname "$dir")
    end
    if not [ -d "$dir" ]
        echo "locate-dominating-file: $dir is not a directory" 1>&2
        return 1
    end
    set cur_dir $dir
    while true
        set cur_dir (realpath $cur_dir)
        if [ -e "$cur_dir/$name" ]
            echo "$cur_dir"
            break
        else if [ "$cur_dir" = / ]
            echo "locate-dominating-file: $name not found in $dir or any of its parents" 1>&2
            return 1
        end
        set cur_dir "$cur_dir/.."
    end
end

# Change directory to the nearest one containing the given file or directory
#
# Example:
#
# ~/project/some/deep/path$ cdn .git # or README.md, go.mod etc.
# ~/project$
#
function cdn
    cd (locate-dominating-file "$PWD" $argv[1])
end

# Abbreviations (expand when typed)
abbr --add diff "diff --color=auto"
abbr --add ec "emacsclient -nq"
abbr --add grep "grep --color=auto"
abbr --add mg "mg -n"
abbr --add ta 'tmux new-session -AD -s $LOGNAME'
abbr --add week "date +%V"
abbr --add reload "exec fish"
if command -q bfs
    # Prefer bfs as find
    abbr --add find bfs
end
if command -q apt
    abbr --add aptup "sudo apt update && sudo apt upgrade"
    # This is the most precise method I've found for answering the question
    # "which packages did I install explicitly?"
    #
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=727799
    # https://stackoverflow.com/q/58309013/22831
    abbr --add apt-leaves 'sudo grep -oP "Unpacking \K[^: ]+" /var/log/installer/syslog | sort -u | comm -13 /dev/stdin (apt-mark showmanual | sort | psub)'
end
if command -q brew
    abbr --add brewup "brew update && brew upgrade -n"
end

########## Extensions ##########

set -l fzf_ext_brew $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.fish
set -l fzf_ext_debian /usr/share/doc/fzf/examples/key-bindings.fish
set -l fzf_ext_fedora /usr/share/fzf/shell/key-bindings.fish

if source $fzf_ext_brew 2>/dev/null || source $fzf_ext_debian 2>/dev/null || source $fzf_ext_fedora 2>/dev/null
    fzf_key_bindings
end

########## Appearance ##########

# Remove greeting
set fish_greeting

# Prompt
set -g __fish_git_prompt_color_branch red
set -g fish_color_user green
set -g fish_color_host green
set -g fish_color_at green
set -g fish_color_cwd blue
set -g fish_color_command green
# Don't shorten working directory in prompt
set -g fish_prompt_pwd_dir_length 0
# Make autosuggestion text slightly brighter
set -g fish_color_autosuggestion 8a8a8a

# Local configuration
source $HOME/.config/fish/local.fish 2>/dev/null
