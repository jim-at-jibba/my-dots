local diagnostic_icons = require('icons').diagnostics
local methods = vim.lsp.protocol.Methods

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  ---@param lhs string
  ---@param rhs string|function
  ---@param desc string
  ---@param mode? string|string[]
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map('gra', function()
    require('tiny-code-action').code_action()
  end, '[G]oto Code [A]ction', { 'n', 'x' })

  map('grr', '<cmd>FzfLua lsp_references<cr>', 'vim.lsp.buf.references()')

  map('grt', '<cmd>FzfLua lsp_typedefs<cr>', 'Go to type definition')

  map('<leader>gs', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document symbols')

  map('gh', vim.lsp.buf.hover, '[H]over')

  -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
  ---@param client vim.lsp.Client
  ---@param method vim.lsp.protocol.Method
  ---@param bufnr? integer some lsp support methods only in specific files
  ---@return boolean
  local function client_supports_method(client, method, bufnr2)
    if vim.fn.has 'nvim-0.11' == 1 then
      return client:supports_method(method, bufnr)
    else
      return client.supports_method(method, { bufnr = bufnr2 })
    end
  end

  if client then
    require('lightbulb').attach_lightbulb(bufnr, client.id)
  end

  if client:supports_method(methods.textDocument_definition) then
    map('grd', function()
      require('fzf-lua').lsp_definitions { jump1 = true }
    end, 'Go to definition')
    map('grD', function()
      require('fzf-lua').lsp_definitions { jump1 = false }
    end, 'Peek definition')
  end

  if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
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

  if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
    map('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
    end, '[T]oggle Inlay [H]ints')
  end

  -- Show diagnostics on hover
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

  if client:supports_method(methods.textDocument_signatureHelp) then
    map('<C-k>', function()
      -- Close the completion menu first (if open).
      if require('blink.cmp.completion.windows.menu').win:is_open() then
        require('blink.cmp').hide()
      end

      vim.lsp.buf.signature_help()
    end, 'Signature help', 'i')
  end
end

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
      local lspconfig = require 'lspconfig'
      local mason = require 'mason'
      local mason_lspconfig = require 'mason-lspconfig'

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          -- I don't think this can happen but it's a wild world out there.
          if not client then
            return
          end

          on_attach(client, args.buf)
        end,
      })

      for severity, icon in pairs(diagnostic_icons) do
        local hl = 'DiagnosticSign' .. severity:sub(1, 1) .. severity:sub(2):lower()
        vim.fn.sign_define(hl, { text = icon, texthl = hl })
      end

      -- Diagnostic configuration.
      vim.diagnostic.config {
        virtual_text = false,
        -- virtual_text = {
        --   prefix = '',
        --   spacing = 2,
        --   format = function(diagnostic)
        --     -- Use shorter, nicer names for some sources:
        --     local special_sources = {
        --       ['Lua Diagnostics.'] = 'lua',
        --       ['Lua Syntax Check.'] = 'lua',
        --     }
        --
        --     local message = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
        --     if diagnostic.source then
        --       message = string.format('%s %s', message, special_sources[diagnostic.source] or diagnostic.source)
        --     end
        --     if diagnostic.code then
        --       message = string.format('%s[%s]', message, diagnostic.code)
        --     end
        --
        --     return message .. ' '
        --   end,
        -- },
        float = {
          source = 'if_many',
          -- Show severity icons as prefixes.
          prefix = function(diag)
            local level = vim.diagnostic.severity[diag.severity]
            local prefix = string.format(' %s ', diagnostic_icons[level])
            return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
          end,
        },
      }

      -- -- Diagnostic Config
      -- -- See :help vim.diagnostic.Opts
      -- vim.diagnostic.config {
      --   severity_sort = true,
      --   underline = { severity = vim.diagnostic.severity.ERROR },
      --   signs = vim.g.have_nerd_font and {
      --     text = {
      --       [vim.diagnostic.severity.ERROR] = '󰅚 ',
      --       [vim.diagnostic.severity.WARN] = '󰀪 ',
      --       [vim.diagnostic.severity.INFO] = '󰋽 ',
      --       [vim.diagnostic.severity.HINT] = '󰌶 ',
      --     },
      --   } or {},
      --   virtual_text = false,
      --   -- virtual_text = {
      --   --   prefix = '',
      --   --   spacing = 2,
      --   --   format = function(diagnostic)
      --   --     -- Use shorter, nicer names for some sources:
      --   --     local special_sources = {
      --   --       ['Lua Diagnostics.'] = 'lua',
      --   --       ['Lua Syntax Check.'] = 'lua',
      --   --     }
      --   --
      --   --     local message = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
      --   --     if diagnostic.source then
      --   --       message = string.format('%s %s', message, special_sources[diagnostic.source] or diagnostic.source)
      --   --     end
      --   --     if diagnostic.code then
      --   --       message = string.format('%s[%s]', message, diagnostic.code)
      --   --     end
      --   --
      --   --     return message .. ' '
      --   --   end,
      --   -- },
      --   float = {
      --     source = 'if_many',
      --     -- Show severity icons as prefixes.
      --     prefix = function(diag)
      --       local level = vim.diagnostic.severity[diag.severity]
      --       local prefix = string.format(' %s ', diagnostic_icons[level])
      --       return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
      --     end,
      --   },
      -- }

      -- Setup LSP completion capabilities
      local capabilities = require('blink.cmp').get_lsp_capabilities(nil, true)

      mason_lspconfig.setup {
        ensure_installed = {
          'lua_ls', -- Lua
          'ts_ls', -- TypeScript/JavaScript
          'rust_analyzer', -- Rust
        },
        handlers = {
          -- The first entry (default) will be used to automatically set up servers
          function(server_name)
            lspconfig[server_name].setup {
              capabilities = capabilities,
            }
          end,
        },
      }
    end,
  },
}
