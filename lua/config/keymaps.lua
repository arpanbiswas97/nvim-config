local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })

map("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })
map({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete to black hole" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>cq", vim.diagnostic.setqflist, { desc = "Diagnostics → quickfix" })

map("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Terminal" })
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

map("n", "[q", "<cmd>cprev<cr>", { desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })

map("n", "<leader>e", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "File explorer" })

map("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Pick grep_live<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Pick help<cr>", { desc = "Help" })
map("n", "<leader>fo", "<cmd>Pick oldfiles<cr>", { desc = "Old files" })
map("n", "<leader>fr", "<cmd>Pick resume<cr>", { desc = "Resume picker" })
map("n", "<leader>fd", "<cmd>Pick diagnostic<cr>", { desc = "Diagnostics picker" })
map("n", "<leader>fA", function()
  require("mini.pick").builtin.files({}, { postfilter = function() return true end, list_flags = "-tf --hidden" })
end, { desc = "Find all files (hidden)" })

map("n", "<leader>th", function()
  local bufnr = 0
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end, { desc = "Toggle inlay hints" })
