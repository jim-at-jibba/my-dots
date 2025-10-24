local diagnostic_icons = require('icons').diagnostics

return {
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local mason_lspconfig = require 'mason-lspconfig'

      for severity, icon in pairs(diagnostic_icons) do
        local hl = 'DiagnosticSign' .. severity:sub(1, 1) .. severity:sub(2):lower()
        vim.fn.sign_define(hl, { text = icon, texthl = hl })
      end

      vim.diagnostic.config {
        virtual_text = false,
        float = {
          source = 'if_many',
          prefix = function(diag)
            local level = vim.diagnostic.severity[diag.severity]
            local prefix = string.format(' %s ', diagnostic_icons[level])
            return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities(nil, true)

      local servers = {
        lua_ls = {},
        basedpyright = {},
        vtsls = {},
        rust_analyzer = {},
        jdtls = {},
      }

      for server_name, config in pairs(servers) do
        vim.lsp.config[server_name] = vim.tbl_deep_extend('force', {
          capabilities = capabilities,
        }, config)
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if not client then
            return
          end

          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', function()
            require('tiny-code-action').code_action()
          end, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', '<cmd>FzfLua lsp_references<cr>', 'vim.lsp.buf.references()')
          map('grt', '<cmd>FzfLua lsp_typedefs<cr>', 'Go to type definition')
          map('<leader>gs', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document symbols')
          map('gh', vim.lsp.buf.hover, '[H]over')

          if client then
            require('lightbulb').attach_lightbulb(bufnr, client.id)
          end

          if client:supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
            map('grd', function()
              require('fzf-lua').lsp_definitions { jump1 = true }
            end, 'Go to definition')
            map('grD', function()
              require('fzf-lua').lsp_definitions { jump1 = false }
            end, 'Peek definition')
          end

          if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = bufnr,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = bufnr,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
            end, '[T]oggle Inlay [H]ints')
          end

          vim.api.nvim_create_autocmd('CursorHold', {
            buffer = bufnr,
            callback = function()
              local opts = {
                focusable = false,
                close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
                border = 'rounded',
                source = 'always',
                prefix = ' ',
              }
              vim.diagnostic.open_float(nil, opts)
            end,
          })

          if client:supports_method(vim.lsp.protocol.Methods.textDocument_signatureHelp) then
            map('<C-k>', function()
              if require('blink.cmp.completion.windows.menu').win:is_open() then
                require('blink.cmp').hide()
              end

              vim.lsp.buf.signature_help()
            end, 'Signature help', 'i')
          end
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-enable', { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local ft = vim.bo[bufnr].filetype

          for server_name, _ in pairs(servers) do
            vim.lsp.enable(server_name)
          end
        end,
      })

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_enable = {
          exclude = {
            'jdtls',
          },
        },
      }
    end,
  },
  { 'mfussenegger/nvim-jdtls' },
}
