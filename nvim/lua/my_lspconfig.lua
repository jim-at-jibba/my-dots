local nvim_lsp = require('lspconfig')
local completion = require('completion')


 local mapper = function(mode, key, result)
   vim.api.nvim_buf_set_keymap(0, mode, key, result, {noremap = true, silent = true})
 end


vim.g.completion_enable_snippet = 'UltiSnips'
vim.g.completion_enable_auto_signature = 1
vim.g.completion_enable_auto_paren = 1
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

local custom_attach = function(client)
  --if client.resolved_capabilities.document_formatting then
  --    vim.api.nvim_command [[augroup Format]]
  --    vim.api.nvim_command [[autocmd! * <buffer>]]
  --    vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
  --    vim.api.nvim_command [[augroup END]]
  --end

  completion.on_attach(client)

  mapper('n', '<leader>dd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  mapper('n', '<leader>d', '<cmd>lua vim.lsp.buf.implementation()<CR>')
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

nvim_lsp.html.setup({
  on_attach = custom_attach
})


nvim_lsp.jsonls.setup({
  on_attach = custom_attach
})

nvim_lsp.sqlls.setup({
  on_attach = custom_attach
})

-- nvim_lsp.efm.setup {on_attach = on_attach}

require('nlua.lsp.nvim').setup(nvim_lsp, {
  on_attach = custom_attach,
})

-- async formatting
-- https://www.reddit.com/r/neovim/comments/jvisg5/lets_talk_formatting_again/
--vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
--    if err ~= nil or result == nil then
--        return
--    end
--    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
--        local view = vim.fn.winsaveview()
--        vim.lsp.util.apply_text_edits(result, bufnr)
--        vim.fn.winrestview(view)
--        vim.api.nvim_command("noautocmd :update")
--    end
--end

-- Diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)
