# Keymaps

Leader is `<Space>`.

**The live reference beats this file.** Press `<Space>` alone and which-key lists
everything available from that prefix, read off the actual mappings — so it cannot
drift from the config the way a document can. `<leader>fk` opens the same thing as a
searchable picker. Use this file to learn what exists; use which-key to recall it.

Mappings marked _(LSP)_ only exist in buffers where a language server has attached.

## Groups

| Prefix      |                      |
| ----------- | -------------------- |
| `<leader>b` | buffers              |
| `<leader>c` | code                 |
| `<leader>d` | diagnostics          |
| `<leader>f` | find                 |
| `<leader>g` | goto                 |
| `<leader>h` | git hunks            |
| `<leader>l` | lsp                  |
| `<leader>n` | notes                |
| `<leader>p` | paths                |
| `<leader>s` | splits               |
| `<leader>t` | terminal and toggles |

No mapping is a prefix of another, so nothing stalls waiting for a second keypress.

## Find — fzf-lua

| Key          |                                              |
| ------------ | -------------------------------------------- |
| `<leader>ff` | Find files                                   |
| `<leader>fG` | Find git-tracked files                       |
| `<leader>fg` | Live grep (also works on a visual selection) |
| `<leader>fw` | Grep word under cursor                       |
| `<leader>fb` | Find buffers                                 |
| `<leader>fo` | Recent files                                 |
| `<leader>fr` | Resume last picker                           |
| `<leader>fh` | Help tags                                    |
| `<leader>fk` | Search keymaps                               |
| `<leader>fc` | Commands                                     |
| `<leader>fd` | Document diagnostics                         |
| `<leader>fD` | Workspace diagnostics                        |

## File tree — nvim-tree

`<leader>e` toggles it. Inside the tree (`?` shows the full list):

| Key               |                                         |
| ----------------- | --------------------------------------- |
| `<CR>` / `o`      | Open file, expand folder                |
| `<C-v>` / `<C-x>` | Open in vertical / horizontal split     |
| `<Tab>`           | Preview without leaving the tree        |
| `a`               | Create (trailing `/` makes a directory) |
| `d` / `r`         | Delete / rename                         |
| `x` `c` `p`       | Cut, copy, paste                        |
| `H`               | Toggle hidden files                     |
| `E` / `W`         | Expand all / collapse all               |
| `R`               | Refresh                                 |

`node_modules`, `dist` and `.turbo` are filtered out — see `filters.custom` in
`lua/plugins/tree.lua` to change that.

## Code — LSP

| Key          |                                            |
| ------------ | ------------------------------------------ |
| `<leader>gd` | Definitions (picker) _(LSP)_               |
| `<leader>gD` | Definition (direct jump) _(LSP)_           |
| `<leader>gS` | Definition in vertical split _(LSP)_       |
| `<leader>gr` | References _(LSP)_                         |
| `<leader>gi` | Implementations _(LSP)_                    |
| `<leader>gt` | Type definitions _(LSP)_                   |
| `K`          | Hover documentation _(LSP)_                |
| `<leader>ca` | Code action _(LSP)_                        |
| `<leader>cr` | Rename symbol _(LSP)_                      |
| `<leader>ci` | Organize imports _(LSP)_                   |
| `<leader>cf` | Format buffer or selection                 |
| `<leader>ls` | Document symbols _(LSP)_                   |
| `<leader>lS` | Workspace symbols _(LSP)_                  |
| `<leader>li` | Toggle inlay hints _(LSP, off by default)_ |
| `<leader>lr` | Restart LSP _(LSP)_                        |
| `<leader>ll` | LSP health / info _(LSP)_                  |
| `<leader>lm` | Open Mason                                 |

## Diagnostics

| Key                         |                                     |
| --------------------------- | ----------------------------------- |
| `<leader>dd`                | Diagnostic at cursor _(LSP)_        |
| `<leader>dl`                | Diagnostics on line _(LSP)_         |
| `<leader>dq`                | Send diagnostics to loclist _(LSP)_ |
| `<leader>dn` / `<leader>dp` | Next / previous diagnostic _(LSP)_  |
| `]d` / `[d`                 | Next / previous diagnostic          |
| `[D` / `]D`                 | First / last diagnostic in buffer   |
| `<leader>dt`                | Toggle diagnostics _(LSP)_          |

## Git

| Key          |                                     |
| ------------ | ----------------------------------- |
| `]h` / `[h`  | Next / previous hunk                |
| `]H` / `[H`  | Last / first hunk                   |
| `<leader>hs` | Stage hunk at cursor                |
| `<leader>hr` | Reset hunk at cursor                |
| `<leader>hp` | Preview diff overlay                |
| `<leader>hb` | Git blame / show at cursor          |
| `gh` / `gH`  | Apply / reset hunks, takes a motion |
| `<leader>tg` | Open lazygit                        |

