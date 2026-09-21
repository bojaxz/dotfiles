-- ============================================================================
-- nvim-tree
-- ============================================================================

require("nvim-tree").setup({
	view = {
		width = 35,
	},
	filters = {
		dotfiles = false,
		-- Keep the tree readable in a Node monorepo.
		custom = { "^\\.git$", "node_modules", "^dist$", "^\\.turbo$" },
	},
	renderer = {
		group_empty = true,
	},
	git = {
		enable = true,
		ignore = false,
	},
	actions = {
		open_file = {
			quit_on_open = false,
			window_picker = { enable = true },
		},
	},
})

vim.keymap.set("n", "<leader>e", function()
	require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle file tree" })

for _, group in ipairs({
	"NvimTreeNormal",
	"NvimTreeNormalNC",
	"NvimTreeSignColumn",
	"NvimTreeEndOfBuffer",
}) do
	vim.api.nvim_set_hl(0, group, { bg = "none" })
end
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#2a2a2a", bg = "none" })
