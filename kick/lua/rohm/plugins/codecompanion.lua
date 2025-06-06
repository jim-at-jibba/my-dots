return {
  {
    'olimorris/codecompanion.nvim',
    cmd = {
      'CodeCompanion',
      'CodeCompanionActions',
      'CodeCompanionChat',
      'CodeCompanionCmd',
    },
    keys = {
      { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'AI Toggle [C]hat' },
      { '<leader>an', '<cmd>CodeCompanionChat<cr>', mode = { 'n', 'v' }, desc = 'AI [N]ew Chat' },
      { '<leader>aa', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'AI [A]ction' },
      { 'ga', '<cmd>CodeCompanionChat Add<CR>', mode = { 'v' }, desc = 'AI [A]dd to Chat' },
      -- prompts
      { '<leader>ae', '<cmd>CodeCompanion /explain<cr>', mode = { 'v' }, desc = 'AI [E]xplain' },
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'anthropic',
          roles = { llm = '  Claude Chat', user = 'Besty' },
        },
        inline = {
          adapter = 'anthropic',
        },
        agent = {
          adapter = 'anthropic',
        },
      },
      display = {
        chat = {
          intro_message = '  What can I help with? (Press ? for options)',
          show_references = true,
          show_header_separator = false,
          show_settings = true,
          window = {
            width = 0.4,
            opts = {
              relativenumber = false,
            },
          },
        },
        diff = {
          provider = 'mini_diff',
        },
      },
      adapters = {
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {
            schema = {
              model = {
                default = 'gemini-2.5-pro-preview-05-06', -- 'gemini-1.5-pro-exp-0827'
              },
            },
            env = {
              api_key = 'GEMINI_API_KEY',
            },
          })
        end,
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            schema = {
              model = {
                default = 'claude-3-7-latest',
              },
            },
          })
        end,
      },
    },
    init = function()
      vim.cmd [[cab cc CodeCompanion]]
      require('rohm.plugins.codecompanion.fidget-spinner'):init()

      local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})

      vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = 'CodeCompanionInlineFinished',
        group = group,
        callback = function(request)
          vim.lsp.buf.format { bufnr = request.buf }
        end,
      })
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'echasnovski/mini.diff',
        config = function()
          local diff = require 'mini.diff'
          diff.setup {
            source = diff.gen_source.none(),
          }
        end,
      },
    },
  },
}
