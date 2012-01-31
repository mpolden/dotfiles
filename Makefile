LN_FLAGS = -sf

symlinks = .bash_aliases .bashrc .gitconfig .gitignore .hgrc .htoprc .lftprc \
		   .npmrc .rtorrent.rc .screenrc .tmux.conf .vimrc .zshrc .zshrc_prompt
symdirs = .vim

all: install

$(symlinks):
	@ln $(LN_FLAGS) $(PWD)/dot$@ ~/$@

$(symdirs):
	@rm -f ~/$@
	@ln $(LN_FLAGS) $(PWD)/dot$@/ ~/$@

install: $(symlinks) $(symdirs)
	@echo symlinks installed: $^

