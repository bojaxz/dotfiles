-- Entry point.
--
-- Load order matters:
--   1. leader, before anything that defines a mapping
--   2. options, before plugins read them
--   3. plugins (vim.pack.add is synchronous, so configs can require them)
--   4. lsp, which depends on blink.cmp and mason being set up

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.options")
require("core.statusline")
require("core.keymaps")
require("core.autocmds")
require("core.terminal")

require("plugins")
require("lsp")
