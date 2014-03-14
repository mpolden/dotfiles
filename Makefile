CURDIR ?= $(.CURDIR)

LN_FLAGS = -sfn

symlinks = .gitconfig \
		   .gitignore \
		   .hgrc \
		   .lftprc \
		   .synergy.conf \
		   .tmux.conf \
		   .vim \
		   .vimrc \
		   .zlogin \
		   .zpreztorc \
		   .zsh_aliases \
		   .zshenv \
		   .zshrc

.PHONY: $(symlinks)

COLOR = \033[32;01m
NO_COLOR = \033[0m

help:
	@echo "Makefile for installing dotfiles"
	@echo
	@echo "Create symlinks:"
	@echo "   $(COLOR)make install$(NO_COLOR)		Install symlinks"
	@echo
	@echo "Install vim and shell extras:"
	@echo "   $(COLOR)make vim-extras$(NO_COLOR)	Install vim bundles"
	@echo "   $(COLOR)make zsh-extras$(NO_COLOR)	Install prezto and z"
	@echo "   $(COLOR)make z$(NO_COLOR)		Install z"
	@echo "   $(COLOR)make prezto$(NO_COLOR)		Install prezto"
	@echo
	@echo "Install common packages:"
	@echo "   $(COLOR)make deb-deps$(NO_COLOR)	Install Debian packages"
	@echo
	@echo "Install Sublime Text config:"
	@echo "   $(COLOR)make subl$(NO_COLOR)		Install Sublime Text config"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make clean$(NO_COLOR)		Delete vim bundles"
	@echo "   $(COLOR)make check-dead$(NO_COLOR)	Print dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)	Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull --rebase"
	@echo "   $(COLOR)make rehash$(NO_COLOR)		Source .zshrc in all tmux \
panes"
	@echo
	@echo "Useful aliases:"
	@echo "   $(COLOR)make all$(NO_COLOR)		install vim-extras zsh-extras"

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
	ln $(LN_FLAGS) \
		$(CURDIR)/dot.zprezto/modules/prompt/functions/prompt_debian_setup \
		~/.zprezto/modules/prompt/functions/prompt_debian_setup


# Maintenance

check-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase

rehash:
	test -n "$(TMUX)" && tmux source ~/.tmux.conf
	test -n "$(TMUX)" && ./tmux-rehash-panes.sh

# Packages

deb-deps:
	test -f /etc/debian_version && \
		aptitude install --assume-yes git htop make mosh rsync tig tmux vim zsh

# Sublime Text
OS = $(shell uname -s)
ifeq ($(OS),Darwin)
	ST_PATH = $(HOME)/Library/Application Support/Sublime Text 3/Packages/User
endif
ST_FILES = Default\ (OSX).sublime-keymap \
		   Package\ Control.sublime-settings \
		   Preferences.sublime-settings

$(ST_FILES):
	@test -n "$(ST_PATH)" || \
		(echo "ST_PATH is undefined. No idea where to put symlinks" && exit 1)
	ln $(LN_FLAGS) "$(CURDIR)/dot.sublime-text/$@" "$(ST_PATH)/$@"

subl: $(ST_FILES)
