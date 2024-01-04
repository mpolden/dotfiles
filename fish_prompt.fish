function fish_prompt --description "Write out the prompt"
        set last_status $status
        if not set -q __fish_prompt_hostname
                set -g __fish_prompt_hostname (hostname -s)
        end

        set normal (set_color normal)
        set -q fish_color_at
        or set -U fish_color_at $normal

        # Add user@host when connected through SSH or using toolbox
        set ssh_prefix
        if set -q SSH_CLIENT
            or set -q SSH_TTY
            or set -q SSH_CONNECTION
            or set -q TOOLBOX_PATH
                set ssh_prefix (set_color $fish_color_user) $USER \
                (set_color $fish_color_at) @ (set_color $fish_color_host) \
                $__fish_prompt_hostname $normal ":"
        end

        # Color prompt symbol based on exit status. Inspired by
        # https://solovyov.net/blog/2020/useful-shell-prompt/
        set __prompt_symbol '$'
        if [ $last_status -ne 0 ]
            set __prompt_symbol "$(set_color yellow)\$$normal"
        end

        # Print prompt
        echo -n -s $ssh_prefix (set_color $fish_color_cwd) (prompt_pwd) \
            $normal (__fish_git_prompt " %s") $normal $__prompt_symbol " "
end
