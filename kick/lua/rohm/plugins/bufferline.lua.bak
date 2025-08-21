-- Pretty bufferline.
return {
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        numbers = 'ordinal',
        show_close_icon = false,
        show_buffer_close_icons = false,
        truncate_names = false,
        indicator = { style = 'underline' },
        close_command = function(bufnr)
          require('mini.bufremove').delete(bufnr, false)
        end,
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(_, _, diag)
          local icons = require('icons').diagnostics
          local indicator = (diag.error and icons.ERROR .. ' ' or '') .. (diag.warning and icons.WARN or '')
          return vim.trim(indicator)
        end,
      },
    },
    keys = {
      -- Buffer navigation.
      { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Pick a buffer to open' },
      { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = 'Select a buffer to close' },
      { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', desc = 'Close buffers to the left' },
      { '<leader>br', '<cmd>BufferLineCloseRight<cr>', desc = 'Close buffers to the right' },
      { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = 'Close other buffers' },
      -- Buffer selection by number.
      { '<leader>1', '<cmd>BufferLineGoToBuffer 1<cr>', desc = 'Go to buffer 1' },
      { '<leader>2', '<cmd>BufferLineGoToBuffer 2<cr>', desc = 'Go to buffer 2' },
      { '<leader>3', '<cmd>BufferLineGoToBuffer 3<cr>', desc = 'Go to buffer 3' },
      { '<leader>4', '<cmd>BufferLineGoToBuffer 4<cr>', desc = 'Go to buffer 4' },
      { '<leader>5', '<cmd>BufferLineGoToBuffer 5<cr>', desc = 'Go to buffer 5' },
      { '<leader>6', '<cmd>BufferLineGoToBuffer 6<cr>', desc = 'Go to buffer 6' },
      { '<leader>7', '<cmd>BufferLineGoToBuffer 7<cr>', desc = 'Go to buffer 7' },
      { '<leader>8', '<cmd>BufferLineGoToBuffer 8<cr>', desc = 'Go to buffer 8' },
      { '<leader>9', '<cmd>BufferLineGoToBuffer 9<cr>', desc = 'Go to buffer 9' },
    },
  },
}
