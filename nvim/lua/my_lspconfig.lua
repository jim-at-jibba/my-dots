require "lsp.handlers"
local utils = require "utils"
local nvim_lsp = require('lspconfig')

local mapper = function(mode, key, result)
  vim.api.nvim_buf_set_keymap(0, mode, key, result, {noremap = true, silent = true})
end

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
vim.g.format_options_json = format_options_prettier
vim.g.format_options_css = format_options_prettier
vim.g.format_options_scss = format_options_prettier
vim.g.format_options_html = format_options_prettier
vim.g.format_options_yaml = format_options_prettier
vim.g.format_options_markdown = format_options_prettier

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

require'neoclip'.setup()

local custom_attach = function(client)
  -- define prettier signs
  vim.fn.sign_define("LspDiagnosticsSignError", {text="", texthl="LspDiagnosticsError"})
  vim.fn.sign_define("LspDiagnosticsSignWarning", {text="", texthl="LspDiagnosticsWarning"})
  vim.fn.sign_define("LspDiagnosticsSignInformation", {text="", texthl="LspDiagnosticsInformation"})
  vim.fn.sign_define("LspDiagnosticsSignHint", {text="", texthl="LspDiagnosticsHint"})

  if client.resolved_capabilities.document_formatting then
      vim.cmd [[augroup Format]]
      vim.cmd [[autocmd! * <buffer>]]
      vim.cmd [[autocmd BufWritePost <buffer> lua formatting()]]
      vim.cmd [[augroup END]]
  end


  mapper('n', '<leader>dd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  mapper('n', '<leader>d', '<cmd>lua vim.lsp.buf.implementation()<CR>')

  -- lsp saga
  mapper('n', '<leader>sh', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>')
  mapper('n', '<leader>rn', '<cmd>lua require("lspsaga.rename").rename()<CR>')
  mapper('n', '<leader>gh', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>')
  mapper('n', '<leader>gp', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>')
  mapper('n', '<leader>dr', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>')
  mapper('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>')
  mapper('n', '<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>')
  mapper('n', '<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>')
  mapper('n', '<leader>dl', '<cmd>lua require("lspsaga.diagnostic").show_line_diagnostics()<CR>')
  mapper('n', '<leader>dn', '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_next()<CR>')
  mapper('n', '<leader>dp', '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()<CR>')

  -- trouble
  mapper('n', '<leader>xx', '<cmd>TroubleToggle<CR>')
  mapper('n', '<leader>xw', '<cmd>Trouble lsp_workspace_diagnostics<CR>')
  mapper('n', '<leader>xd', '<cmd>Trouble lsp_document_diagnostics<CR>')
  -- mapper('n', '<leader>dr', '<cmd>TroubleToggle lsp_references<CR>')

  vim.cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")

end

nvim_lsp.pyright.setup {on_attach = on_attach}

nvim_lsp.tsserver.setup({
  cmd = { "typescript-language-server", "--stdio" },
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    custom_attach(client)
  end
})

nvim_lsp.svelte.setup({
  on_attach = custom_attach,
})


nvim_lsp.gopls.setup({
  on_attach = function(client)
      client.resolved_capabilities.document_formatting = false
      custom_attach(client)
  end
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

require("trouble").setup {
  auto_open = false,
  auto_close = true, 
  auto_preview = true,
  use_lsp_diagnostic_signs = false
}


-- require("twilight").setup {}
require("todo-comments").setup{}

nvim_lsp.tailwindcss.setup({
  cmd={'node','/Users/jamesbest/dotfiles/nvim/tailwind/tailwindcss-intellisense/extension/dist/server/tailwindServer.js','--stdio'},
  on_attach = custom_attach
})

-- require("which-key").setup {
--   plugins = {
--     registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
--     spelling = {
--       enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
--       suggestions = 20, -- how many suggestions should be shown in the list?
--     },
--     presets = {
--       operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
--       motions = true, -- adds help for motions
--       text_objects = true, -- help for text objects triggered after entering an operator
--       windows = true, -- default bindings on <c-w>
--       nav = true, -- misc bindings to work with windows
--       z = true, -- bindings for folds, spelling and others prefixed with z
--       g = true, -- bindings for prefixed with g
--     },
--   },
-- }

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
local golint = require "efm/golint"
local goimports = require "efm/goimports"
local prettier = require "efm/prettier"
local eslint = require "efm/eslint"
local misspell = require "efm/misspell"
local black = require "efm/black"
local isort = require "efm/isort"
local flake8 = require "efm/flake8"
local mypy = require "efm/mypy"

nvim_lsp.efm.setup {
  on_attach = custom_attach,
  init_options = {documentFormatting = true},
  settings = {
        rootMarkers = {".git/"},
        languages = {
            ["="] = {misspell},
            go = {golint, goimports},
            python = {black, isort, flake8, mypy},
            typescript = {prettier, eslint},
            javascript = {prettier, eslint},
            typescriptreact = {prettier, eslint},
            javascriptreact = {prettier, eslint},
            json = {prettier},
            html = {prettier},
            scss = {prettier},
            css = {prettier},
            markdown = {prettier},
        }
    }
}

