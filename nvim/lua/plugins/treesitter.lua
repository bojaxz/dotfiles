-- ============================================================================
-- TREESITTER (main branch API)
-- ============================================================================

local treesitter = require("nvim-treesitter")
treesitter.setup({})

local ensure_installed = {
	"vim",
	"vimdoc",
	"lua",
	"bash",
	"c",
	"cpp",
	"go",
	"gomod",
	"rust",
	"python",
	"html",
	"css",
	"javascript",
	"jsdoc",
	"typescript",
	"tsx", -- .tsx had no parser before; typescript alone does not cover it
	"vue",
	"svelte",
	"json", -- also handles jsonc; there is no separate jsonc parser
	"yaml", -- CI configs, k8s manifests, docker-compose
	"toml",
	"dockerfile",
	"sql",
	"markdown",
	"markdown_inline",
	"gitcommit",
	"gitignore",
	"diff",
	"regex",
	"query",
}

local config = require("nvim-treesitter.config")

local already_installed = config.get_installed()
local parsers_to_install = {}

for _, parser in ipairs(ensure_installed) do
	if not vim.tbl_contains(already_installed, parser) then
		table.insert(parsers_to_install, parser)
	end
end

if #parsers_to_install > 0 then
	treesitter.install(parsers_to_install)
end

local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	desc = "Start treesitter for installed parsers",
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if lang and vim.list_contains(config.get_installed(), lang) then
			vim.treesitter.start(args.buf)
		end
	end,
})
