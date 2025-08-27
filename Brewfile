def app_store_available?
  system("defaults read MobileMeAccounts Accounts > /dev/null 2>&1")
end

tap "filosottile/musl-cross"
tap "jimeh/emacs-builds"
tap "mvndaemon/mvnd"

# Easy file encryption
brew "age"
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
# Runtime for a horrible language
brew "node"
# Convert between many text formats
brew "pandoc"
# Wrangle programs distributed as Python packages
brew "pipx"
# Wrangle containers
brew "podman"
# Protoc plugin for gRPC Java
brew "protoc-gen-grpc-java"
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
# Execute a program periodically
brew "watch"
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
# The last truly open browser
cask "firefox"
# Customized version of an excellent programming font
cask "font-aporetic"
# A good terminal emulator
cask "ghostty"
# Video player
cask "iina"
# Package manager for JetBrains IDEs
cask "jetbrains-toolbox"
# The true editor
cask "jimeh/emacs-builds/emacs-app"
# Password manager
cask "keepassxc"
# Run local LLMs
cask "lm-studio" if Hardware::CPU.arm?
# Clipboard history. Sonoma is required since 2.x
cask "maccy" if MacOS.version >= :sonoma
# Window manager
cask "moom"
# RSS client
cask "netnewswire"
# Synchronize files without the cloud
cask "syncthing-app"
# Anonymous browser
cask "tor-browser"
# WireGuard client
mas "WireGuard", id: 1451685025 if app_store_available?
