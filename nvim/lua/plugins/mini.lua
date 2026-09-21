-- ============================================================================
-- mini.nvim
-- ============================================================================

require("mini.icons").setup({})

-- nvim-tree looks for nvim-web-devicons at setup time. Without this shim that
-- module does not exist and the tree renders with no file icons at all.
MiniIcons.mock_nvim_web_devicons()

require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})

-- Owns <M-h/j/k/l> in normal and visual mode. Anything mapped to <A-j>/<A-k>
-- elsewhere is dead code, because this setup runs later and overwrites it.
require("mini.move").setup({})

require("mini.diff").setup({
	view = {
		style = "sign",
		signs = { add = "▎", change = "▎", delete = "▎" },
	},
})

-- Also populates vim.b.minigit_summary_string, which the statusline reads.
require("mini.git").setup({})

local map = vim.keymap.set

-- mini.diff already provides [h / ]h to move between hunks, gh to apply and
-- gH to reset (each taking a motion), and gh as the hunk textobject. So the
-- doubled form applies or resets the hunk under the cursor. MiniDiff.operator
-- is an 'operatorfunc' helper and does nothing useful called bare.
map("n", "<leader>hs", "ghgh", { remap = true, desc = "Stage hunk at cursor" })
map("n", "<leader>hr", "gHgh", { remap = true, desc = "Reset hunk at cursor" })

local MiniDiff = require("mini.diff")
map("n", "<leader>hp", function()
	MiniDiff.toggle_overlay()
end, { desc = "Preview diff overlay" })
map("n", "<leader>hb", function()
	require("mini.git").show_at_cursor()
end, { desc = "Git blame/show at cursor" })

map("n", "<leader>bd", function()
	require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer (keep window)" })

map("n", "<leader>tz", function()
	require("mini.trailspace").trim()
	vim.notify("Trimmed trailing whitespace")
end, { desc = "Trim trailing whitespace" })
