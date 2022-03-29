HOSTNAME := $(shell hostname -s)
LN_FLAGS := -sfn
BREW := $(shell command -v brew 2> /dev/null)

symlinks := gitattributes \
	    gitconfig \
	    gitignore \
	    lftprc \
	    mbsyncrc \
	    sqliterc \
	    tmux.conf \
	    zsh_aliases \
	    zshenv \
	    zshrc

zsh_extensions := zsh-syntax-highlighting

.PHONY: $(symlinks) $(zsh_extensions) iterm2.conf

COLOR := \033[32;01m
NO_COLOR := \033[0m

all: install

help:
	@echo "Makefile for installing dotfiles"
	@echo
	@echo "Create symlinks:"
	@echo "   $(COLOR)make install$(NO_COLOR)"
	@echo
	@echo "Install zsh extras:"
	@echo "   $(COLOR)make zsh-extras$(NO_COLOR)"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make print-dead$(NO_COLOR)	Print dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)	Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull"

# Shell environment

iterm2.conf: ITERM2_PLIST=~/.config/iterm2/com.googlecode.iterm2.plist
iterm2.conf:
	mkdir -p ~/.config/iterm2
# Copy the changes into this repository if the config already exists as a
# regular file. When changing iTerm2 config, save it in General -> Preferences
# manually. This will replace the symlink with a regular file, so this target
# should be run again.
	test -f $(ITERM2_PLIST) && cp -a $(ITERM2_PLIST) $(CURDIR)/iterm2.conf || true
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ $(ITERM2_PLIST)

install: $(symlinks) iterm2.conf

$(symlinks):
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.$@

zsh-extras: $(zsh_extensions)

$(zsh_extensions):
ifneq ($(BREW),)
	brew install $@
else
	$(error could not find a package manager to install $@)
endif

# Maintenance

print-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase --quiet
