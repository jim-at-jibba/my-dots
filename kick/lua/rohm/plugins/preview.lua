return {
  {
    'rmagatti/goto-preview',
    dependencies = { 'rmagatti/logger.nvim' },
    event = 'BufEnter',
    config = function()
      require('goto-preview').setup {
        default_mappings = true,
        references = { -- Configure the telescope UI for slowing the references cycling window.
          provider = 'fzf_lua', -- telescope|fzf_lua|snacks|mini_pick|default
        },
      }
    end,
  },
}
