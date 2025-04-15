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
# Package manager for Kubernetes
brew "helm"
# Test network throughput
brew "iperf3"
# Wrangle JSON
brew "jq"
# Interactive Kubernetes CLI
brew "k9s"
# Run a local Kubernetes cluster
brew "kind"
# Standard Kubernetes CLI
brew "kubectl"
# CLI for Mac App Store
brew "mas"
# A better ssh
brew "mosh"
# A better ping, without the graph
brew "mtr"
# Wrangle most compression formats
brew "p7zip"
# Convert between many text formats
brew "pandoc"
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
# Trash files from the command line. Sonoma comes with trash command
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
# A better Spotlight and clipboard history
cask "alfred" if MacOS.version < :sonoma
# Make C++ bearable
cask "clion"
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
cask "intellij-idea"
# Remote development launcher for JetBrains IDEs
cask "jetbrains-gateway"
# Password manager
cask "keepassxc"
# Run local LLMs
cask "lm-studio" if Hardware::CPU.arm?
# Clipboard history. Sonoma is required since 2.x
cask "maccy" if MacOS.version >= :sonoma
# Window manager. Sequoia introduced native tiling
cask "moom" if MacOS.version < :sequoia
# RSS client
cask "netnewswire"
# Store SSH keys in the Secure Enclave
cask "secretive"
# Synchronize files without the cloud
cask "syncthing"
# Anonymous browser
cask "tor-browser"
# WireGuard client
mas "WireGuard", id: 1451685025 if system("defaults read MobileMeAccounts Accounts &> /dev/null")
