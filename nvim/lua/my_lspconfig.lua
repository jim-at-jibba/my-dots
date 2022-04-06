require "lsp.handlers"
require "lsp.formatting"
local utils = require "utils"
local lspsaga = require 'lspsaga'
local stabilize = require("stabilize")
local nvim_lsp = require('lspconfig')
local notify = require("notify")
local cmp_status_ok, cmp = pcall(require, "cmp")
local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end
-- require("luasnip/loaders/from_vscode").load({paths = {'./mysnippets'}})
-- local snippetspaths = vim.fn.stdpath "config" .. "/lua/mysnippets"
-- print(snippetspaths)
-- require("luasnip.loaders.from_vscode").load {
--   paths = snippetspaths,
-- }
require("luasnip.loaders.from_vscode").lazy_load()
require('luasnip').filetype_extend("javascript", { "html" })
require('luasnip').filetype_extend("typescriptreact", { "html"})

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

--     if not vim.g[string.format("format_disabled_%s", vim.bo.filetype)] then
-- _G.formatting = function()
--         vim.lsp.buf.formatting(vim.g[string.format("format_options_%s", vim.bo.filetype)] or {})
--     end
-- end

local function t(c)
  return vim.api.nvim_replace_termcodes(c, true, true, true)
end

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

-- https://github.com/figsoda/dotfiles/blob/main/lib/nvim/init.lua
cmp.setup({
  confirmation = { default_behavior = cmp.ConfirmBehavior.Replace },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        luasnip = "[Snippet]",
        nvim_lsp = "[LSP]",
        cmp_tabnine = "[TN]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  -- formatting = {
  --   format = function(_, item)
  --     item.kind = lspkind.presets.default[item.kind]
  --     return item
  --   end,
  -- },
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
    { name = "cmp_tabnine" },
  },
})

require'neoclip'.setup()
require("nvim-gps").setup()
require('gitsigns').setup({
  signs = {
    add = { hl = "GitSignsAdd", text = "▍", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = {
      hl = "GitSignsChange",
      text = "▍",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "▸",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "▾",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "▍",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,
    ["n <CR>"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
    ["n <backspace>"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
    ["n <leader>ghs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ["n <leader>ghu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ["n <leader>ghr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ["n <leader>ghR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ["n <leader>ghp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
    ["n <leader>gd"] = '<cmd>lua require"gitsigns".diff_this()<CR>',
    -- Text objects
    ["o ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
    ["x ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
  },
})

require'nvim-tree'.setup({
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  view = {
    side = 'right',
    width = 40
  },
  git = {
    ignore = true
  }
})

stabilize.setup()
lspsaga.setup()
require('spectre').setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local custom_attach = function(client)
  -- define prettier signs
  vim.fn.sign_define("LspDiagnosticsSignError", {text="", texthl="LspDiagnosticsError"})
  vim.fn.sign_define("LspDiagnosticsSignWarning", {text="", texthl="LspDiagnosticsWarning"})
  vim.fn.sign_define("LspDiagnosticsSignInformation", {text="", texthl="LspDiagnosticsInformation"})
  vim.fn.sign_define("LspDiagnosticsSignHint", {text="", texthl="LspDiagnosticsHint"})

  if client.resolved_capabilities.document_formatting then
      vim.cmd [[augroup Format]]
      vim.cmd [[autocmd! * <buffer>]]
      vim.cmd [[autocmd BufWritePost <buffer> lua require'lsp.formatting'.format()]]
      vim.cmd [[augroup END]]
  end


  mapper('n', '<leader>dd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  mapper('n', '<leader>d', '<cmd>lua vim.lsp.buf.implementation()<CR>')

  -- lsp saga
  mapper('n', '<leader>rn', '<cmd>Lspsaga rename<cr>')
  mapper('n', '<leader>gh', '<cmd>Lspsaga hover_doc<cr>')
  mapper('n', '<leader>ca', '<cmd>Lspsaga code_action<cr>')
  mapper('n', '<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>')
  mapper('n', '<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<cr>')
  mapper('n', '<leader>dl', '<cmd>Lspsaga show_line_diagnostics<cr>')
  mapper('n', '<leader>dn', '<cmd>Lspsaga diagnostic_jump_next<cr>')
  mapper('n', '<leader>dp', '<cmd>Lspsaga diagnostic_jump_prev<cr>')

  -- trouble
  mapper('n', '<leader>xx', '<cmd>TroubleToggle<CR>')
  mapper('n', '<leader>xw', '<cmd>Trouble lsp_workspace_diagnostics<CR>')
  mapper('n', '<leader>xd', '<cmd>Trouble lsp_document_diagnostics<CR>')
  mapper('n', '<leader>dr', '<cmd>TroubleToggle lsp_references<CR>')

  vim.cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")

end

nvim_lsp.pyright.setup({
  capabilities = capabilities,
  on_attach = function(client)
    custom_attach(client)
  end
})

nvim_lsp.prismals.setup{}


nvim_lsp.tsserver.setup({
  capabilities = capabilities,
  cmd = { "typescript-language-server", "--stdio" },
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    require("nvim-lsp-ts-utils").setup {}
    custom_attach(client)
  end
})

nvim_lsp.svelte.setup({
  capabilities = capabilities,
  on_attach = custom_attach,
})


nvim_lsp.gopls.setup({
  cmd = {'gopls'},
	-- for postfix snippets and analyzers
	capabilities = capabilities,
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
     },
     staticcheck = true,
    },
  },
  on_attach = function(client)
      client.resolved_capabilities.document_formatting = false
      custom_attach(client)
  end
})


nvim_lsp.html.setup({
  on_attach = custom_attach,
  capabilities = capabilities
})


-- nvim_lsp.jsonls.setup({
--   on_attach = custom_attach
-- })

nvim_lsp.solang.setup({
  capabilities = capabilities,
  on_attach = custom_attach
})

nvim_lsp.cssls.setup({
  capabilities = capabilities,
  on_attach = custom_attach
})

nvim_lsp.sqlls.setup({
  capabilities = capabilities,
  cmd = {"/usr/local/bin/sql-language-server", "up", "--method", "stdio"},
  on_attach = custom_attach
})

nvim_lsp.yamlls.setup({
  capabilities = capabilities,
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
  root_dir = nvim_lsp.util.root_pattern(".git", vim.fn.getcwd()),
  on_attach = custom_attach
})


-- nvim_lsp.sumneko_lua.setup({
--   on_attach = custom_attach,
--   settings = {
--     Lua = {
--       diagnostics = {
--         enable = true,
--         globals = {"vim", "love"},
--       }
--     }
--   }
--
-- })

require("trouble").setup {
  auto_open = false,
  auto_close = true,
  auto_preview = true,
  use_lsp_diagnostic_signs = false
}


-- require("twilight").setup {}
require("todo-comments").setup{}
require("neoscroll").setup{}
require('Comment').setup()

notify.setup({ stages = "static" })
vim.notify = notify
require("which-key").setup {
  plugins = {
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  window = {
    border = "single", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
  },
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
}
--
-- -- nvim_lsp.tailwindcss.setup({
-- --   cmd={'node','/Users/jamesbest/dotfiles/nvim/tailwind/tailwindcss-intellisense/extension/dist/server/tailwindServer.js','--stdio'},
-- --   on_attach = custom_attach
-- -- })

-- -- require('nlua.lsp.nvim').setup(nvim_lsp, {
-- --   on_attach = custom_attach,
-- -- })
--
-- --[[
--
-- --]]
--
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
            python = {black, isort, flake8, mypy}, -- remove the global installs of these and install them per-project
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

