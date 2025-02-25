HOSTNAME := $(shell hostname -s)
LN_FLAGS := -sfn

symlinks := gitattributes \
	    gitconfig \
	    gitignore \
	    lftprc \
	    mbsyncrc \
	    sqliterc \
	    tmux.conf

.PHONY: $(symlinks) fish ghostty

COLOR := \033[32;01m
NO_COLOR := \033[0m

all: help

help:
	@echo "Makefile for installing dotfiles"
	@echo
	@echo "Create symlinks:"
	@echo "   $(COLOR)make install$(NO_COLOR)"
	@echo
	@echo "Install applications declared in Brewfile:"
	@echo "   $(COLOR)make install-apps$(NO_COLOR)"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make fmt$(NO_COLOR)		Format fish configuration"
	@echo "   $(COLOR)make print-dead$(NO_COLOR)	Print dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)	Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull"

# Shell environment

ghostty:
	mkdir -p ~/.config/ghostty
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.config/ghostty/config

install: $(symlinks) ghostty fish

$(symlinks):
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.$@

fish:
	mkdir -p ~/.config/fish/functions
	ln $(LN_FLAGS) $(CURDIR)/config.fish ~/.config/fish/config.fish
	ln $(LN_FLAGS) $(CURDIR)/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish

# Applications

install-apps:
	brew bundle install --cleanup

# Maintenance

fmt:
	fish_indent -w *.fish

print-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase --quiet
