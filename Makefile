LN_FLAGS = -sf

symlinks = .bash_aliases .bashrc .bashrc_env .gitconfig .gitignore .hgrc \
		   .htoprc .lftprc .npmrc .rtorrent.rc .screenrc .tmux.conf .vimrc \
		   .zshrc .zsh-git
symdirs = .vim .oh-my-zsh

all: install

$(symlinks):
	@ln $(LN_FLAGS) $(PWD)/dot$@ ~/$@

$(symdirs):
	@rm -f ~/$@
	@ln $(LN_FLAGS) $(PWD)/dot$@/ ~/$@

install: $(symlinks) $(symdirs)
	@echo symlinks installed: $^

