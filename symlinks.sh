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
    TARGET="$HOME/${BASENAME/dot/}"
    ln $LN_OPTS $DOTFILE $TARGET
done

exit $?

