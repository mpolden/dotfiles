#!/usr/bin/env bash

# Create symlinks for all dotfiles
# Use --force to overwrite existing dotfiles

DOTFILES=$(ls -1 -d $PWD/dot.*)

LN_OPTS="-s"
if [[ "$1" == "--force" ]]; then
	LN_OPTS="$LN_OPTS -f"
fi

for DOTFILE in $DOTFILES; do
    BASENAME=$(basename $DOTFILE)
    if [[ "$BASENAME" == "dot.ssh" ]]; then
        ln $LN_OPTS $DOTFILE/config $HOME/.ssh/config
    else
        TARGET="$HOME/${BASENAME/dot/}"
        ln $LN_OPTS $DOTFILE $TARGET
    fi
done

exit $?

