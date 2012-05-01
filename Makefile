LN_FLAGS = -sf

symlinks = .bash_aliases .bashrc .bashrc_env .gitconfig .gitignore .hgrc \
		   .htoprc .lftprc .npmrc .rtorrent.rc .screenrc .tmux.conf .vimrc \
		   .zshrc
symdirs = .vim

all: install

clean:
	rm -rf -- dot.vim/bundle/*

$(symlinks):
	@ln $(LN_FLAGS) $(PWD)/dot$@ ~/$@

$(symdirs):
	@rm -f ~/$@
	@ln $(LN_FLAGS) $(PWD)/dot$@/ ~/$@

install: $(symlinks) $(symdirs)
	@echo symlinks installed: $^

bundle:
	mkdir -p dot.vim/bundle
	test -d dot.vim/bundle/vundle || \
		(git clone --quiet https://github.com/gmarik/vundle.git \
		dot.vim/bundle/vundle && vim +BundleInstall +qall)
