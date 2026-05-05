local conform = require("conform")

vim.g.disable_autoformat = false

conform.setup({
  notify_on_error = true,
  formatters_by_ft = {
    lua             = { "stylua" },
    python          = { "ruff_organize_imports", "ruff_format" },
    javascript      = { "biome", "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
    typescript      = { "biome", "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
    rust            = { "rustfmt", lsp_format = "fallback" },
    json            = { "biome", "prettierd", "prettier", stop_after_first = true },
    jsonc           = { "biome", "prettierd", "prettier", stop_after_first = true },
    yaml            = { "prettierd", "prettier", stop_after_first = true },
    markdown        = { "prettierd", "prettier", stop_after_first = true },
    toml            = { "taplo" },
    sh              = { "shfmt" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
})

vim.api.nvim_create_user_command("FormatToggle", function(args)
  if args.bang then
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    vim.notify("Format-on-save: " .. (vim.b.disable_autoformat and "OFF (buffer)" or "ON (buffer)"))
  else
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify("Format-on-save: " .. (vim.g.disable_autoformat and "OFF (global)" or "ON (global)"))
  end
end, { bang = true, desc = "Toggle format-on-save (use ! for buffer-local)" })

vim.keymap.set("n", "<leader>uf", "<cmd>FormatToggle<cr>", { desc = "Toggle format-on-save (global)" })
vim.keymap.set("n", "<leader>uF", "<cmd>FormatToggle!<cr>", { desc = "Toggle format-on-save (buffer)" })
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer/range" })
