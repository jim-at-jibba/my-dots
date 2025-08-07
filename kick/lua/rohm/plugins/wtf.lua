return {
  {
    'piersolenski/wtf.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim', -- Optional: For WtfGrepHistory
    },
    opts = {
      popup_type = 'popup',
      -- The default provider
      provider = 'anthropic',
      -- Configure providers
      providers = {
        anthropic = {
          -- Your preferred model
          model_id = 'claude-sonnet-4-20250514',
        },
      },
      additional_instructions = "Start the reply with 'OH HAI THERE'",
      -- Default search engine, can be overridden by passing an option to WtfSeatch
      search_engine = 'google',
    },
    keys = {
      {
        '<leader>wd',
        mode = { 'n', 'x' },
        function()
          require('wtf').diagnose()
        end,
        desc = 'Debug diagnostic with AI',
      },
      {
        '<leader>wf',
        mode = { 'n', 'x' },
        function()
          require('wtf').fix()
        end,
        desc = 'Fix diagnostic with AI',
      },
      {
        mode = { 'n' },
        '<leader>ws',
        function()
          require('wtf').search()
        end,
        desc = 'Search diagnostic with Google',
      },
      {
        mode = { 'n' },
        '<leader>wp',
        function()
          require('wtf').pick_provider()
        end,
        desc = 'Pick provider',
      },
      {
        mode = { 'n' },
        '<leader>wh',
        function()
          require('wtf').history()
        end,
        desc = 'Populate the quickfix list with previous chat history',
      },
      {
        mode = { 'n' },
        '<leader>wg',
        function()
          require('wtf').grep_history()
        end,
        desc = 'Grep previous chat history with Telescope',
      },
    },
  },
}
