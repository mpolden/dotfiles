# Shells
alias hal='ssh martin@hal.tihlde.org'
alias sal='ssh martin@sal.tihlde.org'
alias wopr='ssh martin@wopr.tihlde.org'
alias mellow='ssh foo@debian.mellowland.net'
alias atlantis='ssh martin@atlantis.kverka.no'
alias colargol='ssh martinop@colargol.tihlde.org'
alias gremlin='ssh martinop@gremlin.stud.aitel.hist.no'
alias lv-426='ssh martin@lv-426.pythonic.eu'
alias gw='ssh root@gw'

# Package management
alias aptup='sudo apt-get update && sudo apt-get upgrade'
alias pacsyu='sudo pacman-color -Syu --ignore=kernel26'
alias pacrns='sudo pacman-color -Rns'
alias pacqdt='pacman-color -Qdt'
alias pacss='pacman-color -Ss'
alias pacs='sudo pacman-color -S'
alias clysyu='sudo clyde -Syu --ignore=kernel26 --aur'
alias clyss='clyde -Ss'
alias clys='sudo clyde -S'

# Rsync
alias rsync_sal='rsync --archive --delete --verbose --exclude=hlds --exclude=Steam --exclude=rtorrent martin@sal.tihlde.org:~ ~/rsync'
alias rsync_mp3='rsync --archive --delete --verbose martin@wopr.tihlde.org:/glftpd/site/archive/array1/mp3/ ~/Music/'
alias rsync_push='rsync --archive --delete --exclude=rsync --exclude=Music --exclude=.cache --verbose ~/ martin@sal.tihlde.org:~/rsync/hax'
alias rsync_pull='rsync --archive --delete --verbose martin@sal.tihlde.org:~/rsync/hax/ ~/'

# iodine
alias iodined='sudo ~/iodine/bin/iodined -f -u nobody -t /var/empty -c -P Qu5haN8freSPeyU9 172.16.0.1 m.pythonic.eu'
alias iodine='sudo ~/iodine/bin/iodine -f -P Qu5haN8freSPeyU9 m.pythonic.eu'
alias sshproxy='ssh -D 8080 -C -N martin@172.16.0.1'

# Colors for ls and grep
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Gameservers
alias l4d_up='~/hlds/steam -command update -game l4d_full -dir ~/hlds'
alias l4d_cfg='vim ~/hlds/l4d/left4dead/cfg/server.cfg'
alias l4d_start='cd ~/hlds/l4d && ./srcds_run +ip 158.38.48.15'
alias l4d2_up='~/hlds/steam -command update -game left4dead2 -dir ~/hlds'
alias l4d2_cfg='vim ~/hlds/left4dead2/left4dead2/cfg/server.cfg'
alias l4d2_start='cd ~/hlds/left4dead2 && ./srcds_run +ip 158.38.48.15'
alias minecraft_start='cd ~/minecraft && java -Xms512M -Xmx512M -cp minecraft-server.jar com.mojang.minecraft.server.MinecraftServer'

# Site stuff
alias pftp='cd ~/pftp && LD_LIBRARY_PATH=/home/martin/pftp/lib ./pftp'
alias sitebot='telnet localhost 45000'

# irssi
alias irssi-scene='irssi'
alias irssi-pre='irssi --home=~/.irssi2'
alias irssi-legit='irssi --home=~/.irssi3'