`gh` is also the hunk text object, which is why the doubled `ghgh` applies the hunk
under the cursor — that is what `<leader>hs` runs.

## Completion — blink.cmp

| Key                 |                                            |
| ------------------- | ------------------------------------------ |
| `<C-Space>`         | Show / hide menu                           |
| `<CR>`              | Accept                                     |
| `<C-j>` / `<C-k>`   | Select next / previous                     |
| `<Tab>` / `<S-Tab>` | Jump forward / back through snippet fields |

## Editing — mini.nvim

| Key                   |                                                  |
| --------------------- | ------------------------------------------------ |
| `sa` + motion + char  | Add surrounding                                  |
| `sd` + char           | Delete surrounding                               |
| `sr` old new          | Replace surrounding                              |
| `sf` / `sF`           | Find surrounding right / left                    |
| `gcc`                 | Comment line                                     |
| `gc` + motion         | Comment, also works on a visual selection        |
| `<M-h/j/k/l>`         | Move line or selection                           |
| `ci(`, `ca"`, `di{` … | Standard text objects, treesitter-aware          |
| `in` / `an`           | Inside / around the **next** object, e.g. `cin(` |
| `il` / `al`           | Inside / around the **last** object              |
| `ii` / `ai`           | Inside / around the current indent scope         |
| `[i` / `]i`           | Jump to top / bottom of indent scope             |
| `[n` `]n` `[N` `]N`   | Select previous/next node, sibling node (visual) |

`mini.surround` claims the `s` prefix in normal mode, so native `s`
(substitute character) is shadowed. `cl` does the same thing.

## Buffers, splits, movement

| Key                         |                                         |
| --------------------------- | --------------------------------------- |
| `<leader>bn` / `<leader>bp` | Next / previous buffer                  |
| `<leader>bd`                | Delete buffer, keep the window          |
| `<leader>sv` / `<leader>sh` | Split vertically / horizontally         |
| `<C-h/j/k/l>`               | Move between windows _and_ tmux panes   |
| `<C-Up/Down/Left/Right>`    | Resize window                           |
| `j` / `k`                   | Down / up, wrap-aware                   |
| `<C-d>` / `<C-u>`           | Half page down / up, centered           |
| `n` / `N`                   | Next / previous search result, centered |
| `J`                         | Join lines, keep cursor position        |
| `<` / `>`                   | Indent and reselect (visual)            |
| `<Esc>`                     | Clear search highlights                 |

## Terminal and toggles

| Key          |                                         |
| ------------ | --------------------------------------- |
| `<leader>tt` | Floating terminal (keeps its session)   |
| `<leader>tg` | lazygit                                 |
| `<Esc>`      | Terminal normal mode (in terminal)      |
| `<C-q>`      | Close floating terminal (in terminal)   |
| `<leader>tf` | Toggle format on save, globally         |
| `<leader>tF` | Toggle format on save, this buffer only |
| `<leader>tw` | Toggle wrap                             |
| `<leader>ts` | Toggle spellcheck                       |
| `<leader>tz` | Trim trailing whitespace                |

`:FormatInfo` reports which client would format the current buffer.

## Paths, yanking, notes

| Key          |                                |
| ------------ | ------------------------------ |
| `<leader>pa` | Copy full file path            |
| `<leader>pr` | Copy relative file path        |
| `<leader>x`  | Delete without yanking         |
| `<leader>p`  | Paste without yanking (visual) |
| `<leader>nn` | New note                       |
| `<leader>nf` | Find note                      |
| `<leader>ns` | Search notes                   |
| `<leader>nt` | Today's daily note             |
| `<leader>nw` | Switch workspace               |

Notes mappings exist only if `~/Documents/Notes` does.

## Neovim built-ins worth knowing

These ship with Neovim 0.11+ and coexist with the mappings above. The `<leader>`
versions are the fzf-backed ones; these are always available.

| Key                               |                                            |
| --------------------------------- | ------------------------------------------ |
| `grn`                             | Rename                                     |
| `gra`                             | Code action                                |
| `grr`                             | References                                 |
| `gri`                             | Implementation                             |
| `grt`                             | Type definition                            |
| `gO`                              | Document symbols                           |
| `gx`                              | Open the file path or URL under the cursor |
| `]b` `[b` / `]q` `[q` / `]a` `[a` | Next/previous buffer, quickfix entry, arg  |
| `]<Space>` / `[<Space>`           | Add an empty line below / above            |
| `za`                              | Toggle fold (treesitter-based)             |
