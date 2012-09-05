alias aptup='sudo apt-get update && sudo apt-get upgrade'
alias pacsyu='sudo pacman -Syu'
alias git-root='cd $(git rev-parse --show-toplevel)'
alias heroku-cleardb='mysql $(heroku config:get CLEARDB_DATABASE_URL | sed -r -e "s/^mysql:\/\/|\?reconnect=true$//g;s/^/-u /;s/:/ -p/;s/@/ -h /;s/\// /")'
