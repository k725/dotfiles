#!/bin/sh
set -uxe

DOTFILES="$HOME/.dotfiles"
REPO_URL="https://github.com/k725/dotfiles.git"

git_pull_or_clone() {
    cd="$(pwd)"
    if [ -d "$2" ]; then
        cd "$2"
        git pull
        git submodule foreach git pull origin master
    else
        git clone --recursive "$1" "$2"
    fi
    cd "$cd"
}

git_pull_or_clone "$REPO_URL" "$DOTFILES"

chmod +x "$DOTFILES/_init.sh"
"$DOTFILES/_init.sh"
