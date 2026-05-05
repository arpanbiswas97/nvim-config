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
