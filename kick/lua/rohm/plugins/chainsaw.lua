return {
  {
    'Goose97/timber.nvim',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('timber').setup {
        log_templates = {
          watcher = {
            javascript = [[console.log('%watcher_marker_start', %log_target, '%watcher_marker_end')]],
            typescript = [[console.log('%watcher_marker_start', %log_target, '%watcher_marker_end')]],
            jsx = [[console.log('%watcher_marker_start', %log_target, '%watcher_marker_end')]],
            tsx = [[console.log('%watcher_marker_start', %log_target, '%watcher_marker_end')]],
          },
          default = {
            javascript = [[console.log("%log_marker %log_target:  %line_number", %log_target)]],
            typescript = [[console.log("%log_marker %log_target:  %line_number", %log_target)]],
            jsx = [[console.log("%log_marker %log_target:  %line_number", %log_target)]],
            tsx = [[console.log("%log_marker %log_target:  %line_number", %log_target)]],
            python = [[print("%log_marker %log_target:  %line_number", %log_target)]],
          },
          plain = {},
        },
        log_watcher = {
          enabled = true,
          sources = {
            ts = {
              type = 'filesystem',
              name = 'Log file',
              path = '/tmp/metro.log',
            },
          },
          preview_snippet_length = 32,
        },
        batch_log_templates = {
          default = {
            javascript = [[console.log("%log_marker %line_number", { %repeat<"%log_target": %log_target><, > })]],
            typescript = [[console.log("%log_marker %line_number", { %repeat<"%log_target": %log_target><, > })]],
            jsx = [[console.log("%log_marker %line_number", { %repeat<"%log_target": %log_target><, > })]],
            tsx = [[console.log("%log_marker %line_number", { %repeat<"%log_target": %log_target><, > })]],
            python = [[print("%log_marker %line_number", %repeat<"%log_target", %log_target><, >)]],
          },
        },
      }
    end,
    keys = {
      {
        '<leader>ld',
        "<cmd>lua require('timber.actions').clear_log_statements({ global = false })<CR>",
        { desc = 'Timber: Clear log statements' },
      },
      {
        '<leader>ll',
        "<cmd>lua require('timber.actions').insert_log({ position = 'below', operator = true })<CR>",
        { desc = 'Timber: Log statements' },
      },
      {
        'glf',
        "<cmd>lua require('timber.buffers').open_float()<CR>",
        { desc = 'Timber: Open log float' },
      },
      {
        'glf',
        "<cmd>lua require('timber.actions').insert_log({ template = 'watcher', position = 'below' })<CR>",
        { desc = 'Timber: Log watcher below' },
      },
    },
  },
  -- {
  --   'chrisgrieser/nvim-chainsaw',
  --   event = 'VeryLazy',
  --   config = function()
  --     require('chainsaw').setup {
  --       marker = '🪚',
  --       logStatements = {
  --         objectLog = {
  --           javascript = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", JSON.stringify({{var}}, null, 2));',
  --           typescript = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", JSON.stringify({{var}}, null, 2));',
  --           typescriptreact = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", JSON.stringify({{var}}, null, 2));',
  --         },
  --         variableLog = {
  --           javascript = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", {{{var}}});',
  --           typescript = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", {{{var}}});',
  --           typescriptreact = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", {{{var}}});',
  --         },
  --       },
  --       logTypes = {
  --         emojiLog = {
  --           emojis = { '🔵 1:', '🟩 2:', '⭐ 3:', '⭕ 4:', '💜 5:', '🔲 6:' },
  --         },
  --       },
  --     }
  --   end,
  --   keys = {
  --     { '<leader>l', "<cmd>lua require('chainsaw').variableLog()<CR>", { desc = 'Chainsaw variable log' } },
  --     { '<leader>lo', "<cmd>lua require('chainsaw').objectLog()<CR>", { desc = 'Chainsaw object log' } },
  --     { '<leader>lm', "<cmd>lua require('chainsaw').messageLog()<CR>", { desc = 'Chainsaw message log' } },
  --     { '<leader>lb', "<cmd>lua require('chainsaw').emojiLog()<CR>", { desc = 'Chainsaw beep log' } },
  --     { '<leader>lt', "<cmd>lua require('chainsaw').timeLog()<CR>", { desc = 'Chainsaw time log' } },
  --     { '<leader>ld', "<cmd>lua require('chainsaw').removeLogs()<CR>", { desc = 'Chainsaw remove logs' } },
  --   },
  -- },
}
