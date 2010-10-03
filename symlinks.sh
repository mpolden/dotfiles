#!/usr/bin/env bash

# Create symlinks for all dotfiles

DOTFILESDIR=$(dirname $0)
DOTFILES=$(ls --almost-all -1 --ignore='.git' --ignore='symlinks.sh' $DOTFILESDIR)

for DOTFILE in $DOTFILES; do
    ln -s $DOTFILESDIR/$DOTFILE $HOME/$DOTFILE
done

exit $?

