CURDIR ?= $(.CURDIR)

LN_FLAGS = -sfn

symlinks = .gitconfig \
		   .gitignore \
		   .hgrc \
		   .lftprc \
		   .screenrc \
		   .synergy.conf \
		   .tmux.conf \
		   .vim \
		   .vimrc \
		   .zlogin \
		   .zpreztorc \
		   .zsh_aliases \
		   .zshenv \
		   .zshrc

xsymlinks = .fonts.conf \
			.i3 \
			.i3status.conf \
			.Xresources

.PHONY: $(symlinks) $(xsymlinks)

COLOR = \033[32;01m
NO_COLOR = \033[0m

help:
	@echo "Makefile for installing dotfiles"
	@echo
	@echo "Create symlinks:"
	@echo "   $(COLOR)make install$(NO_COLOR)		Install symlinks"
	@echo "   $(COLOR)make install-x$(NO_COLOR)	Install X11 symlinks"
	@echo
	@echo "Install vim and shell extras:"
	@echo "   $(COLOR)make vim-extras$(NO_COLOR)	Install vim bundles"
	@echo "   $(COLOR)make zsh-extras$(NO_COLOR)	Install prezto and z"
	@echo "   $(COLOR)make z$(NO_COLOR)		Install z"
	@echo "   $(COLOR)make prezto$(NO_COLOR)		Install prezto"
	@echo
	@echo "Install common packages:"
	@echo "   $(COLOR)make deb-deps$(NO_COLOR)	Install Debian packages"
	@echo "   $(COLOR)make deb-deps-x$(NO_COLOR)	Install Debian packages \
(X11)"
	@echo "   $(COLOR)make arch-deps$(NO_COLOR)	Install Arch Linux packages"
	@echo
	@echo "Install Sublime Text 2 config:"
	@echo "   $(COLOR)make st2$(NO_COLOR)		Install Sublime Text 2 config"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make clean$(NO_COLOR)		Delete vim bundles"
	@echo "   $(COLOR)make check-dead$(NO_COLOR)	Print dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)	Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull --rebase"
	@echo
	@echo "Useful aliases:"
	@echo "   $(COLOR)make all$(NO_COLOR)		install vim-extras zsh-extras"
	@echo "   $(COLOR)make all-x$(NO_COLOR)		install-x deb-deps deb-deps-x"

# Shell environment

all: install vim-extras zsh-extras

clean:
	rm -rf -- $(CURDIR)/dot.vim/bundle/*

install: $(symlinks)

$(symlinks):
	test -e $(CURDIR)/dot$@ && ln $(LN_FLAGS) $(CURDIR)/dot$@ ~/$@

vim-extras:
	mkdir -p $(CURDIR)/dot.vim/bundle
	test -d $(CURDIR)/dot.vim/bundle/vundle || \
		(git clone --quiet https://github.com/gmarik/vundle.git \
		$(CURDIR)/dot.vim/bundle/vundle && \
		vim +BundleInstall +qall > /dev/null)

zsh-extras: z prezto

z:
	test -d ~/.zcmd || \
		git clone --quiet https://github.com/rupa/z.git ~/.zcmd

prezto:
	test -d ~/.zprezto || \
		git clone --quiet --recursive \
		https://github.com/sorin-ionescu/prezto.git ~/.zprezto

check-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase


# X environment

all-x: install-x deb-deps deb-deps-x

install-x: $(xsymlinks)

$(xsymlinks):
	test -e $(CURDIR)/dot$@ && ln $(LN_FLAGS) $(CURDIR)/dot$@ ~/$@

# Packages

deb-deps:
	test -f /etc/debian_version && \
		aptitude install --assume-yes git htop make mosh rsync tig tmux vim zsh

deb-deps-x:
	test -f /etc/debian_version && \
		aptitude install --assume-yes xserver-xorg x11-xserver-utils slim i3 \
		fonts-liberation rxvt-unicode-256color

arch-deps:
	test -f /etc/arch-release && \
		pacman --sync --needed git htop make mosh rsync tig tmux vim zsh

# Sublime Text 2
OS = $(shell uname -s)
ifeq ($(OS),Darwin)
	ST2_PATH = ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User
endif
ifeq ($(OS),Linux)
	ST2_PATH = ~/.config/sublime-text-2
endif
st2:
	@test -n "$(ST2_PATH)" || \
		(echo "ST2_PATH is undefined. No idea where to put symlinks" && exit 1)
	ln $(LN_FLAGS) $(CURDIR)/dot.sublime-text-2/Preferences.sublime-settings \
		$(ST2_PATH)/Preferences.sublime-settings
	ln $(LN_FLAGS) \
		$(CURDIR)/dot.sublime-text-2/Package\ Control.sublime-settings \
		$(ST2_PATH)/Package\ Control.sublime-settings
