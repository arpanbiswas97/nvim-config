vim.diagnostic.config({
  severity_sort = true,
  underline = { severity = vim.diagnostic.severity.ERROR },
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    prefix = "●",
    severity = { min = vim.diagnostic.severity.HINT },
  },
  float = { border = "rounded", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    },
  },
})

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
if lsp_capabilities.workspace then
  lsp_capabilities.workspace.didChangeWatchedFiles = nil
end

vim.lsp.config("*", {
  capabilities = lsp_capabilities,
})

vim.lsp.enable({ "basedpyright", "ruff", "vtsls", "rust_analyzer" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    local function bmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    bmap("n", "gd", vim.lsp.buf.definition, "Definition")
    bmap("n", "gD", vim.lsp.buf.declaration, "Declaration")
    bmap("n", "gr", vim.lsp.buf.references, "References")
    bmap("n", "gi", vim.lsp.buf.implementation, "Implementation")
    bmap("n", "gy", vim.lsp.buf.type_definition, "Type definition")
    bmap("n", "K", vim.lsp.buf.hover, "Hover")
    bmap("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help")
    bmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    bmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    bmap("n", "<leader>cl", vim.lsp.codelens.run, "Run codelens")
  end,
})
