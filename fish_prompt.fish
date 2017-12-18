function fish_prompt --description 'Write out the prompt'
        if not set -q __fish_prompt_hostname
                set -g __fish_prompt_hostname (hostname -s)
        end

        set -q fish_color_at
        or set -U fish_color_at $normal

        set -l normal (set_color normal)
        set -l ssh_prefix
        if set -q SSH_TTY
                set ssh_prefix (set_color $fish_color_user) $USER \
                (set_color $fish_color_at) @ (set_color $fish_color_host) \
                $__fish_prompt_hostname $normal ':'
        end

        # Display fancy symbol on darwin
        set __prompt_symbol '$'
        if [ -z "$EMACS" -a (uname) = 'Darwin' ]
                set -l burger (echo -ne '\xF0\x9F\x8D\x94')
                set -l coffee (echo -ne '\xE2\x98\x95')
                set -l beer (echo -ne '\xF0\x9F\x8D\xBA')
                set -l hour (date +%-k)
                if [ $hour -ge 8 -a $hour -lt 16 ]
                        set __prompt_symbol "$coffee "
                else if [ $hour -ge 16 -a $hour -lt 19 ]
                        set __prompt_symbol "$burger "
                else
                        set __prompt_symbol "$beer "
                end
        end

        echo -n -s $ssh_prefix (set_color $fish_color_cwd) (prompt_pwd) \
        $normal (__fish_git_prompt ' %s') $normal $__prompt_symbol ' '
end
