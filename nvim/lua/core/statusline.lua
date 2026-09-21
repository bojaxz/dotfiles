-- ============================================================================
-- STATUSLINE
-- ============================================================================
--
-- Components are exposed on a single `Statusline` global so `v:lua` can reach
-- them from the 'statusline' string without scattering four names across _G.

local M = {}

-- Git branch, read from mini.git's buffer-local summary.
--
-- This used to shell out to `git branch --show-current` on a 5s timer. That is
-- a blocking call on every redraw window, and it is slow on WSL when the repo
-- lives under /mnt/c. mini.git already tracks this asynchronously, so use it.
function M.git_branch()
	local summary = vim.b.minigit_summary_string
	if summary == nil or summary == "" then
		return ""
	end
	return " \u{e725} " .. summary .. " " -- nf-dev-git_branch
end

local filetype_icons = {
	lua = "\u{e620} ", -- nf-dev-lua
	python = "\u{e73c} ", -- nf-dev-python
	javascript = "\u{e74e} ", -- nf-dev-javascript
	typescript = "\u{e628} ", -- nf-dev-typescript
	javascriptreact = "\u{e7ba} ",
	typescriptreact = "\u{e7ba} ",
	html = "\u{e736} ", -- nf-dev-html5
	css = "\u{e749} ", -- nf-dev-css3
	scss = "\u{e749} ",
	json = "\u{e60b} ", -- nf-dev-json
	jsonc = "\u{e60b} ",
	markdown = "\u{e73e} ", -- nf-dev-markdown
	vim = "\u{e62b} ", -- nf-dev-vim
	sh = "\u{f489} ", -- nf-oct-terminal
	bash = "\u{f489} ",
	zsh = "\u{f489} ",
	rust = "\u{e7a8} ", -- nf-dev-rust
	go = "\u{e724} ", -- nf-dev-go
	c = "\u{e61e} ", -- nf-dev-c
	cpp = "\u{e61d} ", -- nf-dev-cplusplus
	java = "\u{e738} ", -- nf-dev-java
	php = "\u{e73d} ", -- nf-dev-php
	ruby = "\u{e739} ", -- nf-dev-ruby
	swift = "\u{e755} ", -- nf-dev-swift
	kotlin = "\u{e634} ",
	dart = "\u{e798} ",
	elixir = "\u{e62d} ",
	haskell = "\u{e777} ",
	sql = "\u{e706} ",
	yaml = "\u{f481} ",
	toml = "\u{e615} ",
	xml = "\u{f05c} ",
	dockerfile = "\u{f308} ", -- nf-linux-docker
	gitcommit = "\u{f418} ", -- nf-oct-git_commit
	gitconfig = "\u{f1d3} ", -- nf-fa-git
	vue = "\u{fd42} ", -- nf-md-vuejs
	svelte = "\u{e697} ",
	astro = "\u{e628} ",
}

function M.file_type()
	local ft = vim.bo.filetype
	if ft == "" then
		return " \u{f15b} " -- nf-fa-file_o
	end
	return (filetype_icons[ft] or " \u{f15b} ") .. ft
end

function M.file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size < 0 then
		return ""
	end
	local size_str
	if size < 1024 then
		size_str = size .. "B"
	elseif size < 1024 * 1024 then
		size_str = string.format("%.1fK", size / 1024)
	else
		size_str = string.format("%.1fM", size / 1024 / 1024)
	end
	return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
end

local modes = {
	n = " \u{f121}  NORMAL",
	i = " \u{f11c}  INSERT",
	v = " \u{f0168} VISUAL",
	V = " \u{f0168} V-LINE",
	["\22"] = " \u{f0168} V-BLOCK",
	c = " \u{f120} COMMAND",
	s = " \u{f0c5} SELECT",
	S = " \u{f0c5} S-LINE",
	["\19"] = " \u{f0c5} S-BLOCK",
	R = " \u{f044} REPLACE",
	r = " \u{f044} REPLACE",
	["!"] = " \u{f489} SHELL",
	t = " \u{f120} TERMINAL",
}

function M.mode_icon()
	local mode = vim.fn.mode()
	return modes[mode] or (" \u{f059} " .. mode)
end

_G.Statusline = M

local active = table.concat({
	"  ",
	"%#StatusLineBold#",
	"%{v:lua.Statusline.mode_icon()}",
	"%#StatusLine#",
	" \u{e0b1} %f %h%m%r", -- nf-pl-left_hard_divider
	"%{v:lua.Statusline.git_branch()}",
	"\u{e0b1} ", -- nf-pl-left_hard_divider
	"%{v:lua.Statusline.file_type()}",
	"\u{e0b1} ", -- nf-pl-left_hard_divider
	"%{v:lua.Statusline.file_size()}",
	"%=", -- Right-align everything after this
	" \u{f017} %l:%c  %P ", -- nf-fa-clock_o for line/col
})

local inactive = "  %f %h%m%r \u{e0b1} %{v:lua.Statusline.file_type()} %=  %l:%c   %P "

local group = vim.api.nvim_create_augroup("UserStatusline", { clear = true })

vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = group,
	callback = function()
		vim.opt_local.statusline = active
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = group,
	callback = function()
		vim.opt_local.statusline = inactive
	end,
})

-- Applies to the window nvim starts in, which fires no WinEnter.
vim.opt.statusline = active

return M
