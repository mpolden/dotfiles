#!/usr/bin/env bash

# Create symlinks for all dotfiles

DOTFILES=$(ls --almost-all -1 --ignore='.git' --ignore='symlinks.sh' --ignore='laptop' $PWD)

for DOTFILE in $DOTFILES; do
    ln -s -f $PWD/$DOTFILE $HOME/$DOTFILE
done

exit $?

