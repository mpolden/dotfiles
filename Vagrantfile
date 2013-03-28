# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
  # Ensure noninteractive apt-get
  export DEBIAN_FRONTEND=noninteractive

  # Install packages
  apt-get -y install git make tig tmux vim zsh

  # Set zsh as login shell for vagrant user
  chsh -s /bin/zsh vagrant

  # Clone and install dotfiles as vagrant user
  su -c 'git clone -q https://github.com/martinp/dotfiles.git ~/dotfiles && \
         make -C ~/dotfiles clean install' -l vagrant
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.ssh.forward_agent = true
  config.vm.provision :shell, :inline => $script
end
