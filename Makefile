CURDIR ?= $(.CURDIR)

LN_FLAGS = -sfn

symlinks = .gitconfig \
		   .gitignore \
		   .hgrc \
		   .lftprc \
		   .screenrc \
		   .synergy.conf \
		   .tmux.conf \
		   .vim \
		   .vimrc \
		   .zpreztorc \
		   .zsh_aliases \
		   .zshenv \
		   .zshrc

xsymlinks = .fonts.conf \
			.i3 \
			.i3status.conf \
			.Xresources

.PHONY: $(symlinks) $(xsymlinks)

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

check-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase


# X environment

all-x: install-x deb-deps deb-deps-x

install-x: $(xsymlinks)

$(xsymlinks):
	test -e $(CURDIR)/dot$@ && ln $(LN_FLAGS) $(CURDIR)/dot$@ ~/$@

deb-deps:
	test -f /etc/debian_version && \
		aptitude install --assume-yes git htop make mosh rsync tig tmux vim zsh

deb-deps-x:
	test -f /etc/debian_version && \
		aptitude install --assume-yes xserver-xorg x11-xserver-utils slim i3 \
		fonts-liberation rxvt-unicode-256color

arch-deps:
	test -f /etc/arch-release && \
		pacman --sync --needed git htop make mosh rsync tig tmux vim zsh
