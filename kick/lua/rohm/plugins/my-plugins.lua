return {
  {
    -- dir = '~/code/other/termogotchi-nvim',
  },
  {
    dir = '~/code/other/nvim-redraft/',
    -- opts = {
    --   provider = 'anthropic',
    --   model = 'claude-3-5-sonnet-20241022',
    --   label = 'Claude 3.5 Sonnet',
    --   debug = true,
    -- },

    config = function()
      require('nvim-redraft').setup {
        llm = {
          models = {
            { provider = 'xai', model = 'grok-4-fast-non-reasoning', label = 'Grok 4 Fast' },
            { provider = 'xai', model = 'grok-code-fast-1', label = 'Grok Code Fast 1' },
            { provider = 'openai', model = 'gpt-4o-mini', label = 'GPT-4o Mini' },
            { provider = 'openai', model = 'gpt-4o', label = 'GPT-4o' },
            { provider = 'anthropic', model = 'claude-haiku-4-5-20251001', label = 'Claude 4.5 Haiku' },
            { provider = 'copilot', model = 'gpt-4o', label = 'Copilot GPT-4o' },
            { provider = 'openrouter', model = 'z-ai/glm-4.5-air', label = 'Z-ai 4.5 Air' },
          },
          default_model_index = 1, -- Optional: start with first model
        },
        debug = false,
        keys = {
          {
            '<leader>ae',
            function()
              require('nvim-redraft').edit()
            end,
            mode = 'v',
            desc = 'AI Edit Selection',
          },
          {
            '<leader>am',
            function()
              require('nvim-redraft').select_model()
            end,
            desc = 'Select AI Model',
          },
        },
      }
    end,
    build = 'cd ts && npm install && npm run build',
  },
}
