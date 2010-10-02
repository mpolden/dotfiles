#!/usr/bin/env bash

# This script will symlink all the dotfiles in your home directory
# to the dotfiles repo

DOTFILESDIR=$(dirname $0)
DOTFILES=$(ls --almost-all -1 --ignore='.git' --ignore='symlinks.sh' $DOTFILESDIR)

for DOTFILE in $DOTFILES; do
    ln -s $DOTFILESDIR/$DOTFILE $HOME/$DOTFILE
done

exit $?

