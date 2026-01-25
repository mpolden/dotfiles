HOSTNAME := $(shell hostname -s)
LN_FLAGS := -sfn

symlinks := gitattributes \
	    gitconfig \
	    gitignore \
	    lftprc \
	    mbsyncrc \
	    sqliterc \
	    tmux.conf

.PHONY: $(symlinks) btop fish ghostty ghostty-themes

COLOR := \033[32;01m
NO_COLOR := \033[0m

all: help

help:
	@echo "Makefile for installing dotfiles"
	@echo
	@echo "Create symlinks:"
	@echo "   $(COLOR)make install$(NO_COLOR)"
	@echo
	@echo "Install applications from Brewfile:"
	@echo "   $(COLOR)make install-apps$(NO_COLOR)	Ensure installed apps match Brewfile exactly"
	@echo "   $(COLOR)make check-apps$(NO_COLOR)	Check whether installed apps match Brewfile"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make fmt$(NO_COLOR)		Format fish configuration"
	@echo "   $(COLOR)make print-dead$(NO_COLOR)	Print dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)	Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull"

# Shell environment and tools

$(symlinks):
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.$@

btop:
	mkdir -p ~/.config/btop
	ln $(LN_FLAGS) $(CURDIR)/btop.conf ~/.config/btop/btop.conf

fish:
	mkdir -p ~/.config/fish/functions
	ln $(LN_FLAGS) $(CURDIR)/config.fish ~/.config/fish/config.fish
	ln $(LN_FLAGS) $(CURDIR)/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish

ghostty:
	mkdir -p ~/.config/ghostty
	ln $(LN_FLAGS) $(CURDIR)/ghostty ~/.config/ghostty/config

ghostty-themes:
	mkdir -p ~/.config/ghostty/themes
	curl -fsSL -m 30 -o - https://github.com/anhsirk0/ghostty-themes/archive/refs/heads/main.tar.gz | \
		tar -C ~/.config/ghostty/themes --include '*/*/ef-*' --strip-components 2 -xf -

konsole-themes:
	mkdir -p ~/.local/share/konsole
	ln $(LN_FLAGS) $(CURDIR)/konsole/ef-day.colorscheme ~/.local/share/konsole/ef-day.colorscheme
	ln $(LN_FLAGS) $(CURDIR)/konsole/ef-night.colorscheme ~/.local/share/konsole/ef-night.colorscheme

install: $(symlinks) btop ghostty fish

# Applications

install-apps:
	brew bundle install --no-upgrade --cleanup

check-apps:
	brew bundle check --no-upgrade --verbose

# Maintenance

fmt:
	fish_indent -w *.fish

print-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase --quiet
