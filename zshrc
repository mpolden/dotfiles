# -*- mode: sh -*-

#
# History. Adapted from the prezto history module.
#

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

HISTFILE="$HOME/.zhistory"       # The path to the history file.
HISTSIZE=100000                  # The maximum number of events to save in the internal history.
SAVEHIST=100000                  # The maximum number of events to save in the history file.

#
# Completion. Adapted from the prezto completion module.
#

setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.
unsetopt AUTO_REMOVE_SLASH # Never remove trailing slash when completing.

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
autoload -Uz compinit
_comp_path="$HOME/.zcompdump"
# #q expands globs in conditional expressions
if [[ $_comp_path(#qNmh-20) ]]; then
    # -C (skip function check) implies -i (skip security check).
    compinit -C -d "$_comp_path"
else
    mkdir -p "$_comp_path:h"
    compinit -i -d "$_comp_path"
    # Keep $_comp_path younger than cache time even if it isn't regenerated.
    touch "$_comp_path"
fi
unset _comp_path

# Defaults.
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zcompcache"

# Case-sensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt CASE_GLOB

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environment Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# SSH/SCP/RSYNC
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Bind Shift + Tab to go to the previous menu item.
# kcbt might not be defined in all terminals
[[ -n "$terminfo[kcbt]" ]] && bindkey -M emacs "$terminfo[kcbt]" reverse-menu-complete

#
# Terminal. Adapted from the prezto terminal module.
#

# Sets the terminal window title.
function set-window-title {
    local title_format{,ted}
    title_format="%s"
    zformat -f title_formatted "$title_format" "s:$argv"
    printf '\e]2;%s\a' "${(V%)title_formatted}"
}

# Sets the terminal tab title.
function set-tab-title {
    local title_format{,ted}
    title_format="%s"
    zformat -f title_formatted "$title_format" "s:$argv"
    printf '\e]1;%s\a' "${(V%)title_formatted}"
}

# Sets the terminal multiplexer tab title.
function set-multiplexer-title {
    local title_format{,ted}
    title_format="%s"
    zformat -f title_formatted "$title_format" "s:$argv"
    printf '\ek%s\e\\' "${(V%)title_formatted}"
}

# Sets the tab and window titles with a given command.
function _terminal-set-titles-with-command {
    emulate -L zsh
    setopt EXTENDED_GLOB

    # Get the command name that is under job control.
    if [[ "${2[(w)1]}" == (fg|%*)(\;|) ]]; then
        # Get the job name, and, if missing, set it to the default %+.
        local job_name="${${2[(wr)%*(\;|)]}:-%+}"

        # Make a local copy for use in the subshell.
        local -A jobtexts_from_parent_shell
        jobtexts_from_parent_shell=(${(kv)jobtexts})

        jobs "$job_name" 2> /dev/null > >(
            read index discarded
            # The index is already surrounded by brackets: [1].
            _terminal-set-titles-with-command "${(e):-\$jobtexts_from_parent_shell$index}"
        )
    else
        # Set the command name, or in the case of sudo, ssh or vpn, the next
        # command.
        local cmd="${${2[(wr)^(*=*|sudo|ssh|vpn|-*)]}:t}"
        local truncated_cmd="${cmd/(#m)?(#c15,)/${MATCH[1,12]}...}"
        unset MATCH

        if [[ "$TERM" == screen* ]]; then
            set-multiplexer-title "$truncated_cmd"
        fi
        set-tab-title "$truncated_cmd"
        set-window-title "$cmd"
    fi
}

# Sets the tab and window titles with a given path.
function _terminal-set-titles-with-path {
    emulate -L zsh
    setopt EXTENDED_GLOB

    local absolute_path="${${1:a}:-$PWD}"
    local abbreviated_path="${absolute_path/#$HOME/~}"
    local truncated_path="${abbreviated_path/(#m)?(#c15,)/...${MATCH[-12,-1]}}"
    unset MATCH

    if [[ "$TERM" == screen* ]]; then
        set-multiplexer-title "$truncated_path"
    fi
    set-tab-title "$truncated_path"
    set-window-title "$abbreviated_path"
}

function set-terminal-title {
    autoload -Uz add-zsh-hook
    if [[ "$TERM_PROGRAM" == 'Apple_Terminal' ]]; then
        # Sets the Terminal.app current working directory before the prompt is
        # displayed.
        function _terminal-set-terminal-app-proxy-icon {
            printf '\e]7;%s\a' "file://${HOST}${PWD// /%20}"
        }
        add-zsh-hook precmd _terminal-set-terminal-app-proxy-icon

        # Unsets the Terminal.app current working directory when a terminal
        # multiplexer or remote connection is started since it can no longer be
        # updated, and it becomes confusing when the directory displayed in the title
        # bar is no longer synchronized with real current working directory.
        function _terminal-unset-terminal-app-proxy-icon {
            if [[ "${2[(w)1]:t}" == (screen|tmux|dvtm|ssh|mosh) ]]; then
                print '\e]7;\a'
            fi
        }
        add-zsh-hook preexec _terminal-unset-terminal-app-proxy-icon

        # Do not set the tab and window titles in Terminal.app since it sets the tab
        # title to the currently running process by default and the current working
        # directory is set separately.
    else
        # Sets titles before the prompt is displayed.
        add-zsh-hook precmd _terminal-set-titles-with-path

        # Sets titles before command execution.
        add-zsh-hook preexec _terminal-set-titles-with-command
    fi
}

# Only set titles for regular terminals
case "$TERM" in
    dumb|eterm*)
        # Ignore unsupported terminals, e.g. TRAMP or an Emacs terminal emulator.
        ;;
    *)
        set-terminal-title
        ;;
esac

#
# Prompt
#

function load-prompt {
    setopt PROMPT_SUBST

    # Call vcs_info before every command
    autoload -Uz add-zsh-hook vcs_info colors && colors
    add-zsh-hook precmd vcs_info

    # Enable git support only
    zstyle ':vcs_info:*' enable git

    # Display branch
    zstyle ':vcs_info:*' formats ' %F{red}%b%f'

    # Add user@host when connected through SSH
    local ssh_prefix
    if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
        ssh_prefix="%{$fg_bold[green]%}%n@%m%{$reset_color%}:"
    fi

    # Define prompt
    PROMPT="${ssh_prefix}%{$fg_bold[blue]%}%~\${vcs_info_msg_0_}%{$reset_color%}$ "
}

autoload -Uz promptinit && promptinit

case "$TERM" in
    dumb)
        # Ignore dumb terminal, e.g. TRAMP.
        prompt off
        unsetopt ZLE
        ;;
    *)
        load-prompt
        ;;
