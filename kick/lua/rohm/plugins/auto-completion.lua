return {
  {
    'hrsh7th/nvim-cmp',
    version = false,
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    opts = function()
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
      local cmp = require 'cmp'
      local defaults = require 'cmp.config.default'()
      return {
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-u>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<S-CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<C-CR>'] = function(fallback)
            cmp.abort()
            fallback()
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
        experimental = {
          ghost_text = {
            hl_group = 'CmpGhostText',
          },
        },
        sorting = defaults.sorting,
      }
    end,
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      require('cmp').setup(opts)
    end,
  },
}

-- return {
--   { -- Autocompletion
--     'saghen/blink.cmp',
--     event = 'InsertEnter',
--     version = '1.*',
--     dependencies = {
--       -- Snippet Engine
--       {
--         'L3MON4D3/LuaSnip',
--         version = '2.*',
--         event = 'InsertEnter',
--         build = (function()
--           -- Build Step is needed for regex support in snippets.
--           -- This step is not supported in many windows environments.
--           -- Remove the below condition to re-enable on windows.
--           if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
--             return
--           end
--           return 'make install_jsregexp'
--         end)(),
--         dependencies = {
--           -- `friendly-snippets` contains a variety of premade snippets.
--           --    See the README about individual language/framework/plugin snippets:
--           --    https://github.com/rafamadriz/friendly-snippets
--           {
--             'rafamadriz/friendly-snippets',
--             event = 'InsertEnter',
--             config = function()
--               require('luasnip.loaders.from_vscode').lazy_load()
--             end,
--           },
--         },
--         opts = {},
--       },
--       'folke/lazydev.nvim',
--       'Kaiser-Yang/blink-cmp-avante',
--     },
--     --- @module 'blink.cmp'
--     --- @type blink.cmp.Config
--     opts = {
--       keymap = {
--         -- 'default' (recommended) for mappings similar to built-in completions
--         --   <c-y> to accept ([y]es) the completion.
--         --    This will auto-import if your LSP supports it.
--         --    This will expand snippets if the LSP sent a snippet.
--         -- 'super-tab' for tab to accept
--         -- 'enter' for enter to accept
--         -- 'none' for no mappings
--         --
--         -- For an understanding of why the 'default' preset is recommended,
--         -- you will need to read `:help ins-completion`
--         --
--         -- No, but seriously. Please read `:help ins-completion`, it is really good!
--         --
--         -- All presets have the following mappings:
--         -- <tab>/<s-tab>: move to right/left of your snippet expansion
--         -- <c-space>: Open menu or open docs if already open
--         -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
--         -- <c-e>: Hide menu
--         -- <c-k>: Toggle signature help
--         --
--         -- See :h blink-cmp-config-keymap for defining your own keymap
--         preset = 'default',
--
--         -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
--         --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
--       },
--
--       appearance = {
--         -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
--         -- Adjusts spacing to ensure icons are aligned
--         nerd_font_variant = 'mono',
--       },
--
--       completion = {
--         -- By default, you may press `<c-space>` to show the documentation.
--         -- Optionally, set `auto_show = true` to show the documentation after a delay.
--         documentation = { auto_show = false, auto_show_delay_ms = 500 },
--       },
--
--       sources = {
--         default = { 'lsp', 'path', 'snippets', 'lazydev', 'avante' },
--         providers = {
--           lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
--           avante = {
--             module = 'blink-cmp-avante',
--             name = 'Avante',
--             opts = {
--               -- options for blink-cmp-avante
--             },
--           },
--         },
--       },
--
--       snippets = { preset = 'luasnip' },
--
--       -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
--       -- which automatically downloads a prebuilt binary when enabled.
--       --
--       -- By default, we use the Lua implementation instead, but you may enable
--       -- the rust implementation via `'prefer_rust_with_warning'`
--       --
--       -- See :h blink-cmp-config-fuzzy for more information
--       fuzzy = { implementation = 'lua' },
--
--       -- Shows a signature help window while you type arguments for a function
--       signature = { enabled = true },
--     },
--   },
-- }
