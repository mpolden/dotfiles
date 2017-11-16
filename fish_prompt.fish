function fish_prompt --description 'Write out the prompt'
        if not set -q __fish_prompt_hostname
                set -g __fish_prompt_hostname (hostname -s)
        end

        set -q fish_color_at
        or set -U fish_color_at $normal

        set -l normal (set_color normal)
        set -l ssh_prefix
        if set -q SSH_TTY
                set ssh_prefix (set_color $fish_color_user) "$USER" (set_color $fish_color_at) @ (set_color $fish_color_host) "$__fish_prompt_hostname" $normal ':'
        end

        echo -n -s $ssh_prefix (set_color $fish_color_cwd) (prompt_pwd) $normal (__fish_git_prompt ' %s') $normal '$ '
end
