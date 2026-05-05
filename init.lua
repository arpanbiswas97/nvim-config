-- Neovim 0.12 Minimal Configuration (Python Focused - 2026)

-------------------------------------------------------------------------------
-- 1. NATIVE OPTIONS
-------------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Essential UI
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Relative line numbers for easier jumping
vim.opt.mouse = 'a'             -- Enable mouse support
vim.opt.termguicolors = true    -- True color support
vim.opt.cursorline = true       -- Highlight the current line
vim.opt.scrolloff = 10          -- Keep 10 lines above/below cursor
vim.opt.signcolumn = 'yes'      -- Always show sign column (prevents flickering)

-- Search & Behavior
vim.opt.ignorecase = true       -- Case insensitive search...
vim.opt.smartcase = true        -- ...unless uppercase used
vim.opt.hlsearch = false        -- Clear search highlight after use
vim.opt.wrap = false            -- Don't wrap lines
vim.opt.breakindent = true      -- Indent wrapped lines

-- Python/General Indentation (4 spaces)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- 0.12 Native Completion & UI
vim.opt.autocomplete = true    -- Native auto-completion
pcall(function() require('vim._core.ui2').enable() end) -- Modern UI overhaul

-------------------------------------------------------------------------------
-- 2. PLUGIN MANAGEMENT (vim.pack)
-------------------------------------------------------------------------------
vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',    -- Theme
  'https://github.com/echasnovski/mini.nvim',    -- Essential minimal modules
  'https://github.com/stevearc/oil.nvim',        -- File system editor
  'https://github.com/lewis6991/gitsigns.nvim',  -- Git integration
  'https://github.com/stevearc/conform.nvim',    -- Formatting (Ruff)
  'https://github.com/mfussenegger/nvim-dap',    -- Debugging
  'https://github.com/mfussenegger/nvim-dap-python',
})

-- Set colorscheme
require('tokyonight').setup({
  transparent = true, -- Enable transparency
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
})
vim.cmd.colorscheme('tokyonight')

-------------------------------------------------------------------------------
-- 3. PLUGIN SETUP
-------------------------------------------------------------------------------
-- mini.nvim: Only the essentials
require('mini.pick').setup()       -- Fuzzy finder (:Pick files, :Pick grep_live)
require('mini.statusline').setup()  -- Clean status bar
require('mini.pairs').setup()       -- Auto-close brackets/quotes
require('mini.comment').setup()     -- Commenting with 'gc'
require('mini.icons').setup()       -- Icons for various UI elements

-- oil.nvim: Edit your file system like a buffer
require('oil').setup({ columns = { "icon" } })

-- gitsigns: Git gutter signs and hunk staging
require('gitsigns').setup()

-- conform.nvim: Formatting on save
require('conform').setup({
  formatters_by_ft = {
    python = { "ruff_format", "ruff_organize_imports" },
    lua = { "stylua" },
  },
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
})

-------------------------------------------------------------------------------
-- 4. PYTHON & LSP (0.12 Native)
-------------------------------------------------------------------------------
-- Helper to find python path (looks for .venv/bin/python)
local function get_python_path()
  local venv = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
  if venv ~= '' then
    return vim.fn.fnamemodify(venv, ':p') .. 'bin/python'
  end
  return 'python3'
end

-- Native 0.12 LSP Configuration
vim.lsp.config('basedpyright', {
  settings = {
    python = { pythonPath = get_python_path() },
    basedpyright = {
      analysis = { typeCheckingMode = 'standard' }
    }
  }
})

vim.lsp.enable('basedpyright')
vim.lsp.enable('ruff')

-- Python Debugging (DAP)
require('dap-python').setup(get_python_path())

-------------------------------------------------------------------------------
-- 5. KEYMAPS
-------------------------------------------------------------------------------
local map = vim.keymap.set

-- Navigation
map('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Explorer' })
map('n', '<leader>f', '<CMD>Pick files<CR>', { desc = 'Find Files' })
map('n', '<leader>/', '<CMD>Pick grep_live<CR>', { desc = 'Live Grep' })
map('n', '<leader>b', '<CMD>Pick buffers<CR>', { desc = 'Buffers' })

-- LSP Actions (Native 0.12)
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })

-- Debugging
map('n', '<leader>db', '<CMD>lua require"dap".toggle_breakpoint()<CR>', { desc = 'Toggle Breakpoint' })
map('n', '<leader>dc', '<CMD>lua require"dap".continue()<CR>', { desc = 'Continue/Start Debug' })

-- General
map('n', '<leader>w', '<CMD>w<CR>', { desc = 'Save' })
map('n', '<leader>q', '<CMD>q<CR>', { desc = 'Quit' })
map('n', '<ESC>', '<CMD>noh<CR>', { desc = 'Clear Highlight' })

-- Auto-update plugins command
vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, { desc = 'Update all plugins' })
