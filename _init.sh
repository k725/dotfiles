#!/bin/sh
set -uxe

DIRNAME="$(dirname "$0")"
DOTFILES=$(cd "$DIRNAME"; pwd)

# shellcheck disable=1090,2039
. "$DOTFILES/_lib.sh"

mkdir -p "$HOME/.local/bin"

loader sshconf "$DOTFILES/_install/sshconf.sh"

if [ "$(has_command zsh)" -eq "0" ]; then
    loader zsh "$DOTFILES/_install/zsh.sh"
    loader prezto "$DOTFILES/_install/prezto.sh"
fi
