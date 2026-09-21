-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================
--
-- Generalised so the same window logic backs both the shell and lazygit
-- (installed by the Brewfile). Each named terminal keeps its own buffer, so
-- the shell holds its session across toggles.

local M = {}

local group = vim.api.nvim_create_augroup("UserTerminal", { clear = true })

-- name -> { buf, win, cmd, persist }
local terminals = {}

vim.api.nvim_create_autocmd("TermOpen", {
	group = group,
	desc = "Terminal window settings",
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})

local function close(term)
	if term.win and vim.api.nvim_win_is_valid(term.win) then
		vim.api.nvim_win_close(term.win, false)
	end
	term.win = nil
end

local function open(name)
	local term = terminals[name]

	if not term.buf or not vim.api.nvim_buf_is_valid(term.buf) then
		term.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[term.buf].bufhidden = "hide"
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)

	term.win = vim.api.nvim_open_win(term.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " " .. name .. " ",
		title_pos = "center",
	})

	vim.wo[term.win].winblend = 0
	vim.wo[term.win].winhighlight = "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
	vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

	if vim.bo[term.buf].buftype ~= "terminal" then
		-- termopen() is deprecated in favour of jobstart({ term = true })
		vim.fn.jobstart(term.cmd, {
			term = true,
			on_exit = function()
				-- Drop the buffer so a non-persistent tool restarts next toggle.
				vim.schedule(function()
					close(term)
					if not term.persist and term.buf and vim.api.nvim_buf_is_valid(term.buf) then
						vim.api.nvim_buf_delete(term.buf, { force = true })
						term.buf = nil
					end
				end)
			end,
		})
	end

	vim.cmd("startinsert")

	vim.api.nvim_create_autocmd("BufLeave", {
		group = group,
		buffer = term.buf,
		once = true,
		desc = "Hide floating terminal on leave",
		callback = function()
			close(term)
		end,
	})
end

--- Toggle a named floating terminal.
---@param name string identifier, also the window title
---@param cmd string|string[] command to run
---@param opts? { persist?: boolean } persist keeps the buffer after the command exits
function M.toggle(name, cmd, opts)
	opts = opts or {}
	terminals[name] = terminals[name] or { buf = nil, win = nil }
	local term = terminals[name]
	term.cmd = cmd
	term.persist = opts.persist ~= false

	if term.win and vim.api.nvim_win_is_valid(term.win) then
		close(term)
		return
	end

	open(name)
end

function M.close_current()
	for _, term in pairs(terminals) do
		if term.win and vim.api.nvim_win_is_valid(term.win) then
			close(term)
		end
	end
end

vim.keymap.set("n", "<leader>tt", function()
	M.toggle("shell", os.getenv("SHELL") or "bash", { persist = true })
end, { desc = "Toggle floating terminal" })

vim.keymap.set("n", "<leader>tg", function()
	if vim.fn.executable("lazygit") == 0 then
		vim.notify("lazygit is not installed (brew bundle)", vim.log.levels.WARN)
		return
	end
	M.toggle("lazygit", "lazygit", { persist = false })
end, { desc = "Toggle lazygit" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
vim.keymap.set("t", "<C-q>", function()
	M.close_current()
end, { desc = "Close floating terminal" })

return M
