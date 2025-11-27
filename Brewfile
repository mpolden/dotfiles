# frozen_string_literal: true

def work_machine?
  File.exist?(File.join(Dir.home, '.work_machine'))
end

tap 'jimeh/emacs-builds'
tap 'mvndaemon/mvnd'

# Easy file encryption
brew 'age'
# Used by Emacs (flyspell)
brew 'aspell'
# Wrangle AWS
brew 'awscli' if work_machine?
# A better find
brew 'bfs'
# A better top
brew 'btop'
# Apple-optimized container support
brew 'container' if MacOS.version >= :tahoe
# GNU version of ls
brew 'coreutils'
# Print information about the system
brew 'fastfetch'
# Used by yt-dlp to wrangle videos
brew 'ffmpeg'
# Main shell
brew 'fish'
# Fuzzy-find anything
brew 'fzf'
# GitHub CLI
brew 'gh'
# Used by Emacs (magit) for automatic rebasing
brew 'git-absorb'
# Probably the best language
brew 'go'
# Language server for the best language
brew 'gopls'
# A better ping, with a graph
brew 'gping'
# Package manager for Kubernetes
brew 'helm' if work_machine?
# Test network throughput
brew 'iperf3'
# Wrangle JSON
brew 'jq'
# Interactive Kubernetes CLI
brew 'k9s' if work_machine?
# Run a local Kubernetes cluster
brew 'kind' if work_machine?
# Standard Kubernetes CLI
brew 'kubectl' if work_machine?
# CLI for Mac App Store
brew 'mas'
# A better ssh
brew 'mosh'
# A better ping, without the graph
brew 'mtr'
# Runtime for a horrible language
brew 'node@24' if work_machine?
# Convert between many text formats
brew 'pandoc'
# Wrangle programs distributed as Python packages
brew 'pipx'
# A slightly better npm
brew 'pnpm' if work_machine?
# Wrangle containers
brew 'podman'
# Encode text as a QR code
brew 'qrencode'
# rsync for cloud storage
brew 'rclone'
# Backup
brew 'restic'
# A better grep
brew 'ripgrep'
# The only reasonable way to transfer files
brew 'rsync'
# Another horrible language
brew 'ruby' if work_machine?
# Python linter
brew 'ruff'
# Bash linter
brew 'shellcheck'
# Bash formatter
brew 'shfmt'
# IP calculator
brew 'sipcalc'
# Wrangle locally compiled programs
brew 'stow'
# Count lines of code
brew 'tokei'
# Trash files from the command line. Sonoma comes with trash command
brew 'trash' if MacOS.version < :sonoma
# Pretty-print a directory tree
brew 'tree'
# Prose linter
brew 'vale' if work_machine?
# Execute a program periodically
brew 'watch'
# Wrangle VPN configuration
brew 'wireguard-tools'
# A better Maven frontend
brew 'mvndaemon/mvnd/mvnd@1'
# A decent password manager
cask '1password' if work_machine?
# A better Spotlight and clipboard history
cask 'alfred' if MacOS.version < :sonoma
# The last truly open browser
cask 'firefox'
# Customized version of an excellent programming font
cask 'font-aporetic'
# A good terminal emulator
cask 'ghostty'
# Video player
cask 'iina'
# Package manager for JetBrains IDEs
cask 'jetbrains-toolbox' if work_machine?
# The true editor
cask 'jimeh/emacs-builds/emacs-app'
# Password manager
cask 'keepassxc' unless work_machine?
# Clipboard history. Sonoma is required since 2.x
cask 'maccy' if MacOS.version >= :sonoma
# Adjust brightness of external monitors
cask 'monitorcontrol'
# Window manager
cask 'moom'
# RSS client
cask 'netnewswire' unless work_machine?
# Synchronize files without the cloud
cask 'syncthing-app' unless work_machine?
# WireGuard with magic sauce
cask 'tailscale-app' if work_machine?
# Anonymous browser
cask 'tor-browser' unless work_machine?
# WireGuard client
mas 'WireGuard', id: 1_451_685_025 unless work_machine?
