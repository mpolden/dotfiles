#!/usr/bin/env bash

# Create symlinks for all dotfiles
# Use --force to overwrite existing dotfiles

LS="ls"
if [[ $(uname -s) != "Linux" ]]; then
    LS="gnuls"
fi
DOTFILES=$($LS --almost-all -1 --ignore='.git' --ignore='symlinks.sh' --ignore='README.markdown' $PWD)

LN_OPTS="-s"
if [[ "$1" == "--force" ]]; then
	LN_OPTS="$LN_OPTS -f"
fi

for DOTFILE in $DOTFILES; do
    ln $LN_OPTS $PWD/$DOTFILE $HOME/$DOTFILE
done

exit $?

