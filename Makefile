CURDIR ?= $(.CURDIR)

HOSTNAME := $(shell hostname -s)

LN_FLAGS := -sfn

BREW := $(shell command -v brew 2> /dev/null)

symlinks := ansible.cfg \
		   gitconfig \
		   gitignore \
		   lftprc \
		   tmux.conf \
		   zlogin \
		   zsh_aliases \
		   zshenv \
		   zshrc

repos := zsh-users/zsh-history-substring-search \
		   zsh-users/zsh-syntax-highlighting \
		   zsh-users/zsh-completions \

.PHONY: $(symlinks) $(repos)

COLOR := \033[32;01m
NO_COLOR := \033[0m

all: install

help:
	@echo "Makefile for installing dotfiles"
	@echo
	@echo "Create symlinks:"
	@echo "   $(COLOR)make install$(NO_COLOR)"
	@echo
	@echo "Configure Mac-specific symlinks:"
	@echo "   $(COLOR)make mac-all$(NO_COLOR)"
	@echo "   $(COLOR)make mac-alfred$(NO_COLOR)"
	@echo "   $(COLOR)make mac-dash$(NO_COLOR)"
	@echo "   $(COLOR)make mac-icloud$(NO_COLOR)"
	@echo "   $(COLOR)make mac-idea$(NO_COLOR)"
	@echo "   $(COLOR)make mac-iterm2$(NO_COLOR)"
	@echo "   $(COLOR)make mac-org$(NO_COLOR)"
	@echo
	@echo "Install or upgrade zsh extras:"
	@echo "   $(COLOR)make zsh-extras$(NO_COLOR)"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make print-dead$(NO_COLOR)	Print dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)	Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull --rebase"

# Shell environment

install: $(symlinks) fish

$(symlinks):
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.$@

zsh-extras: zsh-users/zsh-history-substring-search zsh-users/zsh-syntax-highlighting zsh-users/zsh-completions

$(repos):
ifdef BREW
	brew install $(notdir $@)
else
	mkdir -p $(HOME)/.local/share
	test ! -d $(HOME)/.local/share/$(notdir $@) || git -C $(HOME)/.local/share/$(notdir $@) pull --rebase
	test -d $(HOME)/.local/share/$(notdir $@) || git clone -q https://github.com/$@.git $(HOME)/.local/share/$(notdir $@)
endif

# Mac

mac-all: mac-alfred mac-dash mac-icloud mac-idea mac-org mac-iterm2

mac-alfred:
	defaults write com.runningwithcrayons.Alfred-Preferences-3 syncfolder "~/Library/Mobile Documents/com~apple~CloudDocs/Alfred"

mac-dash:
	defaults write com.kapeli.dashdoc syncFolderPath "~/Library/Mobile Documents/com~apple~CloudDocs/Dash"

mac-icloud:
	ln $(LN_FLAGS) $(HOME)/Library/Mobile\ Documents/com~apple~CloudDocs $(HOME)/.icloud

mac-idea: mac-icloud
	ln $(LN_FLAGS) $(HOME)/.icloud/IdeaIC2017.2 "$(HOME)/Library/Preferences/IdeaIC2017.2"

mac-org: mac-icloud
	ln $(LN_FLAGS) $(HOME)/.icloud/org $(HOME)/org

mac-iterm2: mac-icloud
	ln $(LN_FLAGS) $(HOME)/.icloud/iTerm2/$(HOSTNAME) $(HOME)/.iterm2
	defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$(HOME)/.iterm2"
	defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLost -bool true

fish:
	mkdir -p ~/.config/fish/functions
	ln $(LN_FLAGS) $(CURDIR)/config.fish ~/.config/fish/config.fish
	ln $(LN_FLAGS) $(CURDIR)/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish

# Maintenance

print-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase --quiet
