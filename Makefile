CURDIR ?= $(.CURDIR)

HOSTNAME = $(shell hostname -s)

LN_FLAGS = -sfn

symlinks = ansible.cfg \
		   gitconfig \
		   gitignore \
		   hgrc \
		   lftprc \
		   tmux.conf \
		   zlogin \
		   zpreztorc \
		   zsh_aliases \
		   zshenv \
		   zshrc

.PHONY: $(symlinks)

COLOR = \033[32;01m
NO_COLOR = \033[0m

all: prezto install

help:
	@echo "Makefile for installing dotfiles"
	@echo
	@echo "Create symlinks:"
	@echo "   $(COLOR)make install$(NO_COLOR)		Install symlinks"
	@echo
	@echo "Install zsh extras:"
	@echo "   $(COLOR)make prezto-install$(NO_COLOR)	Install prezto"
	@echo "   $(COLOR)make prezto-update$(NO_COLOR)		Update prezto"
	@echo "   $(COLOR)make prezto$(NO_COLOR)		prezto-install and prezto-update"
	@echo
	@echo "Configure iTerm2:"
	@echo "   $(COLOR)make iterm2$(NO_COLOR)		Symlink iTerm2 config to iCloud Drive"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make print-dead$(NO_COLOR)		Print dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)		Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull --rebase"
	@echo
	@echo "Everything:"
	@echo "   $(COLOR)make all$(NO_COLOR)			prezto and install"

# Shell environment

install: $(symlinks)

$(symlinks):
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.$@

prezto-install:
	test -d ~/.zprezto || \
		git clone --quiet --recursive \
		https://github.com/sorin-ionescu/prezto.git ~/.zprezto
	test -h ~/.zprezto/modules/prompt/functions/prompt_debian_setup || \
		ln $(LN_FLAGS) $(CURDIR)/zprezto_prompt \
		~/.zprezto/modules/prompt/functions/prompt_debian_setup

prezto-update:
	test -d ~/.zprezto && \
		git -C ~/.zprezto pull --rebase && \
		git -C ~/.zprezto submodule update --init --recursive

prezto: prezto-install prezto-update

iterm2:
	ln $(LN_FLAGS) $(HOME)/Library/Mobile\ Documents/com~apple~CloudDocs/iTerm2/$(HOSTNAME) $(HOME)/.iterm2
	defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$(HOME)/.iterm2"
	defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLost -bool true

# Maintenance

print-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase --quiet
