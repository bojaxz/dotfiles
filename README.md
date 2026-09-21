# dotfiles

Neovim configuration, plus the Homebrew packages it depends on.

## New machine setup

1. Install [Homebrew](https://brew.sh)
2. Clone this repo
3. Install a Nerd Font — <https://www.nerdfonts.com/font-downloads> (FiraCode Nerd Font
   recommended) and set it as your terminal font. The statusline and file tree use
   its glyphs.
4. Run `./install.sh`
5. Open `nvim`. On first launch it clones plugins, compiles treesitter parsers, and
   installs the language servers via Mason. This takes a minute.
6. **Restart nvim** so the servers installed in step 5 attach.
7. `:checkhealth` to confirm.

Requires Neovim 0.12+ (the config uses `vim.pack`). `install.sh` warns if the `nvim`
on your PATH is older — a hand-built binary in `~/.local/bin` will shadow Homebrew's.

## Layout

```
nvim/
  init.lua              entry point; sets leader, then requires the rest
  lua/core/             options, keymaps, autocmds, statusline, floating terminal
  lua/plugins/          vim.pack list and one module per plugin
  lua/lsp/              mason, servers, efm, completion, format-on-save
```

Plugin revisions are pinned in `nvim/nvim-pack-lock.json`. Update with
`:lua vim.pack.update()`.

## Language support

Mason provisions everything automatically from the list in `lua/lsp/mason.lua`.
Nothing needs installing by hand.

| Language | Server | Lint | Format |
| --- | --- | --- | --- |
| TypeScript / JavaScript | `ts_ls` | biome | biome |
| Lua | `lua_ls` | `lua_ls` | stylua |
| Python | `pyright` | ruff | ruff |
| Go | `gopls` | revive | gofumpt |
| Shell | `bashls` | shellcheck | shfmt |
| C / C++ | `clangd` | `clangd` | `clangd` |
| YAML / Docker | `yamlls`, `dockerls` | — | prettierd |
| Markdown / HTML / CSS | — | — | prettierd / biome |

### How biome and prettier coexist

Biome only attaches in a repo that has a `biome.json` (or a `package.json` with a
`biomejs` key), and it prefers that repo's own `node_modules/.bin/biome`, so a project
is checked with the version it pins. In those repos biome does both the linting and
the formatting, and it outranks everything else in `lua/lsp/format.lua`.

Outside such a repo, biome does not start and efm formats JS/TS with prettierd
instead. eslint is deliberately absent — running it next to biome means two linters
reporting the same problems on the same line.

To make biome the only thing that ever touches JS/TS, delete the js/ts/json entries
from `lua/lsp/efm.lua`.

### Adding a language

Add the server to `lua/lsp/servers.lua` (config block plus the returned list) and its
Mason package to `lua/lsp/mason.lua`. If it should be allowed to format, add it to the
priority list in `lua/lsp/format.lua` — servers not on that list never format, which
is what keeps `ts_ls` from fighting biome.

Prefer packages that ship as prebuilt binaries or npm modules. Mason's pypi and
luarocks installers need `pip` and `luarocks` present on the host and fail quietly
without them.

Rust is the exception to the above: it wants rustaceanvim, which owns the
`rust_analyzer` client itself rather than going through `vim.lsp.enable`, and the
rustup-managed server rather than Mason's (`rustup component add rust-analyzer`).

## Keymaps

Leader is `<Space>`. Press it alone to browse everything via which-key — every
mapping carries a description, so the popup and `<leader>fk` are the real reference.
No mapping is a prefix of another, so nothing stalls waiting for a second key.

| Group | |
| --- | --- |
| `<leader>b` | buffers |
| `<leader>c` | code (action, rename, format, organize imports) |
| `<leader>d` | diagnostics |
| `<leader>f` | find (fzf-lua) |
| `<leader>g` | goto (definition, references, implementations) |
| `<leader>h` | git hunks |
| `<leader>l` | lsp (symbols, restart, inlay hints, Mason) |
| `<leader>n` | notes (Obsidian) |
| `<leader>p` | copy file path |
| `<leader>s` | splits |
| `<leader>t` | terminal and toggles |

Frequently used, outside the groups:

| Key | |
| --- | --- |
| `<leader>e` | toggle file tree |
| `<leader>ff` / `<leader>fg` | find files / live grep |
| `<leader>gd` | go to definition |
| `<leader>ca` / `<leader>cr` | code action / rename |
| `<leader>tt` / `<leader>tg` | floating terminal / lazygit |
| `K` | hover docs |
| `]d` `[d` / `]h` `[h` | next/prev diagnostic / git hunk |
| `<Esc>` | clear search highlights |
| `<M-h/j/k/l>` | move line or selection (mini.move) |
| `<C-h/j/k/l>` | move between windows and tmux panes |

### Formatting

Format-on-save picks the highest-priority attached server that can format, in the
order listed in `lua/lsp/format.lua`. `:FormatInfo` shows which one would run for
the current buffer.

- `<leader>cf` — format now
- `<leader>tf` — toggle format-on-save globally
- `<leader>tF` — toggle it for the current buffer only

## Optional: Obsidian

`<leader>n` mappings only exist if the vault directory does. To enable:

```sh
mkdir -p ~/Documents/Notes
```
