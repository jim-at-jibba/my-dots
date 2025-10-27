return {
  'akinsho/git-conflict.nvim',
  event = 'LazyFile',
  keys = {
    { '<leader>gm', ':GitConflictListQf<CR>', { noremap = true, silent = true, desc = 'List git conflicts' } },
  },
  opts = {
    disable_diagnostics = true,
    default_mappings = {
      ours = 'o',
      theirs = 't',
      none = '0',
      both = 'b',
      next = 'n',
      prev = 'p',
    },
  },
  config = function(_, opts)
    require('git-conflict').setup(opts)
  end,
}
