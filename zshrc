#
# History
#

HISTFILE="${ZDOTDIR:-$HOME}/.zhistory"       # The path to the history file.
HISTSIZE=10000                   # The maximum number of events to save in the internal history.
SAVEHIST=10000                   # The maximum number of events to save in the history file.

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

#
# Functions
#

function set-fpath {
    # Cannot be written as local -r paths=(...) as it doesn't work in zsh 5.0
    local paths
    paths=(
        /usr/local/share/zsh-completions
        $HOME/.local/share/zsh-completions/src
        $HOME/.zpackages/zsh-completions/src
        $HOME/.zfunctions
    )
    for p in $paths; do
        if [[ -d "$p" ]]; then
            fpath=($p $fpath)
        fi
    done
}

set-fpath

#
# Completion
#

autoload -Uz compinit && compinit -i

setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
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

# Increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

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

# Environmental Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
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

# Media Players
zstyle ':completion:*:*:mpg123:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:mpg321:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG|flac):ogg\ files *(-/):directories'
zstyle ':completion:*:*:mocp:*' file-patterns '*.(wav|WAV|mp3|MP3|ogg|OGG|flac):ogg\ files *(-/):directories'

# SSH/SCP/RSYNC
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Bind Shift + Tab to go to the previous menu item.
# kcbt might not be defined in all terminals
[[ -n "$terminfo[kcbt]" ]] && bindkey -M emacs "$terminfo[kcbt]" reverse-menu-complete

#
# Prompt
#

function _set-prompt-symbol {
    local -r burger=$(print -n "\xF0\x9F\x8D\x94")
    local -r coffee=$(print -n "\xE2\x98\x95")
    local -r beer=$(print -n "\xF0\x9F\x8D\xBA")
    local -r hour=$(strftime %-k $EPOCHSECONDS)
    if (( $hour >= 8 && $hour < 16 )); then
        _prompt_symbol="$coffee "
    elif (( $hour >= 16 && $hour < 19 )); then
        _prompt_symbol="$burger "
    else
        _prompt_symbol="$beer "
    fi
}

function set-prompt {
    setopt LOCAL_OPTIONS
    unsetopt XTRACE KSH_ARRAYS
    prompt_opts=(cr percent subst)

    # Load required functions.
    autoload -Uz add-zsh-hook vcs_info colors && colors

    # Add hook for calling vcs_info before each command.
    add-zsh-hook precmd vcs_info

    # Set vcs_info parameters.
    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' formats ' %F{red}%b%c%f'

    # Prefix to use when connected through SSH
    local -r ssh_prefix='%{$fg_bold[green]%}%n@%m%{$reset_color%}:'

    # Display fancy symbol on darwin
    _prompt_symbol='$'
    if [[ "$OSTYPE" == darwin* ]]; then
        zmodload -F zsh/datetime b:strftime p:EPOCHSECONDS
        add-zsh-hook precmd _set-prompt-symbol
    fi

    # Define prompts.
    PROMPT="${SSH_TTY:+$ssh_prefix}"'%{$fg_bold[blue]%}%~${vcs_info_msg_0_}%{$reset_color%}$_prompt_symbol '
}

autoload -Uz promptinit && promptinit

# Use pure prompt if available
if (( $+functions[prompt_pure_setup] )); then
    prompt pure
else
    setopt PROMPT_SUBST
    set-prompt
fi

#
# SSH
#

if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    # Set the path to the environment file if not set by another module.
    _ssh_agent_env="${_ssh_agent_env:-${TMPDIR:-/tmp}/ssh-agent.env}"

    # Export environment variables.
    source "$_ssh_agent_env" 2> /dev/null

    # Start ssh-agent if not started.
    if ! ps -U "$LOGNAME" -o pid,ucomm | grep -q -- "${SSH_AGENT_PID:--1} ssh-agent"; then
        eval "$(ssh-agent | sed '/^echo /d' | tee "$_ssh_agent_env")"
    fi

    unset _ssh_agent_env
fi

#
# Terminal
#

# Sets the terminal or terminal multiplexer window title.
function set-window-title {
    local title_format{,ted}
    title_format="%s"
    zformat -f title_formatted "$title_format" "s:$argv"

    if [[ "$TERM" == screen* ]]; then
        title_format="\ek%s\e\\"
    else
        title_format="\e]2;%s\a"
    fi

    printf "$title_format" "${(V%)title_formatted}"
}

# Sets the terminal tab title.
function set-tab-title {
    local title_format{,ted}
    title_format="%s"
    zformat -f title_formatted "$title_format" "s:$argv"

    printf "\e]1;%s\a" ${(V%)title_formatted}
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

        jobs "$job_name" 2>/dev/null > >(
            read index discarded
            # The index is already surrounded by brackets: [1].
            _terminal-set-titles-with-command "${(e):-\$jobtexts_from_parent_shell$index}"
        )
    else
        # Set the command name, or in the case of sudo or ssh, the next command.
        local cmd="${${2[(wr)^(*=*|sudo|ssh|-*)]}:t}"
        local truncated_cmd="${cmd/(#m)?(#c15,)/${MATCH[1,12]}...}"
        unset MATCH

        set-window-title "$cmd"
        set-tab-title "$truncated_cmd"
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

    set-window-title "$abbreviated_path"
    set-tab-title "$truncated_path"
}

# Do not modify titles when inside tmux
if [[ -z "$TMUX" ]]; then
    autoload -Uz add-zsh-hook

    # Sets the tab and window titles before the prompt is displayed.
    add-zsh-hook precmd _terminal-set-titles-with-path

    # Sets the tab and window titles before command execution.
    add-zsh-hook preexec _terminal-set-titles-with-command
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

# Print message if reboot is required
[[ -f "/var/run/reboot-required" ]] && print "reboot required"

# Aliases
[[ -s "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"
[[ -s "$HOME/.zsh_aliases.local" ]] && source "$HOME/.zsh_aliases.local"

# Local configuration
[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

#
# Extensions
#

function init-syntax-highlighting {
    local paths
    paths=(
        /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        $HOME/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        $HOME/.zpackages/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    )
    for p in $paths; do
        if [[ -s "$p" ]]; then
            source "$p"
            ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
            ZSH_HIGHLIGHT_STYLES[function]='fg=blue'
            ZSH_HIGHLIGHT_STYLES[alias]='fg=blue'
            ZSH_HIGHLIGHT_STYLES[comment]='fg=white'
            break
        fi
    done
}

function init-history-substring-search {
    local paths
    paths=(
        /usr/local/opt/zsh-history-substring-search/zsh-history-substring-search.zsh
        $HOME/.local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
        $HOME/.zpackages/zsh-history-substring-search/zsh-history-substring-search.zsh
    )
    for p in $paths; do
        if [[ -s "$p" ]]; then
            source "$p"
            # Bind C-P/C-N in Emacs mode
            bindkey -M emacs "\C-P" history-substring-search-up
            bindkey -M emacs "\C-N" history-substring-search-down
            # Bind arrow keys in all modes
            bindkey '^[[A' history-substring-search-up
            bindkey '^[[B' history-substring-search-down
            HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=magenta"
            HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red"
            # Case-sensitive search
            HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS="${HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS//i}"
            break
        fi
    done
}

# zsh-syntax-highlighting should be initialized as late as possible because it
# wraps ZLE widgets.
init-syntax-highlighting

# When using both zsh-history-substring-search and zsh-syntax-highlighting, the
# former should be initialized last.
init-history-substring-search

# Clean up functions
unfunction init-syntax-highlighting \
           init-history-substring-search \
           set-fpath \
           set-prompt
