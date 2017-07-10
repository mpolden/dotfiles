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

repos = zsh-users/zsh-history-substring-search \
		   zsh-users/zsh-syntax-highlighting \
		   zsh-users/zsh-completions \
		   sindresorhus/pure \
		   trapd00r/LS_COLORS

.PHONY: $(symlinks) $(zpackages)

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
	@echo "Install additional ls colors:"
	@echo "   $(COLOR)make install-ls-colors$(NO_COLOR)"
	@echo
	@echo "Install pure prompt:"
	@echo "   $(COLOR)make install-pure$(NO_COLOR)"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make print-dead$(NO_COLOR)	Print dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)	Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull --rebase"

# Shell environment

install: $(symlinks)

$(symlinks):
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.$@

install-zpackages: zsh-users/zsh-history-substring-search zsh-users/zsh-syntax-highlighting zsh-users/zsh-completions

install-ls-colors: trapd00r/LS_COLORS

install-pure: sindresorhus/pure
	mkdir -p $(HOME)/.zfunctions
	ln $(LN_FLAGS) $(HOME)/.zpackages/pure/async.zsh $(HOME)/.zfunctions/async
	ln $(LN_FLAGS) $(HOME)/.zpackages/pure/pure.zsh $(HOME)/.zfunctions/prompt_pure_setup

# Clone or update repositories
$(repos):
	mkdir -p $(HOME)/.zpackages
	test ! -d $(HOME)/.zpackages/$(notdir $@) || git -C $(HOME)/.zpackages/$(notdir $@) pull --rebase
	test -d $(HOME)/.zpackages/$(notdir $@) || git clone -q https://github.com/$@.git $(HOME)/.zpackages/$(notdir $@)

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
