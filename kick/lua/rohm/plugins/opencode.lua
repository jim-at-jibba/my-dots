return {
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      -- Recommended for better prompt input, and required to use opencode.nvim's embedded terminal. Otherwise optional.
      { 'folke/snacks.nvim', opts = { input = { enabled = true } } },
    },
    ---@type opencode.Opts
    opts = {
      auto_reload = true,
      -- port = 6969,
      -- auto_register_cmp_sources = {},
      -- auto_fallback_to_embedded = false,
      -- on_send = function() end,
      -- on_opencode_not_found = function() end,
      prompts = {
        git_commit = {
          description = 'Commit changes to Git',
          prompt = 'Please enter a commit message.',
        },
      },
      terminal = {
        -- Override my snacks.nvim terminal config. No reason to prefer normal mode for opencode - can't scroll its TUI like a normal terminal buffer.
        auto_insert = true,
        -- win = {
        --   position = 'left',
        -- },
      },
    },
    keys = {
      -- Recommended keymaps
      {
        '<leader>oA',
        function()
          require('opencode').ask()
        end,
        desc = 'Ask opencode',
      },
      {
        '<leader>oa',
        function()
          require('opencode').ask '@cursor: '
        end,
        desc = 'Ask opencode about this',
        mode = 'n',
      },
      {
        '<leader>oa',
        function()
          require('opencode').ask '@selection: '
        end,
        desc = 'Ask opencode about selection',
        mode = 'v',
      },
      {
        '<leader>ot',
        function()
          require('opencode').toggle()
        end,
        desc = 'Toggle embedded opencode',
      },
      {
        '<leader>on',
        function()
          require('opencode').command 'session_new'
        end,
        desc = 'New session',
      },
      {
        '<leader>oy',
        function()
          require('opencode').command 'messages_copy'
        end,
        desc = 'Copy last message',
      },
      {
        '<S-C-u>',
        function()
          require('opencode').command 'messages_half_page_up'
        end,
        desc = 'Scroll messages up',
      },
      {
        '<S-C-d>',
        function()
          require('opencode').command 'messages_half_page_down'
        end,
        desc = 'Scroll messages down',
      },
      {
        '<leader>op',
        function()
          require('opencode').select_prompt()
        end,
        desc = 'Select prompt',
        mode = { 'n', 'v' },
      },
      -- Example: keymap for custom prompt
      {
        '<leader>oe',
        function()
          require('opencode').prompt 'Explain @cursor and its context'
        end,
        desc = 'Explain code near cursor',
      },
    },
  },
}
