vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.wrap = false
opt.breakindent = true
opt.list = true
opt.listchars = { tab = "› ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " " }
opt.splitright = true
opt.splitbelow = true
opt.mouse = "a"

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 400

opt.clipboard = "unnamedplus"

opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" }
opt.pumheight = 12

opt.shortmess:append("c")
opt.confirm = true

local indent_group = vim.api.nvim_create_augroup("user_ft_indent", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "python", "rust" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "go", "make" },
  callback = function()
    vim.bo.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("user_yank_highlight", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})
