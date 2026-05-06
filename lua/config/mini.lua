require("mini.ai").setup({ n_lines = 500 })
require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.bracketed").setup()

require("mini.files").setup({
  windows = {
    preview = true,
    width_preview = 60,
  },
  options = {
    use_as_default_explorer = true,
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    vim.keymap.set("n", "<CR>", function()
      require("mini.files").go_in({ close_on_file = true })
    end, { buffer = args.data.buf_id, desc = "Open and close" })
  end,
})

require("mini.pick").setup({
  mappings = {
    choose_marked = "<C-q>",
  },
})

require("mini.extra").setup()

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("mini.statusline").setup({ use_icons = true })

require("mini.notify").setup({
  window = { config = { border = "rounded" } },
})
vim.notify = require("mini.notify").make_notify()
