-- ============================================================================
-- efm — generic linter/formatter bridge
-- ============================================================================
--
-- Division of labour with biome:
--
--   * biome owns linting AND formatting for js/ts/jsx/tsx/json/css in any repo
--     that has a biome.json. It outranks efm in lsp/format.lua.
--   * efm keeps prettierd registered for those filetypes as a FORMAT-ONLY
--     fallback, so a scratch JS file outside a biome repo still formats.
--   * eslint_d is deliberately gone. Running it alongside biome means two
--     linters publishing overlapping diagnostics on the same line, and the
--     work repo uses biome as its linter.
--
-- To make biome the only thing that ever touches JS/TS, delete the js/ts/json
-- entries from `languages` and their filetypes from `filetypes`.

-- Nothing here needs a language server that already covers the same ground:
--   * lua_ls diagnoses Lua, so luacheck is gone (stylua still formats)
--   * clangd diagnoses AND formats C/C++ natively with clang-format rules, so
--     c/cpp are absent entirely
--   * ruff replaces black + flake8 with one prebuilt binary
local stylua = require("efmls-configs.formatters.stylua")

local ruff_lint = require("efmls-configs.linters.ruff")
local ruff_format = require("efmls-configs.formatters.ruff")
local ruff_sort = require("efmls-configs.formatters.ruff_sort")

local prettier_d = require("efmls-configs.formatters.prettier_d")

local shellcheck = require("efmls-configs.linters.shellcheck")
local shfmt = require("efmls-configs.formatters.shfmt")

local go_revive = require("efmls-configs.linters.go_revive")
local gofumpt = require("efmls-configs.formatters.gofumpt")

vim.lsp.config("efm", {
	filetypes = {
		"css",
		"scss",
		"go",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"jsonc",
		"lua",
		"markdown",
		"python",
		"sh",
		"typescript",
		"typescriptreact",
		"yaml",
	},
	init_options = { documentFormatting = true, documentRangeFormatting = true },
	settings = {
		rootMarkers = { ".git/" },
		languages = {
			go = { gofumpt, go_revive },
			lua = { stylua },
			python = { ruff_format, ruff_sort, ruff_lint },
			sh = { shfmt, shellcheck },

			-- prettierd only, no linters: see the note above.
			css = { prettier_d },
			scss = { prettier_d },
			html = { prettier_d },
			markdown = { prettier_d },
			yaml = { prettier_d },
			json = { prettier_d },
			jsonc = { prettier_d },
			javascript = { prettier_d },
			javascriptreact = { prettier_d },
			typescript = { prettier_d },
			typescriptreact = { prettier_d },
		},
	},
})
