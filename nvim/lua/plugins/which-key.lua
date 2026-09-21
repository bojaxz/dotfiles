-- ============================================================================
-- which-key
-- ============================================================================
--
-- Every mapping in this config sets a `desc`, so the popup is the live index
-- of the keymap scheme. <leader> alone shows the groups below.

local wk = require("which-key")

wk.setup({
	preset = "helix",
	delay = 400,
	icons = {
		mappings = false, -- desc text is enough; avoids a second icon set
	},
})

wk.add({
	{ "<leader>b", group = "buffer" },
	{ "<leader>c", group = "code" },
	{ "<leader>d", group = "diagnostics" },
	{ "<leader>f", group = "find" },
	{ "<leader>g", group = "goto" },
	{ "<leader>h", group = "git hunks" },
	{ "<leader>l", group = "lsp" },
	{ "<leader>n", group = "notes" },
	{ "<leader>p", group = "path" },
	{ "<leader>s", group = "split" },
	{ "<leader>t", group = "terminal/toggle" },
	{ "<leader>e", desc = "Toggle file tree" },
	{ "<leader>x", desc = "Delete without yanking" },
})
