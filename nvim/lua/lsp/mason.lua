-- ============================================================================
-- MASON — automatic toolchain provisioning
-- ============================================================================
--
-- This is the piece that was missing. `require("mason").setup({})` only
-- installs the :Mason *UI*; it does not install any package. Without the tool
-- installer below, every vim.lsp.enable() call is a silent no-op on a fresh
-- machine and efm has no binaries to shell out to, so nothing ever formats.
--
-- Declaring the list here means a new machine provisions itself on first
-- launch instead of needing ~20 packages typed into :Mason by hand.
--
-- Names must match the mason registry, not the lspconfig server name
-- (e.g. "typescript-language-server", not "ts_ls").

require("mason").setup({
	ui = {
		border = "rounded",
		icons = {
			package_installed = "\u{f058}",
			package_pending = "\u{f252}",
			package_uninstalled = "\u{f057}",
		},
	},
})

require("mason-tool-installer").setup({
	ensure_installed = {
		-- Language servers
		"lua-language-server",
		"typescript-language-server",
		"biome", -- lint + format for the work stack
		"yaml-language-server",
		"dockerfile-language-server",
		"bash-language-server",
		"pyright",
		"gopls",
		"clangd",
		"efm", -- generic wrapper, see lsp/efm.lua

		-- efm backends
		--
		-- Everything here ships as a prebuilt binary or an npm package. That is
		-- deliberate: mason's pypi and luarocks installers need `pip` and
		-- `luarocks` on the host, and silently fail without them. Adding a tool
		-- that installs from those sources means a new machine comes up short.
		"stylua",
		"ruff", -- lint + format for Python; replaces black and flake8
		"shfmt",
		"shellcheck",
		"gofumpt",
		"revive",
		"prettierd", -- markdown/html/yaml, and a JS fallback when biome is absent
	},

	-- Check on startup and install anything missing. Fast when nothing is.
	run_on_start = true,
	-- Pin versions by hand rather than silently moving under a work repo.
	auto_update = false,
	start_delay = 1000,
})

-- rust-analyzer is deliberately absent: rustaceanvim expects the rustup-managed
-- one and mason's copy fights it. Install with:
--   rustup component add rust-analyzer

vim.keymap.set("n", "<leader>lm", "<cmd>Mason<CR>", { desc = "Mason (manage tools)" })