esac

#
# Emacs
#

# Tell Emacs about the current directory
if [[ -n "$INSIDE_EMACS" ]]; then
    function chpwd {
        print -P "\033AnSiTc %d"
    }
    print -P "\033AnSiTu %n"
    print -P "\033AnSiTc %d"
fi

#
# Misc
#

# Change directory without cd
setopt AUTO_CD

# Interactive comments (like bash)
setopt INTERACTIVE_COMMENTS

# Correct commands
setopt CORRECT

# Make forward-word, backward-word etc. stop at path delimiter
export WORDCHARS=${WORDCHARS/\/}

# Print message if reboot is required
[[ -o interactive && -f "/var/run/reboot-required" ]] && print "reboot required"

# Check for mail
autoload -Uz checkmail

# Aliases
[[ -s "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"

# Local configuration
[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

#
# Extensions
#

typeset -A _loaded_extensions

function load-extension {
    local -r name="$1"
    local -r src_path="$2"
    (( ${+_loaded_extensions[$name]} )) && return 0
    [[ ! -s "$src_path" ]] && return 1
    source "$src_path"
    _loaded_extensions[$name]="$src_path"
    return 0
}

function load-syntax-highlighting {
    local -r name="zsh-syntax-highlighting"
    load-extension $name "/usr/share/${name}/${name}.zsh"         # dpkg on Debian
    load-extension $name "/usr/local/share/${name}/${name}.zsh"   # Homebrew on macOS
    load-extension $name "$HOME/.local/share/${name}/${name}.zsh" # Home directory
    [[ $? -ne 0 ]] && return

    # Set highlight colors
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[function]='fg=blue'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=blue'
    ZSH_HIGHLIGHT_STYLES[comment]='fg=white'
}

# zsh-syntax-highlighting should be initialized as late as possible because it
# wraps ZLE widgets.
load-syntax-highlighting

# Load fzf keybindings and completion. E.g. C-r searches history using fzf.
load-extension fzf-bindings "/usr/local/opt/fzf/shell/key-bindings.zsh"    # Homebrew on macOS
load-extension fzf-bindings "/usr/share/doc/fzf/examples/key-bindings.zsh" # dpkg on Debian
load-extension fzf-completion "/usr/local/opt/fzf/shell/completion.zsh"    # Homebrew on macOS
load-extension fzf-completion "/usr/share/doc/fzf/examples/completion.zsh" # dpkg on Debian

# Re-read history before invoking history widget.
# Inspired by https://superuser.com/questions/843138/how-can-i-get-zsh-shared-history-to-work
_history_widget="${$(bindkey '^R')[(ws: :)2]}"

function history-widget-with-reload {
    [[ -o sharehistory ]] && fc -RI
    zle "$_history_widget"
}

if zle -l "$_history_widget"; then
    zle -N history-widget-with-reload
    bindkey '^R' history-widget-with-reload
fi

# Ensure fpath does not contain duplicates
typeset -gU fpath

# Cleanup
unfunction load-extension \
           load-syntax-highlighting \
           load-prompt \
           set-terminal-title
unset _loaded_extensions
