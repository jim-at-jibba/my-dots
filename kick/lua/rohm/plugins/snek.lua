return {
  {
    '4tyone/snek-nvim',
    config = function()
      require('snek-nvim').setup {
        api_key = vim.env.SNEK_API_KEY,
        model = 'qwen-3-235b-a22b-instruct-2507', -- Optional, this is the default
      }
    end,
  },
}
