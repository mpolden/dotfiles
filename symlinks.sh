#!/usr/bin/env bash

# Create symlinks for all dotfiles
# Use --force to overwrite existing dotfiles

DOTFILES=$(ls --almost-all -1 --ignore='.git' --ignore='symlinks.sh' $PWD)

LN_OPTS="-s"
if [[ "$1" == "--force" ]]; then
	LN_OPTS="$LN_OPTS -f"
fi

for DOTFILE in $DOTFILES; do
    ln $LN_OPTS $PWD/$DOTFILE $HOME/$DOTFILE
done

exit $?

