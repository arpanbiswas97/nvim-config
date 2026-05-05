# Neovim 0.12+ Minimal Modern Config

A native-first Neovim configuration for **Python**, **TypeScript / JavaScript**, and **Rust** (plus Lua / JSON / YAML / Markdown / TOML / Bash). It leans on Neovim 0.12 built-ins — `vim.pack`, `vim.lsp.config`, `vim.lsp.completion`, `vim.diagnostic`, native treesitter highlighting, native commenting — and only adds plugins where they earn their place. The whole config is ~300 lines of Lua across 7 small files.

The philosophy: **prefer native features, prefer fewer plugins, prefer one clear way to do something.**

---

## What's inside

| Plugin                     | Why it's here                                                                                                                       |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `tokyonight.nvim`          | Colorscheme. Transparent variant.                                                                                                   |
| `mini.nvim`                | A coherent set of small modules: `ai`, `surround`, `pairs`, `bracketed`, `files`, `pick`, `extra`, `icons`, `statusline`, `notify`. |
| `gitsigns.nvim`            | Battle-tested git gutter + hunk staging.                                                                                            |
| `conform.nvim`             | One declarative table for ruff / biome / prettier / rustfmt / stylua / taplo / shfmt.                                               |
| `nvim-treesitter` (`main`) | Parser installer + queries. Highlighting itself is native.                                                                          |
| `nvim-lspconfig`           | Default LSP configs for basedpyright, ruff, vtsls, and rust-analyzer.                                                               |

**Intentionally not here:** `nvim-cmp` / `blink.cmp` (native `vim.lsp.completion` covers it), `oil.nvim` (`mini.files` covers it), `nvim-tree` / `neo-tree` (same), `telescope.nvim` (`mini.pick` covers it), `nvim-dap` (no breakpoint debugging today; run pdb / pytest / cargo test from `:terminal`), `Comment.nvim` / `mini.comment` (native `gc` / `gcc` covers it), `which-key.nvim` (out for now; add `mini.clue` later if you forget keymaps), `lazy.nvim` (`vim.pack` covers it).

---

## Prerequisites

### System

- **Neovim 0.12+**
- `git`
- **`tree-sitter` CLI** — required by the rewritten `nvim-treesitter` main branch to compile parsers. Install with one of:
  ```sh
  brew install tree-sitter-cli          # macOS
  sudo pacman -S tree-sitter-cli        # Arch Linux
  ```
- A **Nerd Font** for `mini.icons` (e.g. JetBrainsMono Nerd Font, FiraCode Nerd Font)
- A terminal emulator with true-color + transparency if you want the transparent theme to show through

### Language tools

Choose the platform block that applies to you, then install the shared npm tools.

```sh
# macOS
brew install basedpyright ruff rust-analyzer shfmt stylua taplo prettier

# Arch Linux
sudo pacman -S ruff rust-analyzer shfmt stylua taplo-cli prettier

# Python tools fallback, if your OS package manager does not provide them
uv tool install basedpyright
uv tool install ruff

# TypeScript / JavaScript
npm install -g @vtsls/language-server typescript
```

Rust project support also needs a working Rust toolchain with `cargo`; a standard `rustup` install includes `rustfmt`.

---

## Bootstrap on a new machine

```sh
git clone <this-repo> ~/.config/nvim
nvim                              # vim.pack clones plugins synchronously
:TSUpdate                         # or run the headless command below
```

Headless variant for non-interactive provisioning:

```sh
nvim --headless \
  "+lua require('nvim-treesitter').install({'python','typescript','tsx','javascript','rust','lua','vim','vimdoc','query','markdown','markdown_inline','json','yaml','toml','bash'})" \
  "+qa"
```

First launch: `vim.pack.add(...)` blocks until every plugin is cloned. After that opens you'll want to quit and re-launch once so the treesitter parsers compile cleanly on the next FileType events.

---

## File layout

```
~/.config/nvim/
├── init.lua                     # 7 require() lines; nothing else
├── lua/config/
│   ├── options.lua              # vim.opt + leader + filetype indent + yank highlight
│   ├── keymaps.lua              # all non-LSP keymaps (LSP keymaps live in lsp.lua)
│   ├── plugins.lua              # vim.pack.add + tokyonight + gitsigns
│   ├── mini.lua                 # all mini.* setup() calls
│   ├── treesitter.lua           # parser install + FileType autocmd + folds
│   ├── lsp.lua                  # nvim-lspconfig defaults + LspAttach + diagnostic.config
│   └── format.lua               # conform.setup + format-on-save toggle
├── nvim-pack-lock.json          # vim.pack manages this; commit it
├── .gitignore
└── README.md                    # this file
```

---

## Configuration map

Where to edit when you want to change something:

- **`options.lua`** — vim options, leader key, filetype-specific indent overrides. Edit here for tab/space/scroll/clipboard/search behavior.
- **`keymaps.lua`** — global (always-on) keymaps. Edit here for window/buffer/picker/explorer/diagnostic mappings.
- **`plugins.lua`** — the plugin list (`vim.pack.add`), colorscheme, gitsigns. Add a new plugin here.
- **`mini.lua`** — every `mini.* setup()` call. Add or remove a mini module here.
- **`treesitter.lua`** — parsers list, fold/indent behavior. Add a new language's parser here.
- **`lsp.lua`** — enabled LSP servers, the `LspAttach` autocmd (LSP keymaps + completion + inlay hints), `vim.diagnostic` styling. Add custom server overrides here only when defaults are not enough.
- **`format.lua`** — `formatters_by_ft` table, format-on-save toggle. Add a new formatter chain here.

---

## Productivity guide — the keymaps that matter

Leader is `Space`.

### Find & jump (pickers + explorer)

| Keys         | Action                                                   |
| ------------ | -------------------------------------------------------- |
| `<leader>ff` | Find files in cwd                                        |
| `<leader>fg` | Live grep across project                                 |
| `<leader>fb` | Open buffers                                             |
| `<leader>fo` | Recent (oldfiles)                                        |
| `<leader>fr` | Resume last picker                                       |
| `<leader>fh` | Help tags                                                |
| `<leader>fd` | Diagnostics picker                                       |
| `<leader>e`  | File explorer (mini.files), rooted on the current buffer |

> **Tip.** Live grep (`<leader>fg`) usually beats name-based file find when you don't know a codebase. You'll get there in 2 keystrokes. Use `<leader>fr` to re-open the previous result list without retyping a query.

### Move within a buffer

| Keys              | Action                                   |
| ----------------- | ---------------------------------------- |
| `<C-d>` / `<C-u>` | Half-page down/up, auto-recentered       |
| `n` / `N`         | Next/prev search result, auto-recentered |
| `[d` / `]d`       | Prev/next diagnostic                     |
| `[h` / `]h`       | Prev/next git hunk                       |
| `[q` / `]q`       | Prev/next quickfix entry                 |
| `[b` / `]b`       | Prev/next buffer (mini.bracketed)        |
| `[c` / `]c`       | Prev/next comment block (mini.bracketed) |
| `<S-h>` / `<S-l>` | Prev/next buffer (alternative)           |
| `<C-h/j/k/l>`     | Move between split windows               |

`mini.bracketed` adds many more `[X` / `]X` pairs (oldfile, jump, file, conflict, indent, treesitter, undo, window, yank) — all consistent. See `:h MiniBracketed`.

### Edit text fast

Native:

| Keys          | Action                                               |
| ------------- | ---------------------------------------------------- |
| `gcc`         | Toggle comment on current line (native, since 0.10)  |
| `gc{motion}`  | Toggle comment over a motion (e.g. `gcap` paragraph) |
| `gc` (visual) | Toggle comment on selection                          |

mini.surround:

| Keys               | Action                                                            |
| ------------------ | ----------------------------------------------------------------- |
| `sa{motion}{char}` | **S**urround **a**dd: e.g. `saiw"` quotes the inner word          |
| `sd{char}`         | **S**urround **d**elete: e.g. `sd"` removes nearest quotes        |
| `sr{old}{new}`     | **S**urround **r**eplace: e.g. `sr'"` swap single → double quotes |
| `sf` / `sF`        | Find next/prev surrounding char                                   |
| `sh`               | Highlight surrounding                                             |

mini.ai textobjects (extend `i` / `a`):

| Keys          | Action                                         |
| ------------- | ---------------------------------------------- |
| `vaf` / `vif` | Visual select **a**round / **i**nside function |
| `daf` / `dif` | Delete around / inside function                |
| `caf` / `cif` | Change around / inside function                |
| `vac` / `vic` | Visual select around / inside class            |
| `vai` / `vii` | Around / inside indent block                   |

`mini.pairs` auto-closes brackets / quotes as you type — no keymaps to learn.

### LSP power moves

Inside any buffer with an LSP attached:

| Keys             | Action                                                       |
| ---------------- | ------------------------------------------------------------ |
| `gd`             | Go to definition                                             |
| `gD`             | Go to declaration                                            |
| `gr`             | References                                                   |
| `gi`             | Go to implementation                                         |
| `gy`             | Go to type definition                                        |
| `K`              | Hover documentation (basedpyright wins over ruff for Python) |
| `<C-s>` (insert) | Signature help                                               |
| `<leader>rn`     | Rename symbol                                                |
| `<leader>ca`     | Code action                                                  |
| `<leader>cl`     | Run codelens                                                 |
| `<leader>cf`     | Format buffer / range                                        |
| `<leader>cd`     | Line diagnostics float                                       |
| `<leader>cq`     | Send all diagnostics → quickfix                              |
| `<leader>th`     | Toggle inlay hints (buffer)                                  |

> **Workflow.** When you don't know where to start: hover (`K`), jump (`gd`), references (`gr`). For batch fixes, dump diagnostics to quickfix with `<leader>cq` then walk them with `]q` / `[q`.

### Native completion

The completion menu pops automatically on identifier chars and `.` / `:` (driven by the LSP server's trigger characters).

| Keys              | Action                            |
| ----------------- | --------------------------------- |
| `<C-n>` / `<C-p>` | Next/prev item                    |
| `<CR>`            | Accept                            |
| `<C-e>`           | Dismiss                           |
| `<C-y>`           | Confirm without inserting newline |

Snippets: `vim.snippet` is built-in but minimal. If a server returns a snippet, `<Tab>` / `<S-Tab>` jump between placeholders.

### Format / save

Format runs on every `:w` via conform with `lsp_format = "fallback"`.

| Keys         | Action                                         |
| ------------ | ---------------------------------------------- |
| `:w`         | Save and format                                |
| `<leader>cf` | Format buffer / range explicitly               |
| `<leader>uf` | Toggle format-on-save **globally**             |
| `<leader>uF` | Toggle format-on-save for **this buffer only** |

> **Tip.** `<leader>uF` is for the case where you're hacking on a project with non-standard formatting and don't want the auto-format wars. `<leader>uf` flips the global switch for the session.

### Git (gitsigns)

| Keys         | Action                  |
| ------------ | ----------------------- |
| `]h` / `[h`  | Next/prev hunk          |
| `<leader>hs` | Stage hunk              |
| `<leader>hr` | Reset hunk              |
| `<leader>hu` | Undo stage hunk         |
| `<leader>hp` | Preview hunk            |
| `<leader>hb` | Blame line (full popup) |
| `<leader>hd` | Diff against index      |

> **Workflow.** `<leader>hs` hunk-by-hunk to craft a clean commit, no terminal needed. `<leader>hp` previews exactly what would be reverted before you `<leader>hr`.

### Windows, buffers, files

| Keys              | Action        |
| ----------------- | ------------- |
| `<C-h/j/k/l>`     | Window nav    |
| `<S-h>` / `<S-l>` | Cycle buffers |
| `<leader>bd`      | Delete buffer |
| `<leader>w`       | Save          |
| `<leader>q`       | Quit          |

### Terminal

| Keys         | Action                              |
| ------------ | ----------------------------------- |
| `<leader>tt` | Open terminal in current window     |
| `<Esc><Esc>` | Exit terminal mode (back to normal) |

### Explorer (mini.files)

`<leader>e` opens a column-view explorer rooted on the current buffer's file. Inside the explorer:

| Keys      | Action                      |
| --------- | --------------------------- |
| `<CR>`    | Enter directory / open file |
| `-`       | Go up a directory           |
| `g.`      | Toggle hidden files         |
| `h` / `l` | Move column                 |
| `q`       | Close                       |

The trick of mini.files: it's just a buffer. Edit it like text.

- **Rename** = change the line text, then `:w`
- **Delete** = delete the line, then `:w`
- **Create** = add a new line with the desired filename (or `dirname/`), then `:w`
- **Move** = cut the line in one mini.files window, paste in another, then `:w`

### Other niceties

| Keys                 | Action                             |
| -------------------- | ---------------------------------- |
| `<Esc>` (normal)     | Clear search highlight             |
| `<leader>p` (visual) | Paste without overwriting register |
| `<leader>D`          | Delete to black hole register      |

---

## Day-to-day workflows

**Refactoring across a Python project.** `<leader>fg` to grep for the call site, `gd` to jump to the function definition, `<leader>rn` to rename it (basedpyright propagates across the workspace), `<leader>cq` to dump remaining issues to quickfix and `]q` through them. Format on save will keep imports in order via ruff.

**Reading an unfamiliar TypeScript codebase.** `<leader>ff` to a likely entry point. `K` over identifiers to learn types. `gd` to chase signatures. Inlay hints fill in implicit types — toggle them with `<leader>th` when they get noisy.

**Cleaning up before a commit.** Open the file, `]h` to walk hunks, `<leader>hp` to preview each, `<leader>hs` to stage the ones you want, `<leader>hr` to throw the rest away. Drop to `<leader>tt` for `git commit`.

**Working in a project with a non-standard formatter.** `<leader>uF` to disable format-on-save for the buffer. Format manually with `<leader>cf` only when you've checked the project's rules.

**Debugging without DAP.** Drop a `breakpoint()` in Python (or `dbg!()` in Rust), `<leader>tt` to open a terminal split, run `pytest -x` or `cargo test`, step through there. Lighter than a DAP setup; sufficient most days.

---

## Maintenance

```vim
:lua vim.pack.update()    " update plugins; rewrites nvim-pack-lock.json
:PackUpdate               " same, via the user command
:TSUpdate                 " update treesitter parsers
:checkhealth              " sanity-check everything
```

Commit `nvim-pack-lock.json` to pin plugin revisions. When removing a plugin from `vim.pack.add`, also run `:lua vim.pack.del({ "plugin-name" })` so Neovim removes it from disk and updates the lockfile.

---

## Adding a new language

Suppose you want Go.

1. **Install tools** outside Neovim: `go install golang.org/x/tools/gopls@latest` and `go install mvdan.cc/gofumpt@latest`.
2. **Add the parser** in `lua/config/treesitter.lua`: append `"go"` to the `parsers` table, then `:TSUpdate`.
3. **Add the LSP** in `lua/config/lsp.lua`: add `"gopls"` to the `vim.lsp.enable({...})` list. Add a `vim.lsp.config("gopls", { ... })` override only if you need custom behavior.
4. **Add the formatter** in `lua/config/format.lua`: `go = { "gofumpt" }` to `formatters_by_ft`.
5. Restart and open a `.go` file. `:checkhealth lsp` should show gopls attached.

---

## Troubleshooting

| Symptom                          | First check                                                                                                                 |
| -------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| LSP not attaching                | `:checkhealth lsp` — the bottom shows configured / enabled / attached counts                                                |
| Completion not popping           | `:lua =vim.lsp.completion.get()` returns truthy in your buffer? Confirm `vim.lsp.completion.enable(...)` ran in `LspAttach` |
| Treesitter highlighting missing  | Confirm `tree-sitter` is on PATH (`tree-sitter --version`); then `:TSUpdate` and re-open the buffer                         |
| `rust_analyzer` not attaching    | Confirm `rust-analyzer` is on PATH and open a Rust file inside a Cargo project                                              |
| Python venv not detected         | Set `pythonPath` in `pyproject.toml` (`[tool.basedpyright] venvPath = "..."`) or add a `pyrightconfig.json`                 |
| Formatter changes nothing        | `:ConformInfo` — shows what conform will run for this filetype and which formatters are available on PATH                   |
| `version = "main"` plugin issues | `vim.pack.update()` — sometimes a remote rewrite needs a re-fetch                                                           |

---

## Philosophy — what's intentionally missing

**Small `nvim-lspconfig` layer.** LSP still uses Neovim's native `vim.lsp.config()` / `vim.lsp.enable()` APIs; `nvim-lspconfig` supplies the default server configs so this file can stay small.

**No DAP.** Breakpoint debugging is great when you need it, but most day-to-day Python work is `breakpoint()` + a `:terminal` running pytest. Until you actually want to step through bytecode, the plugin tax isn't worth paying.

**No completion plugin.** `vim.lsp.completion.enable()` with `autotrigger = true` plus `completeopt = "...,fuzzy"` gets you most of the way to a blink.cmp / nvim-cmp experience. Snippets and signature help are leaner — that's the trade.

**No `oil.nvim` / `nvim-tree` / `telescope`.** `mini.files` and `mini.pick` are part of a plugin you already have for `mini.ai`, `mini.surround`, and friends. One plugin, fewer keymaps to remember.

**No `which-key.nvim`.** Try the keymaps for two weeks first. If you forget often, `mini.clue` is the lighter follow-up.

---

## Optional follow-ups

When and if you want them:

- `mini.clue` for keymap discovery (lighter than which-key, integrated with mini.nvim)
- `mini.move` for `<A-j>` / `<A-k>` line and block movement
- `lazydev.nvim` for richer Neovim Lua API completion when editing this config
- `snacks.picker` if `mini.pick` UX feels limiting on large repos
- `nvim-dap` + `nvim-dap-python` if breakpoint debugging becomes a daily need
