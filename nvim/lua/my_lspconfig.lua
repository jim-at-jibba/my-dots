local nvim_lsp = require('lspconfig')
local completion = require('completion')


 local mapper = function(mode, key, result)
   vim.api.nvim_buf_set_keymap(0, mode, key, result, {noremap = true, silent = true})
 end

local custom_attach = function(client)
  completion.on_attach(client)

  mapper('n', '<leader>dd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  mapper('n', '<leader>d', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  mapper('n', '<leader>dd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  mapper('n', '<leader>vsh', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  mapper('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  mapper('n', '<leader>gh', '<cmd>lua vim.lsp.buf.hover()<CR>')

  vim.cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")
end

nvim_lsp.tsserver.setup({
  cmd = {"typescript-language-server", "--stdio"},
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx"
  },
  on_attach = custom_attach,
})

nvim_lsp.gopls.setup({
  on_attach = custom_attach
})

require('nlua.lsp.nvim').setup(nvim_lsp, {
  on_attach = custom_attach,
})

-- Diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)
