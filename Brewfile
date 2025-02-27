tap "filosottile/musl-cross"
tap "homebrew/bundle"
tap "jimeh/emacs-builds"
tap "mvndaemon/mvnd"

# Easy file encryption
brew "age"
# Configuration management
brew "ansible"
# Used by Emacs (flyspell)
brew "aspell"
# Wrangle AWS
brew "awscli"
# A better find
brew "bfs"
# A better top
brew "btop"
# GNU version of ls
brew "coreutils"
# Print information about the system
brew "fastfetch"
# Used by yt-dlp to wrangle videos
brew "ffmpeg"
# Main shell
brew "fish"
# Fuzzy-find anything
brew "fzf"
# GitHub CLI
brew "gh"
# Used by Emacs (magit) for automatic rebasing
brew "git-absorb"
# Probably the best language
brew "go"
# Language server for the best language
brew "gopls"
# A better ping, with a graph
brew "gping"
# Another better top
brew "htop"
# Test network throughput
brew "iperf3"
# Wrangle JSON
brew "jq"
# CLI for Mac App Store
brew "mas"
# A better ssh
brew "mosh"
# A better ping, without the graph
brew "mtr"
# Wrangle most compression formats
brew "p7zip"
# Wrangle programs distributed as Python packages
brew "pipx"
# Wrangle containers
brew "podman"
# Encode text as a QR code
brew "qrencode"
# rsync for cloud storage
brew "rclone"
# Backup
brew "restic"
# A better grep
brew "ripgrep"
# Python linter
brew "ruff"
# Bash linter
brew "shellcheck"
# Bash formatter
brew "shfmt"
# IP calculator
brew "sipcalc"
# Wrangle locally compiled programs
brew "stow"
# Count lines of code
brew "tokei"
# Trash files from the command line
brew "trash" if MacOS.version < :sonoma
# Pretty-print a directory tree
brew "tree"
# Wrangle VPN configuration
brew "wireguard-tools"
# Download YouTube videos
brew "yt-dlp"
# Cross-compile Go code that has C dependencies
brew "filosottile/musl-cross/musl-cross"
# A better Maven frontend
brew "mvndaemon/mvnd/mvnd@1"
# A better Spotlight (and clipboard history, when Maccy is not supported)
cask "alfred" if MacOS.version < :sonoma
# The true editor
cask "emacs-app"
# The last truly open browser
cask "firefox"
# Excellent programming font
cask "font-iosevka"
# A good terminal emulator
cask "ghostty"
# Video player
cask "iina"
# Java IDE
cask "intellij-idea-ce"
# Password manager
cask "keepassxc"
# Run local LLMs
cask "lm-studio" if Hardware::CPU.arm?
# Clipboard history
cask "maccy" if MacOS.version >= :sonoma
# Window manager
cask "moom"
# RSS client
cask "netnewswire"
# Synchronize files without the cloud
cask "syncthing"
# Anonymous browser
cask "tor-browser"
# Run virtual machines
cask "utm"
# WireGuard client
mas "WireGuard", id: 1451685025 if system("defaults read MobileMeAccounts Accounts &> /dev/null")
