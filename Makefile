CURDIR ?= $(.CURDIR)

LN_FLAGS = -sf

symlinks = .gitconfig .gitignore .hgrc .lftprc .screenrc \
		   .synergy.conf .tmux.conf .vimrc .zpreztorc .zsh_aliases .zshenv \
		   .zshrc
symdirs = .vim

.PHONY: $(symlinks) $(symdirs)

all: install

clean:
	rm -rf -- $(CURDIR)/dot.vim/bundle/*

$(symlinks):
	test -f $(CURDIR)/dot$@ && ln $(LN_FLAGS) $(CURDIR)/dot$@ ~/$@

$(symdirs):
	rm -f ~/$@
	test -d $(CURDIR)/dot$@ && ln $(LN_FLAGS) $(CURDIR)/dot$@/ ~/$@

install: $(symlinks) $(symdirs)

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

check-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase

deps: deb-deps arch-deps

deb-deps:
	test ! -f /etc/debian_version || \
		aptitude install --assume-yes git make rsync tig tmux vim zsh

arch-deps:
	test ! -f /etc/arch-release || \
		pacman --sync --needed git make rsync tig tmux vim zsh
