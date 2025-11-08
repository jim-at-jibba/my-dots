return {
  {
    '0x00-ketsu/maximizer.nvim',
    config = true,
    keys = {
      { '<leader>m', ':lua require("maximizer").toggle()<CR>', { noremap = true, silent = true, desc = 'Maximise buffer' } },
    },
  },
}
