## Brewfile

# Editor. The config uses vim.pack, which needs Neovim 0.12+.
brew "neovim"

brew "git"
brew "lazygit" # <leader>tg inside nvim
brew "gh"

# Used by fzf-lua for file finding and live grep
brew "fzf"
brew "ripgrep"
brew "fd"

# nvim-treesitter compiles parsers on install
brew "tree-sitter-cli"

# Language toolchains. Mason installs the language servers themselves.
brew "go"

# Deliberately NOT here:
#   node    - managed by nvm; a brew copy would shadow the nvm one on PATH.
#             install.sh checks for it instead. Needed by ts_ls, biome,
#             prettierd, and the yaml/docker servers.
