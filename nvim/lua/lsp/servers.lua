-- ============================================================================
-- LANGUAGE SERVERS
-- ============================================================================
--
-- Each vim.lsp.config() call layers on top of nvim-lspconfig's shipped default
-- for that server. The module returns the names to hand to vim.lsp.enable().

-- TypeScript inlay hints. Shared by the typescript and javascript sections
-- because ts_ls wants the same block under both keys.
local inlay_hints = {
	includeInlayParameterNameHints = "literals",
	includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	includeInlayFunctionParameterTypeHints = true,
	includeInlayVariableTypeHints = false,
	includeInlayPropertyDeclarationTypeHints = true,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayEnumMemberValueHints = true,
}

vim.lsp.config("ts_ls", {
	settings = {
		typescript = {
			inlayHints = inlay_hints,
			-- Fills in parentheses and argument placeholders on accept, which
			-- helps with NestJS decorators and constructor injection.
			suggest = { completeFunctionCalls = true },
		},
		javascript = {
			inlayHints = inlay_hints,
			suggest = { completeFunctionCalls = true },
		},
	},
	-- If the work monorepo uses path aliases (@app/..., @modules/...) and you
	-- want auto-imports to match, set:
	--   init_options = { preferences = { importModuleSpecifierPreference = "non-relative" } }
})

-- Biome supplies both linting and formatting for the work stack.
--
-- lspconfig's default config already does the right thing here, so this is
-- mostly documentation:
--   * workspace_required = true, and a root_dir that returns nil unless a
--     biome.json / biome.jsonc (or a package.json with a "biomejs" key) is
--     found above the file. It will not attach to unrelated JS projects.
--   * it prefers <root>/node_modules/.bin/biome over anything global, so a
--     repo gets checked with the exact version it pins.
vim.lsp.config("biome", {})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim", "MiniIcons", "Statusline" } },
			workspace = {
				-- Completion and docs for the nvim API while editing this config.
				library = { vim.env.VIMRUNTIME },
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			-- Otherwise it flags every map whose keys are not alphabetical.
			keyOrdering = false,
		},
	},
})

vim.lsp.config("dockerls", {})
vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
vim.lsp.config("gopls", {})
vim.lsp.config("clangd", {})

-- No Rust setup here. If that changes, rustaceanvim is the way to add it: it
-- owns the rust_analyzer client itself, so it goes in the plugin list and gets
-- its capabilities via vim.g.rustaceanvim rather than being listed below.

return {
	"ts_ls",
	"biome",
	"lua_ls",
	"yamlls",
	"dockerls",
	"pyright",
	"bashls",
	"gopls",
	"clangd",
	"efm",
}
