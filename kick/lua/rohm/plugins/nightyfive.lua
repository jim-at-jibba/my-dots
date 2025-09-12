return {
  'https://github.com/ninetyfive-gg/ninetyfive.nvim',
  config = function()
    require('ninetyfive').setup {
      enable_on_startup = true,
      mappings = {
        enable = true, -- Enable default keybindings
        accept = '<C-e>', -- Now you accept with tab!
        reject = '<C-w>',
      },
      indexing = {
        mode = 'on', -- enables code indexing for better completions. 'ask' by default.
        cache_consent = false, -- optional, defaults to true
      },
    }
  end,
  version = false, -- we don't have versioning in the plugin yet
}
