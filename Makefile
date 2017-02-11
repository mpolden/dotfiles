CURDIR ?= $(.CURDIR)

HOSTNAME = $(shell hostname -s)

LN_FLAGS = -sfn

symlinks = ansible.cfg \
		   gitconfig \
		   gitignore \
		   lftprc \
		   tmux.conf \
		   zlogin \
		   zsh_aliases \
		   zshenv \
		   zshrc

.PHONY: $(symlinks)

COLOR = \033[32;01m
NO_COLOR = \033[0m

all: install

help:
	@echo "Makefile for installing dotfiles"
	@echo
	@echo "Create symlinks:"
	@echo "   $(COLOR)make install$(NO_COLOR)"
	@echo
	@echo "Create Mac-specific symlinks:"
	@echo "   $(COLOR)make install-mac$(NO_COLOR)"
	@echo
	@echo "Install additional zsh packages:"
	@echo "   $(COLOR)make install-zpackages$(NO_COLOR)"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make print-dead$(NO_COLOR)	Print dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)	Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull --rebase"

# Shell environment

install: $(symlinks)

$(symlinks):
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.$@

install-zpackages:
	mkdir -p $(HOME)/.zfunctions $(HOME)/.zpackages
	test -d $(HOME)/.zpackages/zsh-history-substring-search || \
git clone -q https://github.com/zsh-users/zsh-history-substring-search.git \
$(HOME)/.zpackages/zsh-history-substring-search
	test -d $(HOME)/.zpackages/zsh-completions || \
git clone -q https://github.com/zsh-users/zsh-completions.git \
$(HOME)/.zpackages/zsh-completions
	test -d $(HOME)/.zpackages/zsh-syntax-highlighting || \
git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git \
$(HOME)/.zpackages/zsh-syntax-highlighting
	test -d $(HOME)/.zpackages/pure || \
git clone -q https://github.com/sindresorhus/pure.git \
$(HOME)/.zpackages/pure
	ln $(LN_FLAGS) $(HOME)/.zpackages/pure/async.zsh \
$(HOME)/.zfunctions/async
	ln $(LN_FLAGS) $(HOME)/.zpackages/pure/pure.zsh \
$(HOME)/.zfunctions/prompt_pure_setup

install-mac:
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
