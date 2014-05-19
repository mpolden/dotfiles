CURDIR ?= $(.CURDIR)

LN_FLAGS = -sfn

symlinks = .gitconfig \
		   .gitignore \
		   .hgrc \
		   .lftprc \
		   .synergy.conf \
		   .tigrc \
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
