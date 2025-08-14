return {
  {
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
      keys = {
        {
          ']h',
          ":lua require'gitsigns'.next_hunk()<CR>",
          desc = 'Next Hunk',
        },
        {
          '[h',
          ":lua require'gitsigns'.prev_hunk()<CR>",
          desc = 'Prev Hunk',
        },
      },
    },
    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    -- Oil
    {
      'stevearc/oil.nvim',
      opts = {},
      -- Optional dependencies
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      keys = {
        { '-', '<cmd>Oil<CR>', desc = 'Open oil' },
      },
    },
    {
      'folke/snacks.nvim',
      priority = 1000,
      lazy = false,
      opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        explorer = { enabled = false },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = false },
        notifier = { enabled = true },
        quickfile = { enabled = false },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
      },
      keys = {
        {
          '<leader>z',
          function()
            Snacks.zen()
          end,
          desc = 'Toggle [Z]en Mode',
        },
        {
          '<leader>.',
          function()
            Snacks.scratch()
          end,
          desc = 'Toggle Scratch Buffer',
        },
        {
          '<leader>S',
          function()
            Snacks.scratch.select()
          end,
          desc = 'Select [S]cratch Buffer',
        },
        {
          '<leader>n',
          function()
            Snacks.notifier.show_history()
          end,
          desc = '[N]otification History',
        },
        {
          '<leader>bd',
          function()
            Snacks.bufdelete()
          end,
          desc = '[B]uffer [D]elete',
        },
        {
          '<leader>gb',
          function()
            Snacks.git.blame_line()
          end,
          desc = 'Git Blame Line',
        },
        {
          '<leader>gg',
          function()
            Snacks.lazygit()
          end,
          desc = 'Lazygit',
        },
        {
          '<leader>un',
          function()
            Snacks.notifier.hide()
          end,
          desc = 'Dismiss All [N]otifications',
        },
      },
    },
  },
}
