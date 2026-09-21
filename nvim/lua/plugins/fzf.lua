-- ============================================================================
-- fzf-lua  (<leader>f = find)
-- ============================================================================
--
-- LSP-backed pickers live in lsp/init.lua under <leader>g and <leader>l, since
-- they are only meaningful once a server has attached.

local fzf = require("fzf-lua")

fzf.setup({
	"default",
	winopts = {
		height = 0.85,
		width = 0.85,
		preview = {
			layout = "flex",
			scrollbar = "float",
		},
	},
	files = {
		-- fd and rg honour .gitignore, so node_modules and dist drop out on
		-- their own in a normal repo. --hidden adds dotfiles back in.
		fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude node_modules]],
	},
	grep = {
		rg_opts = [[--column --line-number --no-heading --color=always --smart-case --hidden --glob=!.git/ --glob=!node_modules/]],
	},
})

local map = vim.keymap.set

map("n", "<leader>ff", fzf.files, { desc = "Find files" })
map("n", "<leader>fG", fzf.git_files, { desc = "Find git-tracked files" })
map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
map("v", "<leader>fg", fzf.grep_visual, { desc = "Grep selection" })
map("n", "<leader>fw", fzf.grep_cword, { desc = "Grep word under cursor" })
map("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
map("n", "<leader>fo", fzf.oldfiles, { desc = "Recent files" })
map("n", "<leader>fr", fzf.resume, { desc = "Resume last picker" })
map("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
map("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })
map("n", "<leader>fc", fzf.commands, { desc = "Commands" })
map("n", "<leader>fd", fzf.diagnostics_document, { desc = "Document diagnostics" })
map("n", "<leader>fD", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
