-- Neovim 0.12 Minimal Configuration (Python Focused - 2026)

-------------------------------------------------------------------------------
-- 1. NATIVE OPTIONS
-------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Essential UI
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers for easier jumping
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.termguicolors = true -- True color support
vim.opt.cursorline = true -- Highlight the current line
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.opt.signcolumn = "yes" -- Always show sign column (prevents flickering)

-- Search & Behavior
vim.opt.ignorecase = true -- Case insensitive search...
vim.opt.smartcase = true -- ...unless uppercase used
vim.opt.hlsearch = false -- Clear search highlight after use
vim.opt.wrap = false -- Don't wrap lines
vim.opt.breakindent = true -- Indent wrapped lines

-- Python/General Indentation (4 spaces)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- 0.12 Native Completion
vim.opt.autocomplete = true -- Native auto-completion

-- Experimental 0.12 UI overhaul. Enable with: NVIM_UI2=1 nvim
if vim.env.NVIM_UI2 == "1" then
	pcall(function()
		require("vim._core.ui2").enable()
	end)
end

-------------------------------------------------------------------------------
-- 2. PLUGIN MANAGEMENT (vim.pack)
-------------------------------------------------------------------------------
vim.pack.add({
	"https://github.com/folke/tokyonight.nvim", -- Theme
	"https://github.com/echasnovski/mini.nvim", -- Essential minimal modules
	"https://github.com/stevearc/oil.nvim", -- File system editor
	"https://github.com/lewis6991/gitsigns.nvim", -- Git integration
	"https://github.com/stevearc/conform.nvim", -- Formatting (Ruff)
	"https://github.com/mfussenegger/nvim-dap", -- Debugging
	"https://github.com/mfussenegger/nvim-dap-python",
})

-- Set colorscheme
require("tokyonight").setup({
	transparent = true, -- Enable transparency
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
})
vim.cmd.colorscheme("tokyonight")

-------------------------------------------------------------------------------
-- 3. PLUGIN SETUP
-------------------------------------------------------------------------------
-- mini.nvim: Only the essentials
require("mini.pick").setup() -- Fuzzy finder (:Pick files, :Pick grep_live)
require("mini.statusline").setup() -- Clean status bar
require("mini.pairs").setup() -- Auto-close brackets/quotes
require("mini.comment").setup() -- Commenting with 'gc'
require("mini.icons").setup() -- Icons for various UI elements

-- oil.nvim: Edit your file system like a buffer
require("oil").setup({
	columns = { "icon" },
	view_options = { show_hidden = true },
})

-- gitsigns: Git gutter signs and hunk staging
require("gitsigns").setup()

-- conform.nvim: Formatting on save
require("conform").setup({
	formatters_by_ft = {
		python = { "ruff_organize_imports", "ruff_format" },
		lua = { "stylua" },
	},
	format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})

-------------------------------------------------------------------------------
-- 4. PYTHON & LSP (0.12 Native)
-------------------------------------------------------------------------------
local python_root_markers = {
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"Pipfile",
	"pyrightconfig.json",
	".git",
}

local function get_python_root(bufnr)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	return vim.fs.root(bufnr, python_root_markers) or (bufname ~= "" and vim.fs.dirname(bufname)) or vim.uv.cwd()
end

-- Helper to find python path from the active project.
local function get_python_path(root_dir)
	local venv = vim.fs.find({ ".venv", "venv" }, {
		path = root_dir or vim.uv.cwd(),
		upward = true,
		type = "directory",
		limit = 1,
	})[1]

	if venv then
		local python = vim.fs.joinpath(venv, "bin", "python")
		if vim.uv.fs_stat(python) then
			return python
		end
	end

	return "python3"
end

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
if lsp_capabilities.workspace then
	lsp_capabilities.workspace.didChangeWatchedFiles = nil
end

vim.lsp.config("*", {
	capabilities = lsp_capabilities,
})

-- Native 0.12 LSP Configuration
vim.lsp.config("basedpyright", {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_dir = function(bufnr, on_dir)
		on_dir(get_python_root(bufnr))
	end,
	before_init = function(_, config)
		config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
			python = { pythonPath = get_python_path(config.root_dir) },
		})
	end,
	settings = {
		basedpyright = {
			analysis = {
				diagnosticMode = "openFilesOnly",
				typeCheckingMode = "standard",
			},
		},
	},
})

vim.lsp.config("ruff", {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_dir = function(bufnr, on_dir)
		on_dir(get_python_root(bufnr))
	end,
	on_attach = function(client)
		client.server_capabilities.hoverProvider = false
	end,
	init_options = {
		settings = {
			logLevel = "warn",
		},
	},
})

vim.lsp.enable({ "basedpyright", "ruff" })

-- Python Debugging (DAP)
require("dap-python").setup(get_python_path(vim.uv.cwd()))

-------------------------------------------------------------------------------
-- 5. KEYMAPS
-------------------------------------------------------------------------------
local map = vim.keymap.set

-- Navigation
map("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Explorer" })
map("n", "<leader>f", "<CMD>Pick files<CR>", { desc = "Find Files" })
map("n", "<leader>/", "<CMD>Pick grep_live<CR>", { desc = "Live Grep" })
map("n", "<leader>b", "<CMD>Pick buffers<CR>", { desc = "Buffers" })

-- LSP Actions (Native 0.12)
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

-- Debugging
map("n", "<leader>db", '<CMD>lua require"dap".toggle_breakpoint()<CR>', { desc = "Toggle Breakpoint" })
map("n", "<leader>dc", '<CMD>lua require"dap".continue()<CR>', { desc = "Continue/Start Debug" })

-- General
map("n", "<leader>w", "<CMD>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<CMD>q<CR>", { desc = "Quit" })
map("n", "<ESC>", "<CMD>noh<CR>", { desc = "Clear Highlight" })

-- Auto-update plugins command
vim.api.nvim_create_user_command("PackUpdate", function()
	vim.pack.update()
end, { desc = "Update all plugins" })
