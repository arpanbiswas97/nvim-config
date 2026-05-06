local parsers = {
  "python",
  "typescript",
  "tsx",
  "javascript",
  "rust",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
  "json",
  "yaml",
  "toml",
  "bash",
}

pcall(function()
  require("nvim-treesitter.configs").setup({
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "v",
        node_incremental = "v",
        scope_incremental = false,
        node_decremental = "V",
      },
    },
  })
  require("nvim-treesitter").install(parsers)
end)

vim.opt.foldmethod = "expr"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)
    if not ok then
      return
    end
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    pcall(function()
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end)
  end,
})

vim.api.nvim_create_user_command("TSUpdate", function()
  require("nvim-treesitter").update()
end, { desc = "Update treesitter parsers" })
