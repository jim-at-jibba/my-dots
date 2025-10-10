return {
  {
    -- dir = '~/code/other/termogotchi-nvim',
  },
  {
    dir = '~/code/other/nvim-redraft/',
    config = function()
      require('nvim-redraft').setup {
        llm = {
          provider = 'xai', -- "openai" or "anthropic"
          -- model = 'claude-3-7-sonnet-latest', -- Model name (optional, uses provider default if omitted)
          timeout = 30000,
        },
        debug = true,
        -- Optional configuration
        keybindings = {
          visual_edit = '<leader>ae',
        },
      }
    end,
    build = 'cd ts && npm install && npm run build',
  },
}
