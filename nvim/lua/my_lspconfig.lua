require "lsp.handlers"
local utils = require "utils"
local nvim_lsp = require('lspconfig')
-- local completion = require('completion')

local mapper = function(mode, key, result)
  vim.api.nvim_buf_set_keymap(0, mode, key, result, {noremap = true, silent = true})
end


-- vim.g.completion_enable_snippet = 'UltiSnips'
-- vim.g.completion_enable_auto_signature = 1
-- vim.g.completion_enable_auto_paren = 1
-- vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

local format_options_prettier = {
    semi = false,
    singleQuote = false,
    trailingComma = "all",
    bracketSpacing = false,
    configPrecedence = "prefer-file"
}

vim.g.format_options_typescript = format_options_prettier
vim.g.format_options_javascript = format_options_prettier
vim.g.format_options_typescriptreact = format_options_prettier
vim.g.format_options_javascriptreact = format_options_prettier

_G.formatting = function()
    if not vim.g[string.format("format_disabled_%s", vim.bo.filetype)] then
        vim.lsp.buf.formatting(vim.g[string.format("format_options_%s", vim.bo.filetype)] or {})
    end
end

require'compe'.setup {
  enabled = true;

  source = {
    path = true;
    buffer = true;
    ultisnips = true;
    nvim_lsp = true;
    spell = true;
  }
}

local custom_attach = function(client)
  if client.resolved_capabilities.document_formatting then
      vim.cmd [[augroup Format]]
      vim.cmd [[autocmd! * <buffer>]]
      vim.cmd [[autocmd BufWritePost <buffer> lua formatting()]]
      vim.cmd [[augroup END]]
  end

  -- completion.on_attach(client)

  mapper('n', '<leader>dd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  mapper('n', '<leader>d', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  mapper('n', '<leader>vsh', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  mapper('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  mapper('n', '<leader>gh', '<cmd>lua vim.lsp.buf.hover()<CR>')
  mapper('n', '<leader>dr', ":lua require('lists').change_active('Quickfix')<CR>:lua vim.lsp.buf.references()<CR>") 
  -- mapper('n', '<leader>dr', '<cmd>lua vim.lsp.buf.references()<CR>')

  vim.cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")

end

nvim_lsp.tsserver.setup({
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    require "nvim-lsp-ts-utils".setup {}
    custom_attach(client)
  end
})

nvim_lsp.gopls.setup({
  on_attach = custom_attach
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.html.setup({
  on_attach = custom_attach,
  capabilities = capabilities
})


nvim_lsp.jsonls.setup({
  on_attach = custom_attach
})

nvim_lsp.cssls.setup({
  on_attach = custom_attach
})

nvim_lsp.sqlls.setup({
  cmd = {"/usr/local/bin/sql-language-server", "up", "--method", "stdio"},
  on_attach = custom_attach
})

nvim_lsp.yamlls.setup({
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
  root_dir = nvim_lsp.util.root_pattern(".git", vim.fn.getcwd()),
  on_attach = custom_attach
})
-- require('nlua.lsp.nvim').setup(nvim_lsp, {
--   on_attach = custom_attach,
-- })

--[[

nvim_lsp.sumneko_lua.setup({
  on_attach = custom_attach,
  settings = {
        Lua = {
            diagnostics = {
                enable = true,
                globals = {"vim", "love"},
            }
        }
    }

})
--]]

-- https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/lsp.lua
--local golint = require "efm/golint"
--local goimports = require "efm/goimports"
local prettier = require "efm/prettier"
local eslint = require "efm/eslint"

nvim_lsp.efm.setup {
  on_attach = custom_attach,
  init_options = {documentFormatting = true},
  settings = {
        rootMarkers = {".git/"},
        languages = {
            typescript = {prettier, eslint},
            javascript = {prettier, eslint},
            typescriptreact = {prettier, eslint},
            javascriptreact = {prettier, eslint},
            -- json = {prettier},
            -- html = {prettier},
            -- scss = {prettier},
            -- css = {prettier},
            -- markdown = {prettier},
        }
    }
}


-- async formatting
-- https://www.reddit.com/r/neovim/comments/jvisg5/lets_talk_formatting_again/
vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        vim.api.nvim_command("noautocmd :update")
    end
end

-- Diagnostics
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = true,
--     signs = true,
--     update_in_insert = false,
--   }
-- )

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
--     vim.lsp.with(
--         vim.lsp.diagnostic.on_publish_diagnostics,
--         {
--             underline = true,
--             update_in_insert = false
--         }
--     )(...)
--     pcall(vim.lsp.diagnostic.set_loclist, {open_loclist = false})
--   end
