vim.pack.add({
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/echasnovski/mini.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
})

require("tokyonight").setup({
  style = "night",
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
})
vim.cmd.colorscheme("tokyonight")

require("gitsigns").setup({
  signs = {
    add          = { text = "▎" },
    change       = { text = "▎" },
    delete       = { text = "▁" },
    topdelete    = { text = "▔" },
    changedelete = { text = "▎" },
    untracked    = { text = "▎" },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function bmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    bmap("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
    bmap("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")
    bmap("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
    bmap("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
    bmap("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
    bmap("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
    bmap("n", "<leader>hd", gs.diffthis, "Diff against index")
    bmap("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
  end,
})

vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
end, { desc = "Update all plugins" })
