-- ============================================================================
-- FORMAT ON SAVE
-- ============================================================================
--
-- The previous version had two bugs:
--
--   1. It only ever formatted with efm (`filter = c.name == "efm"`), so Rust
--      never formatted on save even though rustaceanvim can do it.
--   2. It gated on a hardcoded list of file extensions that omitted *.rs
--      anyway, so new filetypes silently opted out.
--
-- Instead: pick the highest-priority attached client that can format. The list
-- is explicit rather than "whatever attached first" because several servers
-- offer formatting we do not want — ts_ls in particular formats JS/TS with its
-- own built-in rules and would fight biome.
--
-- Add a server here when you want it to be allowed to format.

local M = {}

local priority = {
	"biome", -- JS/TS/JSON/CSS in a biome repo
	"efm", -- everything else, via lsp/efm.lua
	"rust_analyzer", -- rustfmt, via rustaceanvim
	"gopls",
	"clangd",
}

-- Global kill switch, plus a per-buffer override for generated files.
vim.g.autoformat = true

local function enabled(bufnr)
	if vim.b[bufnr].autoformat ~= nil then
		return vim.b[bufnr].autoformat
	end
	return vim.g.autoformat
end

--- Highest-priority attached client that can format this buffer, or nil.
local function pick_client(bufnr)
	local capable = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client:supports_method("textDocument/formatting", bufnr) then
			capable[client.name] = true
		end
	end
	for _, name in ipairs(priority) do
		if capable[name] then
			return name
		end
	end
	return nil
end

--- Format a buffer with the preferred client.
---@param bufnr? integer defaults to current
---@param opts? { silent?: boolean }
---@return boolean formatted
function M.format(bufnr, opts)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	opts = opts or {}

	local name = pick_client(bufnr)
	if not name then
		if not opts.silent then
			vim.notify("No formatter attached for this buffer", vim.log.levels.WARN)
		end
		return false
	end

	local ok, err = pcall(vim.lsp.buf.format, {
		bufnr = bufnr,
		timeout_ms = 2000,
		filter = function(client)
			return client.name == name
		end,
	})

	if not ok and not opts.silent then
		vim.notify("Format failed (" .. name .. "): " .. tostring(err), vim.log.levels.ERROR)
	end
	return ok
end

local group = vim.api.nvim_create_augroup("UserFormat", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	desc = "Format on save",
	callback = function(args)
		local bufnr = args.buf

		-- Real, writable file buffers only. Formatting a terminal or a plugin
		-- scratch buffer is what causes stray write prompts.
		if vim.bo[bufnr].buftype ~= "" then
			return
		end
		if not vim.bo[bufnr].modifiable then
			return
		end
		if vim.api.nvim_buf_get_name(bufnr) == "" then
			return
		end
		if not enabled(bufnr) then
			return
		end

		M.format(bufnr, { silent = true })
	end,
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	M.format()
end, { desc = "Format buffer/selection" })

vim.keymap.set("n", "<leader>tf", function()
	vim.g.autoformat = not vim.g.autoformat
	vim.b.autoformat = nil -- drop any buffer override so the global takes effect
	vim.notify("Format on save " .. (vim.g.autoformat and "on" or "off"))
end, { desc = "Toggle format on save (global)" })

vim.keymap.set("n", "<leader>tF", function()
	vim.b.autoformat = not enabled(0)
	vim.notify("Format on save " .. (vim.b.autoformat and "on" or "off") .. " (this buffer)")
end, { desc = "Toggle format on save (buffer)" })

vim.api.nvim_create_user_command("FormatInfo", function()
	local name = pick_client(0)
	vim.notify(("Formatter: %s\nOn save: %s"):format(name or "none", enabled(0) and "on" or "off"), vim.log.levels.INFO)
end, { desc = "Show which client would format this buffer" })

return M
