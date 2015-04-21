CURDIR ?= $(.CURDIR)

LN_FLAGS = -sfn

symlinks = agignore \
		   gitconfig \
		   gitignore \
		   hgrc \
		   iterm2 \
		   lftprc \
		   synergy.conf \
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
	@echo "   $(COLOR)make prezto$(NO_COLOR)		Install prezto"
	@echo
	@echo "Configure iTerm2:"
	@echo "   $(COLOR)make iterm$(NO_COLOR)		Set iTerm2 config path"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make check-dead$(NO_COLOR)	Find dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)	Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull --rebase"
	@echo
	@echo "Everything:"
	@echo "   $(COLOR)make all$(NO_COLOR)		prezto and install"

# Shell environment

install: $(symlinks)

$(symlinks):
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.$@

prezto:
	test -d ~/.zprezto || \
		git clone --quiet --recursive \
		https://github.com/sorin-ionescu/prezto.git ~/.zprezto
	ln $(LN_FLAGS) \
		$(CURDIR)/zprezto/modules/prompt/functions/prompt_debian_setup \
		~/.zprezto/modules/prompt/functions/prompt_debian_setup

iterm:
	defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$(HOME)/.iterm2"
	defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLost -bool true

# Maintenance

check-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase
