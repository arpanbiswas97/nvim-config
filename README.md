# Neovim 0.12 Minimal Python Config (2026 Edition)

A professional-grade, "Out-of-the-Box" (OOTB) Neovim configuration optimized for Python development. This setup follows 2026 standards by leveraging Neovim 0.12's native features to replace heavy plugins.

## 🚀 Features

- **Native Plugin Management**: Uses `vim.pack` (no `lazy.nvim` needed).
- **Native Auto-completion**: IDE-style completion with `vim.opt.autocomplete`.
- **Native Syntax + Semantic Highlighting**: Uses Neovim's built-in filetype syntax with LSP semantic tokens from BasedPyright.
- **Optional Modern UI**: Experimental `ui2` can be enabled with `NVIM_UI2=1 nvim`.
- **Python Power Duo**: Integrated with **BasedPyright** (LSP) and **Ruff** (Linting/Formatting).
- **Virtual Env Aware**: Automatically detects `.venv` or `venv` folders in your project.
- **Transparency**: Pre-configured for a transparent background with **TokyoNight**.

## 📦 Prerequisites

Ensure you have the following installed on your system:

```bash
# Language Servers & Formatter
uv tool install basedpyright
uv tool install ruff

# Optional: Lua Formatter (for config editing)
# npm install -g stylua
```

## ⌨️ Cheat Sheet

The **Leader** key is set to `Space`.

### Navigation & Explorer
| Shortcut | Action |
| :--- | :--- |
| `<Space> e` | Open **Oil** (Edit file system like a buffer) |
| `<Space> f` | Find Files (Fuzzy search) |
| `<Space> /` | Live Grep (Search text in project) |
| `<Space> b` | Switch Buffers |

### Python & LSP
| Shortcut | Action |
| :--- | :--- |
| `gd` | Go to Definition |
| `gr` | Show References |
| `K` | Hover Documentation / Type Info |
| `<Space> rn` | Rename Symbol |
| `<Space> ca` | Code Actions (Quick fixes) |
| `gc` | Comment line/block |

### Debugging (DAP)
| Shortcut | Action |
| :--- | :--- |
| `<Space> db` | Toggle Breakpoint |
| `<Space> dc` | Continue / Start Debugging |

### General
| Shortcut | Action |
| :--- | :--- |
| `<Space> w` | Save File |
| `<Space> q` | Quit Neovim |
| `<Esc>` | Clear Search Highlights |

## 🛠️ Maintenance

To update your plugins to the latest versions:
1. Open Neovim.
2. Run `:PackUpdate`.
3. Review the changes and press `:w` to confirm the update.
4. Commit `nvim-pack-lock.json` when you want to preserve the exact plugin revisions.

## 🚀 Future Proofing (Expanding to Other Languages)

This config is designed to be easily expandable. When you're ready to learn TypeScript or Rust, follow these 2026 standards:

### 🔷 TypeScript
- **Standard LSP**: `vtsls` (Faster and more feature-rich than the old `tsserver`).
- **Tooling**:
  ```bash
  npm install -g @vtsls/language-server
  npm install -g @biomejs/biome # Modern, fast alternative to Prettier
  ```
- **Config**: Add a native `vim.lsp.config('vtsls', ...)` block and then `vim.lsp.enable('vtsls')`.

### 🦀 Rust
- **Standard LSP**: `rust-analyzer` (The industry standard).
- **Standard Plugin**: `rustaceanvim` (Succesor to rust-tools; handles Rust-specific commands natively).
- **Tooling**:
  ```bash
  rustup component add rust-analyzer
  ```
- **Config**: In Neovim 0.12, add `https://github.com/mrcjkb/rustaceanvim` to your `vim.pack.add` list. It will automatically set up `rust-analyzer` for you.

## 💡 Tips

1. **Oil.nvim**: When in the explorer (`<Space> e`), you can rename, create, or delete files just by editing the text. Save the buffer (`:w`) to apply the changes to your disk.
2. **Terminal Transparency**: If Neovim isn't transparent, ensure your terminal emulator (Alacritty, Kitty, iTerm2, etc.) has its own background opacity set to less than 100%.
3. **BasedPyright**: If you use `uv`, try launching Neovim with `uv run nvim` to perfectly lock your environment.
