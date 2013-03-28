LN_FLAGS = -sf

symlinks = .editorconfig .gitconfig .gitignore .hgrc .lftprc .screenrc \
		   .synergy.conf .tmux.conf .vimrc .zsh_aliases .zshenv .zshrc
symdirs = .newsbeuter .vim

.PHONY: $(symlinks) $(symdirs)

all: install

clean:
	rm -rf -- $(CURDIR)/dot.vim/bundle/*

$(symlinks):
	test -f $(CURDIR)/dot$@ && ln $(LN_FLAGS) $(CURDIR)/dot$@ ~/$@

$(symdirs):
	rm -f ~/$@
	test -d $(CURDIR)/dot$@ && ln $(LN_FLAGS) $(CURDIR)/dot$@/ ~/$@

install: $(symlinks) $(symdirs) bundle

bundle:
	mkdir -p $(CURDIR)/dot.vim/bundle
	test -d $(CURDIR)/dot.vim/bundle/vundle || \
		(git clone --quiet https://github.com/gmarik/vundle.git \
		$(CURDIR)/dot.vim/bundle/vundle && \
		vim +BundleInstall +qall > /dev/null)

z:
	test -d ~/.zcmd || \
		git clone --quiet https://github.com/rupa/z.git ~/.zcmd

check-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase
