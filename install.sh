#!/usr/bin/env bash

set -euo pipefail

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
if [ -e ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
  echo "  ~/.config/nvim exists and is not a symlink; moving it to ~/.config/nvim.bak"
  mv ~/.config/nvim ~/.config/nvim.bak
fi
ln -sfn "$DOTFILES_DIR/nvim" ~/.config/nvim

# ---------------------------------------------------------------------------
# Post-install checks
#
# Mason provisions the language servers on first launch, but a few of them are
# npm-based and it cannot install Node for you. Warn rather than fail, so a
# machine that only needs, say, Go still finishes cleanly.
# ---------------------------------------------------------------------------
warned=0

warn() {
  echo "  ! $1"
  warned=1
}

echo "Checking prerequisites..."

nvim_version="$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)"
if [ "$(printf '%s\n0.12\n' "$nvim_version" | sort -V | head -1)" != "0.12" ]; then
  warn "Neovim $nvim_version found, but this config needs 0.12+ for vim.pack."
  warn "  'which -a nvim' may show an older build shadowing the Homebrew one."
fi

command -v node >/dev/null 2>&1 ||
  warn "node not found. ts_ls, biome, prettierd and the yaml/docker servers need it."

command -v rustup >/dev/null 2>&1 ||
  warn "rustup not found. Skip unless you write Rust; otherwise:
      rustup component add rust-analyzer"

if [ ! -d ~/Documents/Notes ]; then
  echo "  - ~/Documents/Notes absent, so Obsidian stays off. mkdir it to enable."
fi

if [ "$warned" -eq 1 ]; then
  echo ""
  echo "Finished with warnings (see above)."
else
  echo "Prerequisites OK."
fi

cat <<'EOF'

Next:
  1. Open nvim. Plugins clone, treesitter parsers compile, and Mason installs
     the toolchain automatically. Give it a minute on a fresh machine.
  2. Restart nvim so the newly installed servers attach.
  3. :checkhealth        to confirm everything is wired up
     :Mason              to see the toolchain
     <leader>            to browse the keymap via which-key
EOF
