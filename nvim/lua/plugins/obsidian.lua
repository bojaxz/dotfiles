-- ============================================================================
-- obsidian.nvim  (<leader>n = notes)
-- ============================================================================
--
-- Optional. The vault path is portable across macOS and WSL; if it does not
-- exist the plugin stays unconfigured and the <leader>n maps are never set.
-- Run `mkdir -p ~/Documents/Notes` on a new machine to enable it.

local notes_path = vim.fn.expand("~/Documents/Notes")

if vim.fn.isdirectory(notes_path) == 0 then
	return
end

require("obsidian").setup({
	legacy_commands = false,
	workspaces = {
		{
			name = "Notes",
			path = notes_path,
		},
	},
})

local map = vim.keymap.set

map("n", "<leader>nn", function()
	vim.cmd("Obsidian workspace")
	vim.defer_fn(function()
		vim.cmd("Obsidian new")
	end, 500)
end, { desc = "New note" })

map("n", "<leader>nf", "<cmd>Obsidian quick_switch<cr>", { desc = "Find note" })
map("n", "<leader>ns", "<cmd>Obsidian search<cr>", { desc = "Search notes" })
map("n", "<leader>nt", "<cmd>Obsidian today<cr>", { desc = "Today's daily note" })
map("n", "<leader>nw", "<cmd>Obsidian workspace<cr>", { desc = "Switch workspace" })
