-- ============================================================================
-- AUTOCMDS
-- ============================================================================
--
-- Format-on-save lives in lsp/format.lua; terminal autocmds in core/terminal.lua.

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	desc = "Highlight yanked text",
	callback = function()
		vim.hl.on_yank()
	end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- prose: wrap, linebreak and spellcheck
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	desc = "Prose settings",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- Obsidian renders links and markup via conceal. Scoped to markdown so it does
-- not hide quotes in JSON or link syntax in every other buffer.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "markdown",
	desc = "Enable conceal for Obsidian markup",
	callback = function()
		vim.opt_local.conceallevel = 2
	end,
})

-- Reload a file when it changes on disk. 'autoread' alone only acts on certain
-- events; this makes it fire when regaining focus or entering a buffer.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = augroup,
	desc = "Check for external file changes",
	callback = function()
		if vim.bo.buftype == "" and vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

-- Close throwaway windows with q rather than :q
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "help", "qf", "man", "checkhealth", "lspinfo" },
	desc = "Close utility buffers with q",
	callback = function(args)
		vim.bo[args.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true, desc = "Close window" })
	end,
})
