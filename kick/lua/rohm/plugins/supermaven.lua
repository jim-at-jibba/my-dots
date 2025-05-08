return {
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {
        keymaps = {
          accept_suggestion = '<C-e>',
          clear_suggestion = '<C-]>',
          accept_word = '<C-j>',
        },
      }
    end,
  },
}
