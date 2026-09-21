-- ============================================================================
-- KEYMAPS (editor built-ins only)
-- ============================================================================
--
-- Plugin and LSP mappings live next to the thing they drive:
--   <leader>f  fzf pickers        plugins/fzf.lua
--   <leader>e  file tree          plugins/tree.lua
--   <leader>h  git hunks          plugins/mini.lua
--   <leader>n  notes (obsidian)   plugins/obsidian.lua
--   <leader>c  code actions       lsp/init.lua
--   <leader>d  diagnostics        lsp/init.lua
--   <leader>g  goto               lsp/init.lua
--   <leader>l  lsp pickers/info   lsp/init.lua
--   <leader>t  terminal/toggles   core/terminal.lua, lsp/format.lua, here
--
-- No mapping may be a strict prefix of another, or the shorter one stalls for
-- 'timeoutlen' on every press. That is why clearing search highlights is <Esc>
-- rather than <leader>c (which prefixes <leader>ca).

local map = vim.keymap.set

-- Movement ------------------------------------------------------------------
map("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })

map("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Search --------------------------------------------------------------------
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Editing -------------------------------------------------------------------
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Line moving is owned by mini.move (<M-h/j/k/l> in normal and visual).
-- Do not add <A-j>/<A-k> here: mini.move sets up later and silently wins.

-- Buffers -------------------------------------------------------------------
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Windows and splits --------------------------------------------------------
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Move to left window/pane" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Move to bottom window/pane" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Move to top window/pane" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Move to right window/pane" })

map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split window horizontally" })

map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Paths ---------------------------------------------------------------------
map("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "Copy full file path" })

map("n", "<leader>pr", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "Copy relative file path" })

-- Toggles -------------------------------------------------------------------
map("n", "<leader>tw", function()
	vim.opt_local.wrap = not vim.wo.wrap
	vim.notify("Wrap " .. (vim.wo.wrap and "on" or "off"))
end, { desc = "Toggle wrap" })

map("n", "<leader>ts", function()
	vim.opt_local.spell = not vim.wo.spell
	vim.notify("Spell " .. (vim.wo.spell and "on" or "off"))
end, { desc = "Toggle spellcheck" })
