return {
  'koushikxd/resu.nvim',
  dependencies = {
    'sindrets/diffview.nvim',
  },
  config = function()
    require('resu').setup()
  end,
}
