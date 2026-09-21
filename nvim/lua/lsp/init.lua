-- ============================================================================
-- LSP
-- ============================================================================
--
-- Load order:
--   mason      first, so its bin dir is on PATH before any server spawns
--   completion next, because servers.lua asks blink for capabilities
--   servers / efm / format, then enable

require("lsp.mason")
require("lsp.completion")

-- Diagnostics ---------------------------------------------------------------
local diagnostic_signs = {
	Error = "\u{f057} ",
	Warn = "\u{f071} ",
	Hint = "\u{ea61}",
	Info = "\u{f05a}",
}

vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

-- Rounded borders on every LSP float (hover, signature help).
do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

-- Capabilities for every server, including ones configured elsewhere.
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

local servers = require("lsp.servers")
require("lsp.efm")
require("lsp.format")

-- Buffer-local mappings -----------------------------------------------------
--
-- These are set on attach so they only exist where a server is running.
-- Every one carries a desc, so :map, <leader>fk and which-key all show them.
local function on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local fzf = require("fzf-lua")

	local function map(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end

	-- goto
	map("<leader>gd", function()
		fzf.lsp_definitions({ jump_to_single_result = true })
	end, "Definitions (picker)")
	map("<leader>gD", vim.lsp.buf.definition, "Definition (direct jump)")
	map("<leader>gS", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, "Definition in vertical split")
	map("<leader>gr", fzf.lsp_references, "References")
	map("<leader>gi", fzf.lsp_implementations, "Implementations")
	map("<leader>gt", fzf.lsp_typedefs, "Type definitions")

	-- lsp
	map("<leader>ls", fzf.lsp_document_symbols, "Document symbols")
	map("<leader>lS", fzf.lsp_workspace_symbols, "Workspace symbols")
	map("<leader>ll", "<cmd>checkhealth vim.lsp<CR>", "LSP health/info")
	map("<leader>lr", "<cmd>LspRestart<CR>", "Restart LSP")

	-- code
	map("<leader>ca", vim.lsp.buf.code_action, "Code action")
	map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")

	-- diagnostics
	map("<leader>dd", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, "Diagnostic at cursor")
	map("<leader>dl", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, "Diagnostics on line")
	map("<leader>dq", function()
		vim.diagnostic.setloclist({ open = true })
	end, "Diagnostics to loclist")
	map("<leader>dn", function()
		vim.diagnostic.jump({ count = 1 })
	end, "Next diagnostic")
	map("<leader>dp", function()
		vim.diagnostic.jump({ count = -1 })
	end, "Previous diagnostic")
	map("]d", function()
		vim.diagnostic.jump({ count = 1 })
	end, "Next diagnostic")
	map("[d", function()
		vim.diagnostic.jump({ count = -1 })
	end, "Previous diagnostic")
	map("<leader>dt", function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	end, "Toggle diagnostics")

	map("K", vim.lsp.buf.hover, "Hover documentation")

	if client:supports_method("textDocument/codeAction", bufnr) then
		map("<leader>ci", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
			})
		end, "Organize imports")
	end

	-- Inlay hints are configured in servers.lua but start off; they crowd the
	-- line in a NestJS constructor. Toggle per buffer.
	if client:supports_method("textDocument/inlayHint", bufnr) then
		map("<leader>li", function()
			local on = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
			vim.lsp.inlay_hint.enable(not on, { bufnr = bufnr })
			vim.notify("Inlay hints " .. (on and "off" or "on"))
		end, "Toggle inlay hints")
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
	callback = on_attach,
})

vim.lsp.enable(servers)
