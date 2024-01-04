# -*- mode: fish -*-

########## Helper functions ##########

# Wrapper around fish_add_path that verifies path existence
function path-prepend
    [ -d "$argv[1]" ]; and fish_add_path --prepend $argv[1]
end

# Wrapper around fish_add_path that verifies path existence
function path-append
    [ -d "$argv[1]" ]; and fish_add_path --append $argv[1]
end

# Append given path to CDPATH
function cdpath-append
    set _path $argv[1]
    if [ -d "$_path" ]
        and not contains $_path $CDPATH
        set -gx CDPATH $CDPATH $_path
    end
end

# Returns whether given command is in PATH
function is-command
    command -q $argv[1]
end

# Create an alias only if the aliased command is in PATH
function cond-alias
    set name $argv[1]
    set values (string split " " $argv[2])
    set cmd $values[1]
    switch $cmd
        case sudo cd cat exec
            # Trim ( prefix from command
            set cmd (string trim --left --chars "(" $values[2])
    end
    if is-command $cmd
        alias $name "$values"
    end
end

########## Environment ##########

# Locale
switch (uname)
    case Darwin
        set -gx LANG "en_US.UTF-8"
        # iTerm may choose to set an invalid LC_CTYPE
        # https://superuser.com/a/1400419
        set -gx LC_CTYPE "en_US.UTF-8"
        # Norwegian time locale
        set -gx LC_TIME "no_NO.UTF-8"
    case Linux
        set -gx LANG "en_US.UTF-8"
        # Norwegian locale on Linux is named differently
        set -gx LC_TIME "nb_NO.UTF-8"
end

# Set TERM
switch $TERM
    case "xterm*"
        set -gx TERM "xterm-256color"
    case "screen*" "tmux*"
        # OS may lack terminfo entry for tmux-256color
        # https://github.com/tmux/tmux/issues/2262
        set -gx TERM "screen-256color"
end

# Homebrew
if [ -x /usr/local/bin/brew ]
    eval $(/usr/local/bin/brew shellenv)
else if [ -x /opt/homebrew/bin/brew ]
    eval $(/opt/homebrew/bin/brew shellenv)
end
if is-command brew
    set -gx HOMEBREW_NO_ANALYTICS 1
    set -gx HOMEBREW_NO_AUTO_UPDATE 1
end

# Set PATH
path-prepend "/usr/local/sbin"
path-prepend "/usr/local/bin"
path-prepend "/Library/TeX/texbin"
path-prepend "/Applications/IntelliJ IDEA CE.app/Contents/plugins/maven/lib/maven3/bin"
path-prepend "$HOME/.local/bin"
path-prepend "$HOME/.cargo/bin"

# Set CDPATH
cdpath-append $HOME
cdpath-append $HOME/p

# Configure less
if is-command less
    set -gx LESS "-Ri"
    set -gx PAGER "less"
    # Add colors to man pages
    set -gx LESS_TERMCAP_mb (printf "\e[1;32m")  # Begins blinking.
    set -gx LESS_TERMCAP_md (printf "\e[1;32m")  # Begins bold.
    set -gx LESS_TERMCAP_me (printf "\e[0m")     # Ends mode.
    set -gx LESS_TERMCAP_se (printf "\e[0m")     # Ends standout-mode.
    set -gx LESS_TERMCAP_so (printf "\e[1;31m")  # Begins standout-mode.
    set -gx LESS_TERMCAP_ue (printf "\e[0m")     # Ends underline.
    set -gx LESS_TERMCAP_us (printf "\e[4m")     # Begins underline.
end

# Set EDITOR, from most to least preferred
if is-command emacsclient
    set -gx EDITOR "emacsclient"
else if is-command emacs
    set -gx EDITOR "emacs"
else if is-command mg
    set -gx EDITOR "mg"
else if is-command jmacs
    set -gx EDITOR "jmacs"
else if is-command vim
    set -gx EDITOR "vim"
else if is-command vi
    set -gx EDITOR "vi"
end

# Remove mosh prefix from terminal title
if is-command mosh
    set -gx MOSH_TITLE_NOPREFIX 1
end

# Use bfs as find command in fzf
if is-command fzf
    and is-command bfs
    set -gx FZF_DEFAULT_COMMAND bfs
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
end

# Kill mosh-server if it has been inactive for a week
if is-command mosh-server
    set -gx MOSH_SERVER_NETWORK_TMOUT 604800
end

# GOPATH
if [ -d "$HOME/go" ]
    set -gx GOPATH $HOME/go
    path-prepend $GOPATH/bin
end

# JAVA_HOME
if [ -x /usr/libexec/java_home ]
    set -l java_home (/usr/libexec/java_home 2> /dev/null)
    if [ -n "$java_home" ]
        set -gx JAVA_HOME $java_home
    end
end

# MAVEN_OPTS
# Prevent Maven from running tasks in the foreground
if is-command mvn
    set -gx MAVEN_OPTS "-Djava.awt.headless=true"
end

########## Aliases ##########

# Display ANSI art typically found .nfo files correctly
function nfoless
    set pager $PAGER
    if [ -z "$pager" ]
        set pager less
    end
    iconv -f 437 -t utf-8 $argv | $pager
end

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
    restic snapshots --group-by host --host (hostname -s) | \
        grep -Eo "^[a-f0-9]{8,}" | \
        tail -(math 2 + $offset) | \
        head -2 | \
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

# diff alias
function alias-diff
    # Use colors in diff output when supported
    if diff --color=auto /dev/null /dev/null 2> /dev/null
        alias diff "diff --color=auto"
    end
end

alias-diff

# ls alias
function alias-ls
    set ls_opts "--group-directories-first --color=auto"
    switch (uname)
        case Darwin FreeBSD
            if is-command gls
                alias ls "gls $ls_opts"
                alias ll "gls $ls_opts -lh"
            else if is-command gnuls
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
end

alias-ls

# Activate or deactivate a virtualenv in the directory venv
function venv
    set venv $argv[1]
    if [ -z "$venv" ]
        set venv .venv
    end
    set venv (realpath $venv)
    set activate "$venv/bin/activate"
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
        else if [ "$cur_dir" = "/" ]
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

cond-alias aptup "sudo apt update; and sudo apt upgrade"
cond-alias ec "emacsclient -nq"
cond-alias find bfs
cond-alias git-root "cd (git rev-parse --show-toplevel)"
cond-alias grep "grep --color=auto"
cond-alias mg "mg -n"
cond-alias ta 'tmux new-session -AD -s $LOGNAME'
cond-alias week "date +%V"
cond-alias reload "exec fish"
if is-command "apt-mark"
    # This is the most precise method I've found for answering the question
    # "which packages did I install explicitly?"
    #
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=727799
    # https://stackoverflow.com/q/58309013/22831
    alias apt-leaves 'sudo grep -oP "Unpacking \K[^: ]+" /var/log/installer/syslog | sort -u | comm -13 /dev/stdin (apt-mark showmanual | sort | psub)'
end


########## Extensions ##########

if status is-interactive
    and source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.fish" 2> /dev/null
    fzf_key_bindings
end

########## Behavior ##########

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

# Print message if reboot is required
if status is-interactive
    and [ -n "$TERM" ]
    and [ -f /var/run/reboot-required ]
    echo "reboot required"
end

# Local configuration
source $HOME/.config/fish/local.fish 2> /dev/null

# Clean up functions
if not is-command brew
    functions -e brew-fzf
end
functions -e path-prepend path-append cdpath-append is-command cond-alias \
    alias-diff alias-ls
