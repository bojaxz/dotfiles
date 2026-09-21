-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================
--
-- vim.pack.add is synchronous: it clones anything missing before returning,
-- so the config modules below can require these straight away.
-- Pinned revisions live in nvim-pack-lock.json. Update with :lua vim.pack.update()

vim.pack.add({
	"https://github.com/echasnovski/mini.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/folke/which-key.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},

	-- LSP, linting, formatting, completion
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/mrcjkb/rustaceanvim",

	-- Misc
	"https://github.com/obsidian-nvim/obsidian.nvim",
	"https://github.com/christoomey/vim-tmux-navigator",
})

-- mini must come first: it mocks nvim-web-devicons, which nvim-tree looks for
-- at setup time to decide whether it can render file icons.
require("plugins.mini")
require("plugins.treesitter")
require("plugins.tree")
require("plugins.fzf")
require("plugins.obsidian")
require("plugins.which-key")
