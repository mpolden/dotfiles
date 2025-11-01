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
    set -gx HOMEBREW_NO_ENV_HINTS 1
end

# Set PATH
#
# System-wide executables not owned by the OS
fish_add_path --global /usr/local/bin
# Keg-only formulae
fish_add_path --global "$HOMEBREW_PREFIX/opt/trash/bin"
fish_add_path --global "$HOMEBREW_PREFIX/opt/node@24/bin"
fish_add_path --global "$HOMEBREW_PREFIX/opt/ruby/bin"
# IntelliJ executables
set -l idea_bundles \
    # Homebrew cask paths \
    "/Applications/IntelliJ IDEA CE.app" \
    "/Applications/IntelliJ IDEA.app" \
    # Toolbox paths \
    "$HOME/Applications/IntelliJ IDEA Community Edition.app" \
    "$HOME/Applications/IntelliJ IDEA Ultimate.app"
for bundle in $idea_bundles
    # Contains 'idea' command, for opening files in IDEA from CLI
    fish_add_path --global "$bundle/Contents/MacOS"
end
# Language-specific executables
fish_add_path --global "$HOME/.gem/ruby/3.4.0/bin"
fish_add_path --global "$HOME/.cargo/bin"
fish_add_path --global "$HOME/go/bin"
# User-specific executables
fish_add_path --global "$HOME/.local/bin"

# Set CDPATH
set -gx CDPATH . $HOME $HOME/git

# Configure less
if command -q less
    set -gx LESS -Ri
    set -gx PAGER less
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
[ -d "$HOME/go" ] && set -gx GOPATH $HOME/go

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

# C-x C-e edits command
bind ctrl-x,ctrl-e edit_command_buffer

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

# ls alias
set -l ls ls
set -l ls_opts "--color=auto"
set -l ls_opts_gnu "$ls_opts --group-directories-first"
switch $uname
    case Darwin
        if command -q gls
            set ls gls
            set ls_opts "$ls_opts_gnu"
        end
    case FreeBSD
        if command -q gnuls
            set ls gnuls
            set ls_opts "$ls_opts_gnu"
        end
    case Linux
        set ls_opts "$ls_opts_gnu"
end
alias ls "$ls $ls_opts"
alias ll "$ls $ls_opts -Alh"

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
    set path (locate-dominating-file "$PWD" $argv[1])
    [ -n "$path" ] && cd "$path"
end

# Abbreviations (expand when typed)
abbr --add diff "diff -u"
abbr --add ec "emacsclient -n"
abbr --add mg "mg -n"
abbr --add ta 'tmux new-session -AD -s $LOGNAME'
abbr --add week "date +%V"
abbr --add reload "exec fish"
# Avoid sending LC_TIME. See comment at the start of this file
abbr --add mosh "env -u LC_TIME mosh"
if command -q bfs
    # Prefer bfs as find. This is an alias because bfs is compatible with find
    # flags, so the alias doesn't hide anything
    alias find bfs
end
if command -q brew
    abbr --add pkgup "brew update && brew upgrade -n"
    abbr --add pkgls "sort (brew leaves | psub) (brew list --cask | psub)"
else if command -q apt
    abbr --add pkgup "sudo apt update && sudo apt upgrade"
    # This is the most precise method I've found for answering the question
    # "which packages did I install explicitly?"
    #
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=727799
    # https://stackoverflow.com/q/58309013/22831
    abbr --add pkgls 'sudo grep -oP "Unpacking \K[^: ]+" /var/log/installer/syslog | sort -u | comm -13 /dev/stdin (apt-mark showmanual | sort | psub)'
else if command -q rpm-ostree
    abbr --add pkgup "rpm-ostree upgrade --preview"
    abbr --add pkgls "rpm-ostree status --json | jq -r '.deployments|map(select(.booted))|.[].packages[]' "
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
# Use same color for comments
set -g fish_color_comment $fish_color_autosuggestion

# Local configuration
source $HOME/.config/fish/local.fish 2>/dev/null
