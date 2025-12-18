return {
  'Cpoing/microscope.nvim',
  cmd = 'MicroscopePeek',
  keys = {
    { '<leader>mp', ':MicroscopePeek<CR>', desc = 'Peek definition' },
  },
  config = function()
    require 'microscope'
  end,
}
