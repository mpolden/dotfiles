CURDIR ?= $(.CURDIR)

LN_FLAGS = -sfn

symlinks = .agignore \
		   .gitconfig \
		   .gitignore \
		   .hgrc \
		   .lftprc \
		   .synergy.conf \
		   .tigrc \
		   .tmux.conf \
		   .Xmodmap \
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
	@echo "Install zsh extras:"
	@echo "   $(COLOR)make z$(NO_COLOR)		Install z"
	@echo "   $(COLOR)make prezto$(NO_COLOR)		Install prezto"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make check-dead$(NO_COLOR)	Find dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)	Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull --rebase"
	@echo
	@echo "Everything:"
	@echo "   $(COLOR)make all$(NO_COLOR)		z, prezto and install"

# Shell environment

all: z prezto install

install: $(symlinks)

$(symlinks):
	test -e $(CURDIR)/dot$@ && ln $(LN_FLAGS) $(CURDIR)/dot$@ ~/$@

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
