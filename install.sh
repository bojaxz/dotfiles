#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Dotfiles directory: $DOTFILES_DIR"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed."
  exit 1
fi

echo "Installing packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "Creating config directories..."
mkdir -p ~/.config

echo "Linking Neovim config..."
ln -sfn "$DOTFILES_DIR/nvim" ~/.config/nvim

echo "Done."
