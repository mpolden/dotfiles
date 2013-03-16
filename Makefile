LN_FLAGS = -sf

symlinks = .editorconfig .gitconfig .gitignore .hgrc .lftprc .screenrc \
		   .synergy.conf .tmux.conf .vimrc .zsh_aliases .zshenv .zshrc
symdirs = .vim

.PHONY: $(symlinks) $(symdirs)

all: install

clean:
	rm -rf -- dot.vim/bundle/*

$(symlinks):
	test -f $(PWD)/dot$@ && ln $(LN_FLAGS) $(PWD)/dot$@ ~/$@

$(symdirs):
	rm -f ~/$@
	test -d $(PWD)/dot$@ && ln $(LN_FLAGS) $(PWD)/dot$@/ ~/$@

install: $(symlinks) $(symdirs) bundle

bundle:
	mkdir -p dot.vim/bundle
	test -d dot.vim/bundle/vundle || \
		(git clone --quiet https://github.com/gmarik/vundle.git \
		dot.vim/bundle/vundle && vim +BundleInstall +qall)

z:
	test -d ~/.dot.z || \
		git clone --quiet https://github.com/rupa/z.git ~/.dot.z

nvm:
	test -d ~/.nvm || \
		git clone --quiet https://github.com/creationix/nvm.git ~/.nvm

check-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete
